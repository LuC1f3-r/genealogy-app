import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'person_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Layout constants
// ─────────────────────────────────────────────────────────────────────────────

const double _cW   = 120.0;   // card width
const double _cH   = 134.0;   // card height (portrait area + info area)
const double _cGap = 50.0;    // horizontal gap between husband & wife
const double _sGap = 60.0;    // horizontal gap between sibling subtrees
const double _genH = 300.0;   // vertical distance between generation rows

// ─────────────────────────────────────────────────────────────────────────────
// FamilyTreeCanvas widget
// ─────────────────────────────────────────────────────────────────────────────

class FamilyTreeCanvas extends StatefulWidget {
  const FamilyTreeCanvas({
    super.key,
    required this.nodes,
    this.onPersonTap,
  });

  final List<PersonNode> nodes;
  final ValueChanged<PersonNode>? onPersonTap;

  @override
  State<FamilyTreeCanvas> createState() => _FamilyTreeCanvasState();
}

class _FamilyTreeCanvasState extends State<FamilyTreeCanvas> {
  String? _selectedId;
  bool _legendVisible = true;

  // ── Internal maps built once per layout pass ──────────────────────────────
  late Map<String, PersonNode> _nm;
  late Set<String>             _ids;
  late Set<String>             _wifeIds;
  final Map<String, double>    _subtreeW = {};

  // ── Init ─────────────────────────────────────────────────────────────────
  void _init() {
    _nm      = {for (final n in widget.nodes) n.id: n};
    _ids     = widget.nodes.map((n) => n.id).toSet();
    _wifeIds = {for (final n in widget.nodes) if (n.isSpouseOf != null) n.id};
    _subtreeW.clear();
    for (final n in widget.nodes) {
      if (!_wifeIds.contains(n.id)) _measureSubtree(n.id);
    }
  }

  // ── Subtree-width measurement (recursive) ────────────────────────────────
  double _measureSubtree(String id) {
    if (_subtreeW.containsKey(id)) return _subtreeW[id]!;
    final node = _nm[id];
    if (node == null) { _subtreeW[id] = _cW; return _cW; }

    final wives = _spousesOf(id);
    double w;

    if (wives.isNotEmpty) {
      // Couple row width: (num-wives + 1) cards + gaps.
      final rowW = (wives.length + 1) * _cW + wives.length * _cGap;

      // Children block width: sum of each wife's children subtree.
      double childW = 0;
      for (int i = 0; i < wives.length; i++) {
        if (i > 0) childW += _sGap;
        childW += _wifeSubtreeW(wives[i]);
      }
      w = math.max(rowW, math.max(childW, _cW));
    } else {
      final kids = _childrenOf(id);
      if (kids.isNotEmpty) {
        w = kids.fold(0.0, (s, c) => s + _measureSubtree(c)) +
            (kids.length - 1) * _sGap;
      } else {
        w = _cW;
      }
    }
    _subtreeW[id] = w;
    return w;
  }

  double _wifeSubtreeW(String wid) {
    final kids = _wifeChildrenOf(wid);
    if (kids.isEmpty) return _cW;
    return kids.fold(0.0, (s, c) => s + _measureSubtree(c)) +
        (kids.length - 1) * _sGap;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  List<String> _spousesOf(String id) =>
      (_nm[id]?.allSpouseIds ?? []).where(_ids.contains).toList();

  List<String> _childrenOf(String id) =>
      (_nm[id]?.childIds ?? [])
          .where((c) => _ids.contains(c) && !_wifeIds.contains(c))
          .toList();

  List<String> _wifeChildrenOf(String wid) =>
      (_nm[wid]?.childIds ?? [])
          .where((c) => _ids.contains(c) && !_wifeIds.contains(c))
          .toList();

  // ── Layout computation ────────────────────────────────────────────────────
  Map<String, Offset> _computeLayout() {
    _init();

    // Roots: nodes with no parents in the dataset and not spouse cards.
    final roots = widget.nodes.where((n) {
      if (_wifeIds.contains(n.id)) return false;
      return n.parentIds.isEmpty || n.parentIds.every((p) => !_ids.contains(p));
    }).toList();

    final pos = <String, Offset>{};
    double rx = 0;
    for (final r in roots) {
      _placeSubtree(r.id, rx, 0, pos);
      rx += _measureSubtree(r.id) + _sGap;
    }
    if (pos.isEmpty) return {};

    // Normalise: shift everything so min coords = (padding, padding).
    const pad = 48.0;
    final minX = pos.values.map((o) => o.dx).reduce(math.min);
    final minY = pos.values.map((o) => o.dy).reduce(math.min);
    final dx = -minX + pad;
    final dy = -minY + pad;
    return pos.map((k, v) => MapEntry(k, v + Offset(dx, dy)));
  }

  void _placeSubtree(
      String manId, double left, double y, Map<String, Offset> pos) {
    final wives = _spousesOf(manId);

    if (wives.isEmpty) {
      // No spouse — centre man within his subtree width.
      final w = _measureSubtree(manId);
      pos[manId] = Offset(left + (w - _cW) / 2, y);
      double kx = left;
      for (final kid in _childrenOf(manId)) {
        _placeSubtree(kid, kx, y + _cH + _genH, pos);
        kx += _measureSubtree(kid) + _sGap;
      }
      return;
    }

    // Compute allocation.
    final wChildWs  = [for (final w in wives) _wifeSubtreeW(w)];
    final totalChildW = wChildWs.fold(0.0, (s, v) => s + v) +
        (wives.length - 1) * _sGap;
    final rowW   = (wives.length + 1) * _cW + wives.length * _cGap;
    final alloc  = math.max(rowW, totalChildW);

    final rowLeft   = left + (alloc - rowW) / 2;
    final childLeft = left + (alloc - totalChildW) / 2;

    // ── Position couple row ─────────────────────────────────────────────────
    if (wives.length == 1) {
      // [Man] ──♥── [Wife]
      pos[manId]    = Offset(rowLeft, y);
      pos[wives[0]] = Offset(rowLeft + _cW + _cGap, y);
    } else if (wives.length == 2) {
      // [Wife1] ──♥── [Man] ──♥── [Wife2]
      pos[wives[0]] = Offset(rowLeft, y);
      pos[manId]    = Offset(rowLeft + _cW + _cGap, y);
      pos[wives[1]] = Offset(rowLeft + 2 * (_cW + _cGap), y);
    } else {
      // Man leftmost, wives chain to the right.
      pos[manId] = Offset(rowLeft, y);
      for (int i = 0; i < wives.length; i++) {
        pos[wives[i]] = Offset(rowLeft + (i + 1) * (_cW + _cGap), y);
      }
    }

    // ── Place children ──────────────────────────────────────────────────────
    double kLeft = childLeft;
    for (int i = 0; i < wives.length; i++) {
      final wid = wives[i];
      final cw  = wChildWs[i];
      double kx = kLeft;
      for (final kid in _wifeChildrenOf(wid)) {
        _placeSubtree(kid, kx, y + _cH + _genH, pos);
        kx += _measureSubtree(kid) + _sGap;
      }
      kLeft += cw + _sGap;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final layout = _computeLayout();
    if (layout.isEmpty) {
      return const Center(child: Text('No family data yet.'));
    }

    final maxX = layout.values.map((o) => o.dx).reduce(math.max) + _cW + 64;
    final maxY = layout.values.map((o) => o.dy).reduce(math.max) + _cH + 64;
    final screen = MediaQuery.of(context).size;

    return Stack(
      children: [
        // ── Background grid ──────────────────────────────────────────────
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),

        // ── Pannable / zoomable tree ────────────────────────────────────
        InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.18,
          maxScale: 3.5,
          child: SizedBox(
            width:  math.max(maxX, screen.width  * 1.5),
            height: math.max(maxY, screen.height * 1.5),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Connection lines.
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TreePainter(
                      nodes:     widget.nodes,
                      positions: layout,
                      wifeIds:   _wifeIds,
                      nm:        _nm,
                      ids:       _ids,
                    ),
                  ),
                ),

                // Person cards.
                for (final node in widget.nodes)
                  if (layout.containsKey(node.id))
                    Positioned(
                      left: layout[node.id]!.dx,
                      top:  layout[node.id]!.dy,
                      width: _cW,
                      child: PersonCard(
                        person:      node,
                        isSelected:  _selectedId == node.id,
                        isSpouseCard: _wifeIds.contains(node.id),
                        onTap: () {
                          setState(() => _selectedId = node.id);
                          widget.onPersonTap?.call(node);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),

        // ── Legend panel (top-left, collapsible) ────────────────────────
        Positioned(
          top: 12,
          left: 12,
          child: _LegendPanel(
            visible: _legendVisible,
            onToggle: () => setState(() => _legendVisible = !_legendVisible),
          ),
        ),

        // ── Zoom hint (bottom-right) ────────────────────────────────────
        Positioned(
          bottom: 12,
          right: 12,
          child: _ZoomHint(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tree Painter — draws all connection lines
// ─────────────────────────────────────────────────────────────────────────────

class _TreePainter extends CustomPainter {
  const _TreePainter({
    required this.nodes,
    required this.positions,
    required this.wifeIds,
    required this.nm,
    required this.ids,
  });

  final List<PersonNode>        nodes;
  final Map<String, Offset>     positions;
  final Set<String>             wifeIds;
  final Map<String, PersonNode> nm;
  final Set<String>             ids;

  @override
  void paint(Canvas canvas, Size size) {
    for (final node in nodes) {
      if (wifeIds.contains(node.id)) continue;
      final manPos = positions[node.id];
      if (manPos == null) continue;

      final wives = node.allSpouseIds.where(ids.contains).toList();

      if (wives.isEmpty) {
        // Solo parent — draw blood lines to children.
        final kids = node.childIds
            .where((c) => ids.contains(c) && !wifeIds.contains(c))
            .toList();
        if (kids.isNotEmpty) {
          final from = Offset(manPos.dx + _cW / 2, manPos.dy + _cH);
          _drawChildConnectors(canvas, from, kids);
        }
        continue;
      }

      // ── Marriage bar ─────────────────────────────────────────────────────
      // barY is drawn at ~42% down the man card so it sits mid-card.
      final barY = manPos.dy + _cH * 0.42;
      final manCX = manPos.dx + _cW / 2;

      // Compute the full extent of the bar: spans from leftmost to rightmost
      // of all card centres AND children-drop points, so every drop is
      // visually attached to the bar.
      double barL = manCX;
      double barR = manCX;
      for (final wid in wives) {
        final wp = positions[wid];
        if (wp != null) {
          final cx = wp.dx + _cW / 2;
          barL = math.min(barL, cx);
          barR = math.max(barR, cx);
        }
      }

      // Draw the single continuous marriage bar.
      canvas.drawLine(
        Offset(barL, barY),
        Offset(barR, barY),
        Paint()
          ..color = AppColors.marriage
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );

      // Draw heart-dot or ✕ at the midpoint of each man↔wife segment.
      for (final wid in wives) {
        final wp       = positions[wid];
        final wifeNode = nm[wid];
        if (wp == null || wifeNode == null) continue;

        final wifeCX     = wp.dx + _cW / 2;
        final junctionX  = (manCX + wifeCX) / 2;
        final isDivorced = wifeNode.divorcedFrom != null &&
            wifeNode.divorcedFrom!.isNotEmpty;

        if (isDivorced) {
          _drawDivorceX(canvas, Offset(junctionX, barY));
        } else {
          _drawHeartDot(canvas, Offset(junctionX, barY));
        }
      }

      // ── Child drops from each husband-wife junction on the bar ─────────
      for (final wid in wives) {
        final wp = positions[wid];
        if (wp == null) continue;
        final wifeCX = wp.dx + _cW / 2;
        final junctionX = (manCX + wifeCX) / 2;

        final wife = nm[wid];
        if (wife == null) continue;
        final kids = wife.childIds
            .where((c) => ids.contains(c) && !wifeIds.contains(c))
            .toList();
        if (kids.isEmpty) continue;
        _drawChildConnectors(canvas, Offset(junctionX, barY), kids);
      }
    }
  }

  // ── Heart dot on marriage bar ───────────────────────────────────────────
  void _drawHeartDot(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      4.0,
      Paint()
        ..color = AppColors.marriage
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      4.0,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      2.5,
      Paint()
        ..color = AppColors.marriage
        ..style = PaintingStyle.fill,
    );
  }

  // ── Divorce ✕ mark ─────────────────────────────────────────────────────
  void _drawDivorceX(Canvas canvas, Offset center) {
    const r = 5.5;
    final p = Paint()
      ..color = AppColors.divorceLine
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // White circle background.
    canvas.drawCircle(center, r + 1.5,
        Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawLine(
        center + const Offset(-r, -r), center + const Offset(r, r), p);
    canvas.drawLine(
        center + const Offset(r, -r), center + const Offset(-r, r), p);
  }

  // ── Child connectors (blood or adoptive) ────────────────────────────────
  void _drawChildConnectors(Canvas canvas, Offset from, List<String> kidIds) {
    // Vertical stem down to the mid-level bus.
    final midY = from.dy + _genH * 0.48;
    canvas.drawLine(from, Offset(from.dx, midY),
        _bloodPaint());

    final kidTops = kidIds
        .map((id) => positions[id])
        .whereType<Offset>()
        .map((o) => o + const Offset(_cW / 2, 0))
        .toList();
    if (kidTops.isEmpty) return;

    final lx = math.min(from.dx, kidTops.map((t) => t.dx).reduce(math.min));
    final rx = math.max(from.dx, kidTops.map((t) => t.dx).reduce(math.max));

    // Horizontal bus.
    if (lx < rx) {
      canvas.drawLine(Offset(lx, midY), Offset(rx, midY), _bloodPaint());
    }

    // Drop lines to each child — dashed for adoptive.
    for (final kid in kidIds) {
      final kidPos = positions[kid];
      if (kidPos == null) continue;
      final kidNode = nm[kid];
      final isAdoptive = kidNode?.childRelType == ChildRelType.adoptive;
      final x = kidPos.dx + _cW / 2;

      if (isAdoptive) {
        _drawDashed(canvas, Offset(x, midY), Offset(x, kidPos.dy),
            AppColors.adoptiveLine, 5.0, 4.0);
      } else {
        canvas.drawLine(Offset(x, midY), Offset(x, kidPos.dy), _bloodPaint());
      }

      // Twin star between sibling drops.
      if (kidNode?.twinSiblingId != null) {
        _drawTwinStar(canvas, Offset(x, midY + (kidPos.dy - midY) * 0.45));
      }
    }
  }

  Paint _bloodPaint() => Paint()
    ..color = AppColors.bloodLine.withValues(alpha: 0.70)
    ..strokeWidth = 1.6
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke;

  // ── Dashed line ─────────────────────────────────────────────────────────
  void _drawDashed(Canvas canvas, Offset from, Offset to,
      Color color, double dashLen, double gapLen) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final dist = (to - from).distance;
    if (dist == 0) return;
    final dir = (to - from) / dist;
    double drawn = 0;
    while (drawn < dist) {
      final s = from + dir * drawn;
      final e = from + dir * math.min(drawn + dashLen, dist);
      canvas.drawLine(s, e, p);
      drawn += dashLen + gapLen;
    }
  }

  // ── Twin star marker ────────────────────────────────────────────────────
  void _drawTwinStar(Canvas canvas, Offset center) {
    final path = Path();
    const n = 5;
    const r1 = 5.5, r2 = 2.5;
    for (int i = 0; i < n * 2; i++) {
      final angle = (i * math.pi / n) - math.pi / 2;
      final r = i.isEven ? r1 : r2;
      final pt = Offset(center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();

    canvas.drawPath(
        path, Paint()..color = AppColors.twinsMarker..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(_TreePainter o) =>
      o.nodes != nodes || o.positions != positions;
}

// ─────────────────────────────────────────────────────────────────────────────
// Background grid painter
// ─────────────────────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.18)
      ..style  = PaintingStyle.fill;
    const step = 28.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, p);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Legend panel
// ─────────────────────────────────────────────────────────────────────────────

class _LegendPanel extends StatelessWidget {
  const _LegendPanel({required this.visible, required this.onToggle});
  final bool visible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(maxWidth: 172),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row.
              InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: Row(
                    children: [
                      Text(
                        'LEGEND',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurface,
                          fontSize: 9,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        visible ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.outline,
                      ),
                    ],
                  ),
                ),
              ),

              // Collapsible body.
              if (visible) ...[
                Container(
                  height: 0.5,
                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LRow.solidLine(
                        color: AppColors.marriage,
                        label: 'Married',
                        extraWidget: _heartIcon(),
                      ),
                      _LRow.solidLine(
                        color: AppColors.divorceLine,
                        label: 'Divorced',
                        extraWidget: _xIcon(),
                      ),
                      _LRow.solidLine(
                        color: AppColors.bloodLine,
                        label: 'Biological child',
                      ),
                      _LRow.dashedLine(
                        color: AppColors.adoptiveLine,
                        label: 'Adoptive child',
                      ),
                      _LRow.badge(
                        color: AppColors.heirLine,
                        label: 'Heir',
                        badgeLabel: 'HEIR',
                      ),
                      _LRow.icon(
                        icon: Icons.star_rounded,
                        color: AppColors.twinsMarker,
                        label: 'Twins',
                      ),
                      _LRow.dot(
                        color: const Color(0xFF4ADE80),
                        label: 'Living',
                      ),
                      const SizedBox(height: 6),
                      // Gender colour guide.
                      Text(
                        'GENDER',
                        style: AppTextStyles.labelSm.copyWith(
                            fontSize: 8, color: AppColors.outline),
                      ),
                      const SizedBox(height: 5),
                      _LRow.gradBox(
                        from: AppColors.maleCardStart,
                        to:   AppColors.maleCardEnd,
                        label: 'Male',
                      ),
                      _LRow.gradBox(
                        from: AppColors.femaleCardStart,
                        to:   AppColors.femaleCardEnd,
                        label: 'Female',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _heartIcon() => Container(
    width: 8, height: 8,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.marriage,
    ),
  );

  Widget _xIcon() => const Icon(
    Icons.close_rounded,
    size: 10,
    color: AppColors.divorceLine,
  );
}

class _LRow extends StatelessWidget {
  const _LRow._({required this.leading, required this.label});

  final Widget leading;
  final String label;

  factory _LRow.solidLine({
    required Color color,
    required String label,
    Widget? extraWidget,
  }) =>
      _LRow._(
        leading: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 18, height: 2.5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              )),
          if (extraWidget != null) ...[
            const SizedBox(width: 3),
            extraWidget,
          ],
        ]),
        label: label,
      );

  factory _LRow.dashedLine({
    required Color color,
    required String label,
  }) =>
      _LRow._(
        leading: CustomPaint(
          size: const Size(24, 4),
          painter: _DashLinePainter(color: color),
        ),
        label: label,
      );

  factory _LRow.badge({
    required Color color,
    required String label,
    required String badgeLabel,
  }) =>
      _LRow._(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(badgeLabel,
              style: const TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3)),
        ),
        label: label,
      );

  factory _LRow.icon({
    required IconData icon,
    required Color color,
    required String label,
  }) =>
      _LRow._(
        leading: Icon(icon, size: 14, color: color),
        label: label,
      );

  factory _LRow.dot({
    required Color color,
    required String label,
  }) =>
      _LRow._(
        leading: Container(
          width: 8, height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        label: label,
      );

  factory _LRow.gradBox({
    required Color from,
    required Color to,
    required String label,
  }) =>
      _LRow._(
        leading: Container(
          width: 20, height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [from, to]),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        label: label,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 38, child: Center(child: leading)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.onSurface,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashLinePainter extends CustomPainter {
  const _DashLinePainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height / 2),
          Offset(math.min(x + 4, size.width), size.height / 2), p);
      x += 7;
    }
  }
  @override bool shouldRepaint(_DashLinePainter o) => o.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Zoom hint
// ─────────────────────────────────────────────────────────────────────────────

class _ZoomHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pinch_rounded, size: 13, color: AppColors.outline),
              SizedBox(width: 6),
              Text(
                'Pinch · Drag',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
