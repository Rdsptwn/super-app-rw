# Alur Panic Button

## Sekarang (kerangka awal)
1. Warga menekan PANIC BUTTON, lalu konfirmasi.
2. Aplikasi menulis dokumen ke koleksi `panic_alerts`:
   `uid`, `name`, `rt`, `status: baru`, `createdAt`.

## Tahap berikutnya (agar benar-benar sampai ke tujuan)
Tulis dokumen alert belum cukup: perlu "pengirim" di server.

1. **Cloud Function** (trigger `onDocumentCreated('panic_alerts/{id}')`):
   - baca daftar tujuan dari koleksi `emergency_contacts`
     (3 grup patroli, 3 nomor darurat RW, Kamtibmas, pengurus, + nomor RT asal)
   - kirim notifikasi push (FCM) ke pengurus
   - kirim pesan WhatsApp lewat gateway
2. Simpan hasil kirim (berhasil/gagal) kembali ke dokumen alert.
3. Cadangan: tombol telepon langsung (110/113/119) sudah ada di beranda.

Catatan: Cloud Functions di Firebase memerlukan paket Blaze (bayar sesuai
pakai, ada kuota gratis). Alternatif: server kecil gratis di tempat lain
yang memantau Firestore.

## Batasan yang harus jujur disampaikan ke warga
- Pengiriman WhatsApp lewat gateway tidak resmi bisa gagal (nomor diblokir,
  gateway down, tidak ada sinyal).
- Panic button adalah alat bantu, bukan pengganti telepon darurat.
