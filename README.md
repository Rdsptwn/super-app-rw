# Super App RW

Aplikasi Android untuk koordinasi, keamanan, dan administrasi warga RW (real-time).

## Status kerangka awal
| Fitur | Status |
|---|---|
| Login / daftar warga (email + kata sandi) | Ada |
| Peran: warga, rt, pengurus, admin | Ada (di profil Firestore) |
| Beranda + kontak darurat (telepon langsung) | Ada |
| Panic button (simpan alert ke Firestore) | Ada, pengiriman ke WA/push belum (lihat `docs/PANIC_FLOW.md`) |
| Aturan keamanan Firestore per peran | Ada (`firestore.rules`) |
| Build APK otomatis (GitHub Actions) | Ada |
| Chat, E-Ronda, Data Warga, Kas, dll. | Belum (tombol "segera hadir") |
| Asisten AI, bot WhatsApp | Belum |

> Kode ini belum sempat dijalankan/diuji di mesin Flutter. Jalankan `flutter analyze` dulu dan kirim error-nya bila ada.

## Menjalankan di komputer

```
git clone https://github.com/Rdsptwn/super-app-rw
cd super-app-rw

# 1. Buat folder android/ (sekali saja), lalu commit
flutter create . --platforms=android --project-name super_app_rw --org id.rw01

# 2. Ambil dependensi
flutter pub get

# 3. Hubungkan Firebase (buat proyek dulu di console.firebase.google.com)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Jalankan di HP
flutter run
```

Di Firebase Console aktifkan: **Authentication** (Email/Password) dan **Firestore Database**, lalu salin isi `firestore.rules` ke tab **Rules**.

### Menjadikan seseorang admin/RT/pengurus
Pendaftar baru selalu `warga`. Ubah manual di Firestore: koleksi `users` > dokumen pengguna > field `role` jadi `admin`, `pengurus`, atau `rt`. Akun admin pertama dibuat dengan cara ini.

## Struktur
```
lib/
  main.dart                  titik masuk, inisialisasi Firebase
  firebase_options.dart      stub; diganti `flutterfire configure`
  models/app_user.dart       model pengguna + peran
  services/panic_service.dart
  screens/                   auth_gate, login, home, setup_needed
firestore.rules              keamanan per peran
.github/workflows/build-apk.yml
docs/PANIC_FLOW.md
```

## Tahapan berikutnya
1. Uji kerangka ini di HP, perbaiki error
2. Kontak darurat dari Firestore (diatur admin), bukan nilai tetap
3. Pengirim panic: Cloud Function + FCM + WhatsApp gateway
4. Chat real-time
5. E-Ronda (form, foto, GPS)
6. Data warga + import/export CSV
7. Modul lain, lalu uji internal di 1 RT

## Catatan keamanan
- Data warga (NIK, alamat) sensitif. Akses dibatasi di `firestore.rules`; jangan longgarkan.
- Repo ini **Private**. `firebase_options.dart` / `google-services.json` berisi kunci proyek Firebase (bukan rahasia mutlak, dilindungi oleh rules), tapi jangan jadikan repo publik tanpa meninjau ulang.
- Jangan commit token gateway WhatsApp, kunci layanan (`service-account*.json`), atau keystore. Sudah masuk `.gitignore`.
