import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../auth/auth_provider.dart';
import 'providers/tree_provider.dart';
import 'widgets/add_person_sheet.dart';
import 'widgets/family_tree_canvas.dart';
import 'widgets/person_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Seed data — exported so tree_provider.dart can push it to Firestore
// ─────────────────────────────────────────────────────────────────────────────

/// The initial Janvekar family dataset.
/// This list is pushed to Firestore ONE TIME on first admin sign-in via
/// [seedIfEmptyProvider]. After that, all data comes from Firestore.
const kSeedNodes = <PersonNode>[
  PersonNode(
    id: 'main-root',
    name: 'Adbul Rehman',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    childIds: ['sub-main-root'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'sub-main-root',
    name: 'Gaibi Sab',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['main-root'],
    childIds: ['dad-root'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'dad-root',
    name: 'Makatoom Sab',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['sub-main-root'],
    childIds: ['root'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'root',
    name: 'Abba Saheb',
    dob: '1832',
    dod: '1936',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['wife1', 'wife2'],
    parentIds: ['dad-root'],
    childIds: [
      's1',
      's2',
      'd1',
      's3',
      'd2',
      's4',
      'd3',
      'd4',
      's5',
      'd5',
      's6',
      'd6'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'wife1',
    name: 'Nadanma',
    dod: '1904',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 'root',
    childIds: ['s1', 's2', 'd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'wife2',
    name: 'Ayeshama',
    dod: '09/1975',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 'root',
    childIds: ['s3', 'd2', 's4', 'd3', 'd4', 's5', 'd5', 's6', 'd6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's1',
    name: 'Dewan Saheb',
    dod: '1928',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife1'],
    spouseIds: ['s1w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's1w',
    name: 'Amirma',
    dod: '1928',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's1',
    spouseIds: ['s1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2',
    name: 'Khalilulha',
    dod: '06/1984',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife1'],
    spouseIds: ['s2w1', 's2w2', 's2w3', 's2w4'],
    childIds: [
      'gd1',
      'gd2',
      'gd3',
      'gs1',
      'gd4',
      'gd5',
      'gd6',
      'gs2',
      'gs3',
      'gs4',
      'gs5',
      'gs6',
      'gs7',
      'gs8',
      'gs9',
      'gs10',
      'gd7',
      'gd8',
      'gd9',
      'gd10',
      'gd11',
      'gd12',
      'gd13'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w1',
    name: 'Rabiya',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: ['gd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd1',
    name: 'Majan',
    dod: '12/2009',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w1'],
    spouseIds: ['gd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd1h',
    name: 'Ibrahim',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w2',
    name: 'Booma',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: ['gd2', 'gd3', 'gs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd2',
    name: 'Zulekha',
    dod: '05/2014',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    spouseIds: ['gd2h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd2h',
    name: 'Abbasab',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd3',
    name: 'Halima',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    spouseIds: ['gd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd3h',
    name: 'Majeed',
    dod: '07/2015',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs1',
    name: 'Nizamuddin',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    spouseIds: ['gs1w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs1w',
    name: 'Majan',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w3',
    name: 'Ameerabi',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: [
      'gd4',
      'gd5',
      'gd6',
      'gs2',
      'gs3',
      'gs4',
      'gs5',
      'gs6',
      'gs7',
      'gs8'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd4',
    name: 'Maherunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd5',
    name: 'Hifzunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd6',
    name: 'Shahenaz',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs2',
    name: 'Ismail',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    spouseIds: ['gs2w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs2w',
    name: 'Qamarunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs3',
    name: 'Munir',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs4',
    name: 'Hidayat',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs5',
    name: 'Zakriya',
    dod: '07/2020',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs6',
    name: 'Shabbir',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    spouseIds: ['gs6w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs6w',
    name: 'Noorjahan',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs7',
    name: 'Rafiq',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs8',
    name: 'Altamash',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w4',
    name: 'Ratanbi',
    dod: '11/1989',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: [
      'gs9',
      'gs10',
      'gd7',
      'gd8',
      'gd9',
      'gd10',
      'gd11',
      'gd12',
      'gd13'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs9',
    name: 'Mohd. Irfan',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gs9w'],
    childIds: ['ggs7', 'ggd6', 'ggs8'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs9w',
    name: 'Safiya Begum',
    dod: '05/2020',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs9'],
    childIds: ['ggs7', 'ggd6', 'ggs8'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs7',
    name: 'Asif',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gs9', 'gs9w'],
    spouseIds: ['ggs7w'],
    childIds: ['gggs4', 'gggd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs7w',
    name: 'Nilofer',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    spouseIds: ['ggs7'],
    childIds: ['gggs4', 'gggd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggs4',
    name: 'Salman',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['ggs7', 'ggs7w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggd1',
    name: 'Noora',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['ggs7', 'ggs7w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd6',
    name: 'Gazala',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['gs9', 'gs9w'],
    spouseIds: ['ggd6h'],
    childIds: ['gggd2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd6h',
    name: 'Waheed',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    spouseIds: ['ggd6'],
    childIds: ['gggd2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggd2',
    name: 'Khairunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['ggd6', 'ggd6h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs8',
    name: 'Abu Talib',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gs9', 'gs9w'],
    spouseIds: ['ggs8w'],
    childIds: ['gggs5', 'gggd3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs8w',
    name: 'Sabina',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    spouseIds: ['ggs8'],
    childIds: ['gggs5', 'gggd3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggs5',
    name: 'Abu Sufiyan',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['ggs8', 'ggs8w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggd3',
    name: 'Sara',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['ggs8', 'ggs8w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs10',
    name: 'Maheboob',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd7',
    name: 'Shazadi Batul',
    dob: '03/1941',
    dod: '02/2003',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gd7h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd7h',
    name: 'Peerpasha',
    dod: '10/2006',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd7'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd8',
    name: 'Bilqis Banu',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gd8h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd8h',
    name: 'Khursheed Ahmed',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd8'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd9',
    name: 'Qudsia Begum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gd9h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd9h',
    name: 'Fakhrou Beg',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd9'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd10',
    name: 'Azra Begum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gd10h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd10h',
    name: 'Iqbal Pasha',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd10'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd11',
    name: 'Ziya Banu',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    spouseIds: ['gd11h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd11h',
    name: 'Amil Khan',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd11'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd12',
    name: 'Saleha Banu',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd13',
    name: 'Ifthekharunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd1',
    name: 'Fatimabi',
    dod: '1959',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife1'],
    spouseIds: ['d1h'],
    childIds: [
      'gd14',
      'gd15',
      'gd16',
      'gd17',
      'gs11',
      'gs12',
      'gs13',
      'gs14',
      'gs15'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd1h',
    name: 'Abdul Qader Jilani',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['d1'],
    childIds: [
      'gd14',
      'gd15',
      'gd16',
      'gd17',
      'gs11',
      'gs12',
      'gs13',
      'gs14',
      'gs15'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd14',
    name: 'Halimabi',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd15',
    name: 'Jannatbi',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    spouseIds: ['gd15h'],
    childIds: ['ggs1', 'ggs2', 'ggd1', 'ggd2', 'ggd3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd15h',
    name: 'Tajuddin',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd15'],
    childIds: ['ggs1', 'ggs2', 'ggd1', 'ggd2', 'ggd3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs1',
    name: 'Isamuddin',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['gd15', 'gd15h'],
    childIds: ['gggs1', 'gggs2', 'gggs3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggs1',
    name: 'Qayyum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['ggs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggs2',
    name: 'Fazale Karim',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['ggs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gggs3',
    name: 'Munna',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['ggs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs2',
    name: 'Sirajuddin',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['gd15', 'gd15h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd1',
    name: 'Badrunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['gd15', 'gd15h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd2',
    name: 'Najma',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['gd15', 'gd15h'],
    spouseIds: ['ggd2h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd2h',
    name: 'Shoeb',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['ggd2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd3',
    name: 'Latifa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['gd15', 'gd15h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd16',
    name: 'Peersama',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd17',
    name: 'Zubeda',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs11',
    name: 'Allabax',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs12',
    name: 'Habibullah',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs13',
    name: 'Abdur Razaq',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    spouseIds: ['gs13w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs13w',
    name: 'Sabira',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs13'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs14',
    name: 'Mehboob',
    dod: '08/2013',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    spouseIds: ['gs14w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs14w',
    name: 'Naaz',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs14'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs15',
    name: 'Ibrahim',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1', 'd1h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's3',
    name: 'Fazal Ur Rehman',
    dod: '04/1944',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s3w'],
    childIds: ['gs16'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's3w',
    name: 'Mahboob bi',
    dob: '03/1919',
    dod: '11/1974',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['s3'],
    childIds: ['gs16'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs16',
    name: 'Mohammad Sadiq',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s3', 's3w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd2',
    name: 'Hajaratma',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gs17', 'gs18', 'gs19'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs17',
    name: 'Amir Hamza',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs18',
    name: 'Nizamuddin',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs19',
    name: 'Niyaz Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's4',
    name: 'Fakir Ahmed',
    dod: '12/1991',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s4w'],
    childIds: [
      'gd18',
      'gd23',
      'gs21',
      'gs22',
      'gs23',
      'gs24',
      'gs25',
      'gs26',
      'gs27'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's4w',
    name: 'Rashida Begum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['s4'],
    childIds: [
      'gd18',
      'gd23',
      'gs21',
      'gs22',
      'gs23',
      'gs24',
      'gs25',
      'gs26',
      'gs27'
    ],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd18',
    name: 'Mumtaz Begum',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    spouseIds: ['gd18h'],
    childIds: ['ggs3', 'ggs4', 'ggd4', 'ggd5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd18h',
    name: 'Ismail Khadka',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd18'],
    childIds: ['ggs3', 'ggs4', 'ggd4', 'ggd5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs3',
    name: 'Riyadh',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gd18', 'gd18h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs4',
    name: 'Faiyaz',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gd18', 'gd18h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd4',
    name: 'Shabana',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['gd18', 'gd18h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggd5',
    name: 'Shammi',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    parentIds: ['gd18', 'gd18h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd23',
    name: 'Qumurunissa',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    spouseIds: ['gd23h'],
    childIds: ['ggs5', 'ggs6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd23h',
    name: 'Ismail Janvekar',
    dod: '12/2020',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd23'],
    childIds: ['ggs5', 'ggs6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs5',
    name: 'Yahya',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gd23', 'gd23h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'ggs6',
    name: 'Ishaq',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['gd23', 'gd23h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs21',
    name: 'Shakira Begum',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    spouseIds: ['gs21h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs21h',
    name: 'Iliyas Kamliwale',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d6', 'd4h'],
    spouseIds: ['gs21'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs22',
    name: 'Imtiyaz Ahmed',
    dod: '08/2020',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs23',
    name: 'Sarfaraz Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs24',
    name: 'Nisar Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs25',
    name: 'Khursheed Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs26',
    name: 'Bilal Ahmed',
    dod: '10/2020',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs27',
    name: 'Najeeb Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4', 's4w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd3',
    name: 'Kulsumbi',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['d3h'],
    childIds: ['gd19', 'gs28', 'gs29', 'gs30', 'gs31', 'gs32', 'gs33'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd3h',
    name: 'Yonus Bedrekar',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['d3'],
    childIds: ['gd19', 'gs28', 'gs29', 'gs30', 'gs31', 'gs32', 'gs33'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd19',
    name: 'Dulhan',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs28',
    name: 'Abdul Majeed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    spouseIds: ['gs28w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs28w',
    name: 'Halimabi Sohaila Riyaz',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs28'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs29',
    name: 'Abdul Hameed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    spouseIds: ['gs29w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs29w',
    name: 'Mehrunissa Janvekar',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs29'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs30',
    name: 'Nazir Ahmed',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs31',
    name: 'Irfan',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs32',
    name: 'Iqbal',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs33',
    name: 'Sartaj',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3', 'd3h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd4',
    name: 'Hirama',
    dod: '1911',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['d4h'],
    childIds: ['gd20', 'gs34', 'gs35'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd4h',
    name: 'Moula Baksh Kamliwale',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['d4', 'd6'],
    childIds: ['gd20', 'gs34', 'gs35', 'gs21h', 'gs43', 'gs44'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd20',
    name: 'Sabira',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d4', 'd4h'],
    spouseIds: ['gd20h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd20h',
    name: 'Fakir Ahmed Bedrekar',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['gd20'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs34',
    name: 'Iqbal',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d4', 'd4h'],
    spouseIds: ['gs34w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs34w',
    name: 'Mehrunissa',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['gs34'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs35',
    name: 'Rafeeq',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d4', 'd4h'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's5',
    name: 'Yusuf',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s5w'],
    childIds: ['gs36', 'gs37', 'gs38', 'gs39'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's5w',
    name: 'Mehbooba',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['s5'],
    childIds: ['gs36', 'gs37', 'gs38', 'gs39'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs36',
    name: 'Taheer',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5', 's5w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs37',
    name: 'Farooq',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5', 's5w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs38',
    name: 'Mukhtar',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5', 's5w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs39',
    name: 'Zafar',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5', 's5w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd5',
    name: 'Guduma',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gd21'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd21',
    name: 'Mairunnissa',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's6',
    name: 'Nazeer Ahmed',
    dob: '06/1925',
    dod: '12/1991',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['s6w'],
    childIds: ['gd22', 'gs40', 'gs41', 'gs42'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's6w',
    name: 'Haleema Ahmedsab Sunedi',
    dob: '1937',
    dod: '11/1996',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    spouseIds: ['s6'],
    childIds: ['gd22', 'gs40', 'gs41', 'gs42'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd22',
    name: 'Abida Begum',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s6', 's6w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs40',
    name: 'Saleem',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6', 's6w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs41',
    name: 'Akhtar',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6', 's6w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs42',
    name: 'Maharoof',
    dod: '2010',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6', 's6w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd6',
    name: 'Zaibunissa',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    spouseIds: ['d4h'],
    childIds: ['gs21h', 'gs43', 'gs44'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs43',
    name: 'Qayyum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['d6', 'd4h'],
    spouseIds: ['gs43w'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs43w',
    name: 'Anjum',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: true,
    spouseIds: ['gs43'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs44',
    name: 'Naushad',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: true,
    parentIds: ['d6', 'd4h'],
    childRelType: ChildRelType.biological,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Tree Screen
// ─────────────────────────────────────────────────────────────────────────────

class TreeScreen extends ConsumerStatefulWidget {
  const TreeScreen({super.key});

  @override
  ConsumerState<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends ConsumerState<TreeScreen> {
  /// Cached snapshot of the current node list.
  /// Updated on every `familyTreeProvider` rebuild so the FAB and other
  /// callbacks always have an up-to-date list to hand to [AddPersonSheet].
  List<PersonNode> _currentNodes = [];

  @override
  void initState() {
    super.initState();
    // Push the 24-person seed dataset to Firestore on first launch.
    // seedIfEmpty is a no-op once data exists, so it is safe to call on
    // every launch. Any write errors are logged to the debug console.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(seedIfEmptyProvider.future).catchError((Object e) {
        debugPrint('[Seed] Failed to seed Firestore: $e');
      });
    });
  }

  void _onPersonTap(PersonNode person) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PersonDetailSheet(person: person),
    );
  }

  @override
  Widget build(BuildContext context) {
    final treeAsync = ref.watch(familyTreeProvider);
    final admin = ref.watch(isAdminProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Row(
          children: [
            Icon(Icons.shield, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('The Janvekar Family Tree'),
          ],
        ),
        actions: const [],
      ),

      body: treeAsync.when(
        // ── Loading ──────────────────────────────────────────────────────
        loading: () => const _TreeSkeleton(),

        // ── Error ────────────────────────────────────────────────────────
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded,
                    size: 48, color: AppColors.outline),
                const SizedBox(height: 16),
                Text('Could not load the tree.',
                    style: AppTextStyles.headlineSm),
                const SizedBox(height: 8),
                Text(
                  'Check your connection and try again.',
                  style:
                      AppTextStyles.titleMd.copyWith(color: AppColors.outline),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => ref.invalidate(familyTreeProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),

        // ── Data ─────────────────────────────────────────────────────────
        data: (nodes) {
          // Cache so the FAB callback has the latest list without a rebuild.
          _currentNodes = nodes;
          return nodes.isEmpty
              ? _EmptyTree(isAdmin: admin)
              : FamilyTreeCanvas(
                  nodes: nodes,
                  onPersonTap: _onPersonTap,
                );
        },
      ),

      // FAB shown only to admin.
      floatingActionButton: admin
          ? FloatingActionButton(
              onPressed: () => showAddPersonSheet(context, _currentNodes),
              tooltip: 'Add person',
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────

class _TreeSkeleton extends StatelessWidget {
  const _TreeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          _SkeletonRow(count: 1, widths: [100]),
          const SizedBox(height: 56),
          _SkeletonRow(count: 2, widths: [100, 100]),
          const SizedBox(height: 56),
          _SkeletonRow(count: 3, widths: [100, 100, 100]),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.count, required this.widths});
  final int count;
  final List<double> widths;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _SkeletonCard(width: widths[i % widths.length]),
        );
      }),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 134,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Container(
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Container(
                height: 10,
                color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: 6),
            Container(
                height: 8,
                width: 60,
                color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyTree extends StatelessWidget {
  const _EmptyTree({required this.isAdmin});
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_tree_outlined,
                size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: 24),
            Text('No family data yet', style: AppTextStyles.headlineSm),
            const SizedBox(height: 10),
            Text(
              isAdmin
                  ? 'Tap + to add the first family member.'
                  : 'The admin has not added any data yet.',
              style: AppTextStyles.titleMd.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Person detail bottom sheet (unchanged from previous version)
// ─────────────────────────────────────────────────────────────────────────────

class _PersonDetailSheet extends StatelessWidget {
  const _PersonDetailSheet({required this.person});
  final PersonNode person;

  (Color, Color) get _gradColors {
    switch (person.gender) {
      case PersonGender.male:
        return (AppColors.maleCardStart, AppColors.maleCardEnd);
      case PersonGender.female:
        return (AppColors.femaleCardStart, AppColors.femaleCardEnd);
      case PersonGender.unknown:
        return (AppColors.neutralCard, AppColors.primaryContainer);
    }
  }

  IconData get _genderIcon {
    switch (person.gender) {
      case PersonGender.male:
        return Icons.person;
      case PersonGender.female:
        return Icons.person_2;
      case PersonGender.unknown:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (gradStart, gradEnd) = _gradColors;

    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.32,
      maxChildSize: 0.90,
      builder: (_, controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSurface.withValues(alpha: 0.10),
                    blurRadius: 40,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                padding: EdgeInsets.zero,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color:
                              AppColors.outlineVariant.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [gradStart, gradEnd]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 2),
                            ),
                            child: Icon(_genderIcon,
                                size: 40,
                                color: Colors.white.withValues(alpha: 0.9)),
                          ),
                        ),
                        if (person.isLiving)
                          Positioned(
                            top: 12,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle,
                                      size: 6, color: Color(0xFF4ADE80)),
                                  SizedBox(width: 4),
                                  Text('Living',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: AppTextStyles.headlineSm),
                        if (person.currentLocation != null) ...[
                          const SizedBox(height: 4),
                          Text(person.currentLocation!,
                              style: AppTextStyles.titleMd.copyWith(
                                  color: AppColors.outline, fontSize: 14)),
                        ],
                        if (person.childRelType != ChildRelType.biological) ...[
                          const SizedBox(height: 8),
                          _RelTypePill(type: person.childRelType),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('LIFE EVENTS',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.outline, letterSpacing: 1.4)),
                  ),
                  const SizedBox(height: 12),
                  if (person.dob != null)
                    _EventRow(
                        label: 'BORN',
                        value: person.dob!,
                        color: AppColors.marriage),
                  if (!person.isLiving && person.dod != null)
                    _EventRow(
                        label: 'DIED',
                        value: person.dod!,
                        color: AppColors.outline),
                  if (person.currentLocation != null)
                    _EventRow(
                        label: 'LOCATION',
                        value: person.currentLocation!,
                        color: AppColors.primary),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RelTypePill extends StatelessWidget {
  const _RelTypePill({required this.type});
  final ChildRelType type;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      ChildRelType.adoptive => ('ADOPTIVE', AppColors.adoptiveLine),
      ChildRelType.heir => ('HEIR', AppColors.heirLine),
      _ => ('', Colors.transparent),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.2)),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow(
      {required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 40,
            margin: const EdgeInsets.only(right: 14, top: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTextStyles.labelSm.copyWith(
                      color: color, fontSize: 10, letterSpacing: 1.4)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.titleMd),
            ],
          ),
        ],
      ),
    );
  }
}
