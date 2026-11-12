import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_user.dart';
import '../services/panic_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.firebaseUser});

  final User firebaseUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _Message(
            text: 'Gagal memuat profil: ${snapshot.error}',
            onSignOut: () => FirebaseAuth.instance.signOut(),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final data = snapshot.data!.data();
        if (data == null) {
          return _Message(
            text: 'Profil belum lengkap. Hubungi admin RW.',
            onSignOut: () => FirebaseAuth.instance.signOut(),
          );
        }
        return _HomeBody(user: AppUser.fromMap(firebaseUser.uid, data));
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.onSignOut});

  final String text;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super App RW')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onSignOut, child: const Text('Keluar')),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.user});

  final AppUser user;

  static const _contacts = <(String, String, IconData)>[
    ('Polisi', '110', Icons.local_police),
    ('Damkar', '113', Icons.fire_truck),
    ('Ambulans', '119', Icons.medical_services),
  ];

  static const _modules = <(String, String, IconData)>[
    ('E-Ronda', 'Patroli & GPS', Icons.shield),
    ('Data Warga', 'Demografi & RT', Icons.groups),
    ('Kas RW', 'Laporan keuangan', Icons.account_balance),
    ('Chat', 'Pengurus RT/RW', Icons.chat),
    ('Surat Pengantar', 'Booking & RT', Icons.description),
    ('Info Loker', 'Pekerjaan warga', Icons.work),
    ('UMKM & Jasa', 'Galeri warga', Icons.storefront),
    ('Undangan', 'Kalender kerja', Icons.event),
    ('Mading', 'Pengumuman', Icons.campaign),
  ];

  Future<void> _call(BuildContext context, String number) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(
      Uri(scheme: 'tel', path: number),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text('Tidak bisa membuka telepon untuk $number')),
      );
    }
  }

  Future<void> _panic(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kirim sinyal darurat?'),
        content: Text(
          'Peringatan akan dikirim ke pengurus dan RT ${user.rt.toString().padLeft(2, '0')}. '
          'Untuk bahaya langsung, tetap hubungi 110/113/119.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('KIRIM'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await PanicService().send(user);
      messenger.showSnackBar(
        const SnackBar(content: Text('Sinyal darurat terkirim.')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal mengirim: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super App RW'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(user.role.label),
            ),
          ),
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Halo, ${user.name} (RT ${user.rt.toString().padLeft(2, '0')})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
              onPressed: () => _panic(context),
              icon: const Icon(Icons.warning_amber_rounded, size: 28),
              label: const Text(
                'PANIC BUTTON (DARURAT)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Kontak Darurat Cepat',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final c in _contacts)
                Expanded(
                  child: Card(
                    child: InkWell(
                      onTap: () => _call(context, c.$2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Icon(c.$3),
                            const SizedBox(height: 4),
                            Text(c.$1),
                            Text(c.$2,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Layanan & Modul', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
            children: [
              for (final m in _modules)
                Card(
                  child: InkWell(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${m.$1}: segera hadir')),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(m.$3, size: 28),
                          const SizedBox(height: 6),
                          Text(m.$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(m.$2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
