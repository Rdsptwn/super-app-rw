// FILE SEMENTARA (stub).
//
// Jalankan perintah ini di folder proyek untuk menggantinya dengan file asli:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Selama masih stub, aplikasi menampilkan layar "Firebase belum dikonfigurasi"
// sehingga tampilan lain tetap bisa dicoba tanpa Firebase.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase belum dikonfigurasi. Jalankan `flutterfire configure`.',
    );
  }
}
