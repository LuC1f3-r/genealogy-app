import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'person_card.dart';

const double _cW   = 148.0;
const double _cH   = 108.0;
const double _cGap = 28.0;   // gap between man & wife cards in a couple
const double _sGap = 80.0;   // gap between sibling subtrees
const double _genH = 200.0;  // vertical gap between generations
const _marriageColor = Color(0xFFB5476A);

class FamilyTreeCanvas extends StatefulWidget {
  const FamilyTreeCanvas({super.key, required this.nodes, this.onPersonTap});
  final List<PersonNode> nodes;
  final ValueChanged<PersonNode>? onPersonTap;
  @override
  State<FamilyTreeCanvas> createState() => _FamilyTreeCanvasState();
}

class _FamilyTreeCanvasState extends State<FamilyTreeCanvas> {
  String? _selectedId;

  late Map<String, PersonNode> _nm;
  late Set<String> _ids;
  late Set<String> _wifeIds;
  final Map<String, double> _pw   = {};
  final Map<String, double> _dropX = {}; // canvas-X where children connector drops

  void _init() {
    _nm     = {for (final n in widget.nodes) n.id: n};
    _ids    = widget.nodes.map((n) => n.id).toSet();
    _wifeIds = {for (final n in widget.nodes) if (n.isSpouseOf != null) n.id};
    _pw.clear();
    _dropX.clear();
    for (final n in widget.nodes) {
      if (!_wifeIds.contains(n.id)) _spineW(n.id);
    }
  }

  double _spineW(String id) {
    if (_pw.containsKey(id)) return _pw[id]!;
    final man  = _nm[id];
    if (man == null) { _pw[id] = _cW; return _cW; }
    final wives = _validWives(id);
    final kids  = _spineKids(id);
    double w;
    if (wives.isNotEmpty) {
      final coupleRow = (wives.length + 1) * _cW + wives.length * _cGap;
      double childTot = 0;
      for (int i = 0; i < wives.length; i++) {
        if (i > 0) childTot += _sGap;
        childTot += _wifeChildrenW(wives[i]);
      }
      w = math.max(coupleRow, math.max(childTot, _cW));
    } else if (kids.isNotEmpty) {
      w = kids.fold(0.0, (s, c) => s + _spineW(c)) + (kids.length - 1) * _sGap;
    } else {
      w = _cW;
    }
    _pw[id] = w;
    return w;
  }

  double _wifeChildrenW(String wid) {
    final kids = _wifeKids(wid);
    if (kids.isEmpty) return _cW;
    return kids.fold(0.0, (s, c) => s + _spineW(c)) + (kids.length - 1) * _sGap;
  }

  List<String> _validWives(String id) =>
      (_nm[id]?.allSpouseIds ?? []).where(_ids.contains).toList();

  List<String> _spineKids(String id) =>
      (_nm[id]?.childIds ?? [])
          .where((c) => _ids.contains(c) && !_wifeIds.contains(c))
          .toList();

  List<String> _wifeKids(String wid) =>
      (_nm[wid]?.childIds ?? [])
          .where((c) => _ids.contains(c) && !_wifeIds.contains(c))
          .toList();

  Map<String, Offset> _computeLayout() {
    _init();
    final roots = widget.nodes.where((n) {
      if (_wifeIds.contains(n.id)) return false;
      return n.parentIds.isEmpty || n.parentIds.every((p) => !_ids.contains(p));
    }).toList();

    final pos = <String, Offset>{};
    double rx = 0;
    for (final r in roots) {
      _place(r.id, rx, 0, pos);
      rx += _spineW(r.id) + _sGap;
    }
    if (pos.isEmpty) return {};

    final minX = pos.values.map((o) => o.dx).reduce(math.min);
    final minY = pos.values.map((o) => o.dy).reduce(math.min);
    const pad = 60.0;
    final dx = -minX + pad;
    final dy = -minY + pad;
    _dropX.updateAll((k, v) => v + dx);
    return pos.map((k, v) => MapEntry(k, v + Offset(dx, dy)));
  }

  void _place(String manId, double left, double y, Map<String, Offset> pos) {
    final wives = _validWives(manId);

    if (wives.isEmpty) {
      final w = _spineW(manId);
      pos[manId] = Offset(left + (w - _cW) / 2, y);
      double kx = left;
      for (final kid in _spineKids(manId)) {
        _place(kid, kx, y + _cH + _genH, pos);
        kx += _spineW(kid) + _sGap;
      }
      return;
    }

    final wChildW = [for (final w in wives) _wifeChildrenW(w)];
    final childTot = wChildW.fold(0.0, (s, v) => s + v) +
        (wives.length - 1) * _sGap;
    final rowW  = (wives.length + 1) * _cW + wives.length * _cGap;
    final alloc = math.max(rowW, childTot);

    // Children block and card row are each centred within allocation.
    final childLeft = left + (alloc - childTot) / 2;
    final rowLeft   = left + (alloc - rowW) / 2;

    // ── Place cards ─────────────────────────────────────────────────────────
    if (wives.length == 1) {
      // [Man] ——♥—— [Wife]
      pos[manId]    = Offset(rowLeft, y);
      pos[wives[0]] = Offset(rowLeft + _cW + _cGap, y);
    } else if (wives.length == 2) {
      // [Wife1] ——♥—— [Man] ——♥—— [Wife2]
      pos[wives[0]] = Offset(rowLeft, y);
      pos[manId]    = Offset(rowLeft + _cW + _cGap, y);
      pos[wives[1]] = Offset(rowLeft + 2 * (_cW + _cGap), y);
    } else {
      // Man on left, wives chained to the right.
      pos[manId] = Offset(rowLeft, y);
      for (int i = 0; i < wives.length; i++) {
        pos[wives[i]] = Offset(rowLeft + (i + 1) * (_cW + _cGap), y);
      }
    }

    // ── Place children and store dropX ───────────────────────────────────────
    double kLeft = childLeft;
    for (int i = 0; i < wives.length; i++) {
      final wid = wives[i];
      final cw  = wChildW[i];
      _dropX[wid] = kLeft + cw / 2;   // centre of this wife's children block
      double kx = kLeft;
      for (final kid in _wifeKids(wid)) {
        _place(kid, kx, y + _cH + _genH, pos);
        kx += _spineW(kid) + _sGap;
      }
      kLeft += cw + _sGap;
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = _computeLayout();
    if (layout.isEmpty) return const Center(child: Text('No family data'));

    final maxX  = layout.values.map((o) => o.dx).reduce(math.max) + _cW + 80;
    final maxY  = layout.values.map((o) => o.dy).reduce(math.max) + _cH + 80;
    final screen = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        Positioned(top: 16, right: 16, child: _Legend()),
        Positioned(bottom: 16, right: 16, child: _ZoomHint()),
        InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.2, maxScale: 3.5,
          child: SizedBox(
            width:  math.max(maxX, screen.width  * 1.4),
            height: math.max(maxY, screen.height * 1.4),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TreePainter(
                      nodes: widget.nodes, positions: layout,
                      wifeIds: _wifeIds, nm: _nm, ids: _ids,
                      dropX: Map.of(_dropX),
                    ),
                  ),
                ),
                for (final node in widget.nodes)
                  if (layout.containsKey(node.id))
                    Positioned(
                      left: layout[node.id]!.dx,
                      top:  layout[node.id]!.dy,
                      width: _cW,
                      child: PersonCard(
                        person: node,
                        isSelected: _selectedId == node.id,
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
      ],
    );
  }
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _TreePainter extends CustomPainter {
  const _TreePainter({
    required this.nodes, required this.positions, required this.wifeIds,
    required this.nm,    required this.ids,        required this.dropX,
  });

  final List<PersonNode>      nodes;
  final Map<String, Offset>   positions;
  final Set<String>           wifeIds;
  final Map<String, PersonNode> nm;
  final Set<String>           ids;
  final Map<String, double>   dropX;

  @override
  void paint(Canvas canvas, Size size) {
    final mp = Paint()
      ..color = _marriageColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cp = Paint()
      ..color = const Color(0xFF6B7280).withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    for (final node in nodes) {
      if (wifeIds.contains(node.id)) continue;
      final manPos = positions[node.id];
      if (manPos == null) continue;

      final wives = node.allSpouseIds.where(ids.contains).toList();

      if (wives.isEmpty) {
        final kids = node.childIds
            .where((c) => ids.contains(c) && !wifeIds.contains(c))
            .toList();
        if (kids.isNotEmpty) {
          _childConnectors(canvas, cp,
              Offset(manPos.dx + _cW / 2, manPos.dy + _cH), kids);
        }
        continue;
      }

      // ── Marriage bar ─────────────────────────────────────────────────────
      final barY = manPos.dy + _cH * 0.40;

      // Collect all X positions of cards in this couple row.
      final cardXs = <double>[manPos.dx];
      for (final wid in wives) {
        final wp = positions[wid];
        if (wp != null) cardXs.add(wp.dx);
      }
      cardXs.sort();

      // Bar spans from right of leftmost card to left of rightmost card,
      // extended outward to cover each wife's dropX.
      double barL = cardXs.first + _cW;
      double barR = cardXs.last;
      for (final wid in wives) {
        final dx = dropX[wid];
        if (dx != null) { barL = math.min(barL, dx); barR = math.max(barR, dx); }
      }
      canvas.drawLine(Offset(barL, barY), Offset(barR, barY), mp);

      // Small dot at each card-junction on the bar (between adjacent cards only).
      for (int i = 0; i < cardXs.length - 1; i++) {
        final jx = cardXs[i] + _cW + _cGap / 2;
        // Only draw the dot if it lies on the bar.
        if (jx >= barL && jx <= barR) {
          canvas.drawCircle(Offset(jx, barY), 3.5,
              Paint()..color = _marriageColor..style = PaintingStyle.fill);
        }
      }

      // ── Child connectors from each wife's dropX ──────────────────────────
      for (final wid in wives) {
        final dx   = dropX[wid];
        final wife = nm[wid];
        if (dx == null || wife == null) continue;
        final kids = wife.childIds
            .where((c) => ids.contains(c) && !wifeIds.contains(c))
            .toList();
        if (kids.isEmpty) continue;
        _childConnectors(canvas, cp, Offset(dx, barY), kids);
      }
    }
  }

  void _childConnectors(Canvas canvas, Paint p, Offset from, List<String> kids) {
    final midY = from.dy + _genH / 2;
    canvas.drawLine(from, Offset(from.dx, midY), p);

    final tops = kids
        .map((id) => positions[id])
        .whereType<Offset>()
        .map((o) => Offset(o.dx + _cW / 2, o.dy))
        .toList();
    if (tops.isEmpty) return;

    final lx = tops.map((t) => t.dx).reduce(math.min);
    final rx = tops.map((t) => t.dx).reduce(math.max);
    if (lx < rx) canvas.drawLine(Offset(lx, midY), Offset(rx, midY), p);
    for (final t in tops) {
      canvas.drawLine(Offset(t.dx, midY), t, p);
    }
  }

  @override
  bool shouldRepaint(_TreePainter o) =>
      o.nodes != nodes || o.positions != positions;
}

// ─── Grid ─────────────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width + 30; x += 30) {
      for (double y = 0; y < size.height + 30; y += 30) {
        canvas.drawCircle(Offset(x, y), 1.0, p);
      }
    }
  }
  @override bool shouldRepaint(_GridPainter _) => false;
}

// ─── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainer.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      boxShadow: [BoxShadow(
          color: AppColors.onSurface.withValues(alpha: 0.07),
          blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('LEGEND', style: TextStyle(
            fontSize: 9, fontWeight: FontWeight.w800,
            color: AppColors.outline, letterSpacing: 1.5)),
        SizedBox(height: 8),
        _LRow(color: _marriageColor,          label: 'Marriage'),
        SizedBox(height: 5),
        _LRow(color: Color(0xFF6B7280), label: 'Parent → Child'),
        SizedBox(height: 5),
        _LRow(color: Color(0xFF7189A8), label: 'Male'),
        SizedBox(height: 5),
        _LRow(color: Color(0xFFC17B8A), label: 'Female'),
      ],
    ),
  );
}

class _LRow extends StatelessWidget {
  const _LRow({required this.color, required this.label});
  final Color color; final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 20, height: 2.5, color: color),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(
          fontSize: 10, color: AppColors.onSurface.withValues(alpha: 0.8))),
    ],
  );
}

// ─── Zoom hint ────────────────────────────────────────────────────────────────

class _ZoomHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainer.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
    ),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.pinch, size: 13, color: AppColors.outline),
      SizedBox(width: 6),
      Text('Pinch · Drag to pan',
          style: TextStyle(fontSize: 10, color: AppColors.outline)),
    ]),
  );
}
