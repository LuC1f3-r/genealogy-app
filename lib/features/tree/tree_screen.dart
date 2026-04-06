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
    id: 'root',
    name: 'Abba Saheb',
    dod: '1936',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    spouseIds: ['wife1', 'wife2'],
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
    dob: '1902',
    dod: '1970',
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
    dob: '1900',
    dod: '1975',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 'root',
    childIds: ['s3', 'd2', 's4', 'd3', 'd4', 's5', 'd5', 's6', 'd6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's1',
    name: 'Dewan Saheb',
    dob: '1920',
    dod: '1998',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2',
    name: 'Khalilulha',
    dob: '1925',
    dod: '2002',
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
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: ['gd1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd1',
    name: 'Majan',
    dob: '1955',
    dod: '2001',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w2',
    name: 'Booma',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    isSpouseOf: 's2',
    childIds: ['gd2', 'gd3', 'gs1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd2',
    name: 'Zulekha',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd3',
    name: 'Halima',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs1',
    name: 'Nizamuddin',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w3',
    name: 'Ameerabi',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
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
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd5',
    name: 'Hifzunissa',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd6',
    name: 'Shahenaz',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs2',
    name: 'Ismail',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs3',
    name: 'Munir',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs4',
    name: 'Hidayat',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs5',
    name: 'Zakriya',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs6',
    name: 'Shabbir',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs7',
    name: 'Rafiq',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs8',
    name: 'Altamash',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's2w4',
    name: 'Ratanbi',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
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
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs10',
    name: 'Maheboob',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd7',
    name: 'Shazadi Batul',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd8',
    name: 'Bilqis Banu',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd9',
    name: 'Qudsia Begum',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd10',
    name: 'Azra Begum',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd11',
    name: 'Ziya Banu',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd12',
    name: 'Saleha Banu',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd13',
    name: 'Ifthekharunissa',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s2', 's2w4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd1',
    name: 'Fatimabi',
    dob: '1928',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife1'],
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
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd15',
    name: 'Jannatbi',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd16',
    name: 'Peersama',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd17',
    name: 'Zubeda',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs11',
    name: 'Allabax',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs12',
    name: 'Habibullah',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs13',
    name: 'Abdur Razaq',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs14',
    name: 'Mehboob',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs15',
    name: 'Ibrahim',
    dob: '1955',
    currentLocation: 'Bijapur, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d1'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's3',
    name: 'Fazal Ur Rehman',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gs16'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs16',
    name: 'Mohammad Sadiq',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd2',
    name: 'Hajaratma',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gs17', 'gs18', 'gs19'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs17',
    name: 'Amir Hamza',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs18',
    name: 'Nizamuddin',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs19',
    name: 'Niyaz Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d2'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's4',
    name: 'Fakir Ahmed',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: [
      'gd18',
      'gs20',
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
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs20',
    name: 'Qumurunissa',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs21',
    name: 'Shakira Begum',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs22',
    name: 'Imtiyaz Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs23',
    name: 'Sarfaraz Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs24',
    name: 'Nisar Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs25',
    name: 'Khursheed Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs26',
    name: 'Bilal Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs27',
    name: 'Najeeb Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd3',
    name: 'Kulsumbi',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gd19', 'gs28', 'gs29', 'gs30', 'gs31', 'gs32', 'gs33'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd19',
    name: 'Dulhan',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs28',
    name: 'Abdul Majeed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs29',
    name: 'Abdul Hameed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs30',
    name: 'Nazir Ahmed',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs31',
    name: 'Irfan',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs32',
    name: 'Iqbal',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs33',
    name: 'Sartaj',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d3'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd4',
    name: 'Hirama',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gd20', 'gs34', 'gs35'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd20',
    name: 'Sabira',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs34',
    name: 'Iqbal',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs35',
    name: 'Rafeeq',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['d4'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's5',
    name: 'Yusuf',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gs36', 'gs37', 'gs38', 'gs39'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs36',
    name: 'Taheer',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs37',
    name: 'Farooq',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs38',
    name: 'Mukhtar',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs39',
    name: 'Zafar',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd5',
    name: 'Guduma',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gd21'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd21',
    name: 'Mairunnissa',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['d5'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 's6',
    name: 'Nazeer Ahmed',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['root', 'wife2'],
    childIds: ['gd22', 'gs40', 'gs41', 'gs42'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gd22',
    name: 'Abida Begum',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['s6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs40',
    name: 'Saleem',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs41',
    name: 'Akhtar',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'gs42',
    name: 'Maharoof',
    dob: '1933',
    dod: '2010',
    currentLocation: 'Sholapur, MH',
    gender: PersonGender.male,
    isLiving: false,
    parentIds: ['s6'],
    childRelType: ChildRelType.biological,
  ),
  PersonNode(
    id: 'd6',
    name: 'Zaibunissa',
    dob: '1923',
    dod: '2001',
    currentLocation: 'Gulbarga, KA',
    gender: PersonGender.female,
    isLiving: false,
    parentIds: ['root', 'wife2'],
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
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
          _SkeletonRow(count: 3, widths: [120, 120, 120]),
          const SizedBox(height: 56),
          _SkeletonRow(count: 2, widths: [120, 120]),
          const SizedBox(height: 56),
          _SkeletonRow(count: 4, widths: [120, 120, 120, 120]),
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
