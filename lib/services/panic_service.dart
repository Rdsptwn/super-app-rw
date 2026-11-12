import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

/// Mengirim sinyal darurat.
///
/// Tahap 1 (sekarang): alert disimpan ke koleksi `panic_alerts`.
/// Tahap 2: Cloud Function / server kecil membaca koleksi ini, lalu
/// mengirim notifikasi push (FCM) dan pesan WhatsApp ke tujuan yang
/// diatur admin (grup patroli, nomor darurat RW, Kamtibmas, pengurus,
/// dan nomor RT asal pelapor). Lihat docs/PANIC_FLOW.md.
class PanicService {
  PanicService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<void> send(AppUser user) async {
    await _db.collection('panic_alerts').add({
      'uid': user.uid,
      'name': user.name,
      'rt': user.rt,
      'status': 'baru',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
