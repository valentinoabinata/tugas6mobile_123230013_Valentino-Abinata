# Tugas 6 Mobile - TDD Currency Converter

Aplikasi konverter mata uang berbasis *mobile* (Flutter) yang dikembangkan dengan menerapkan metodologi **Test-Driven Development (TDD)**. Aplikasi ini memisahkan logika perhitungan dari antarmuka pengguna (UI) dan menggunakan layanan ExchangeRate-API untuk mendapatkan nilai tukar kurs secara *real-time*.

## 🚀 Prasyarat (Prerequisites)
Sebelum menjalankan proyek ini, pastikan sistem kamu telah memenuhi persyaratan berikut:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) terinstal dan terkonfigurasi di dalam *path* sistem.
* IDE seperti VS Code atau Android Studio terinstal.
* Emulator (Android/iOS) atau perangkat fisik yang sudah terhubung.
* Koneksi internet yang stabil (untuk menarik data dari API ExchangeRate).

## 🛠️ Cara Menjalankan Aplikasi

1.  **Buka Proyek:**
    Buka folder proyek ini (`tugas6mobile_123230013_valentinoabinata`) menggunakan terminal atau IDE pilihanmu (misalnya VS Code).

2.  **Unduh Dependensi:**
    Proyek ini menggunakan *package* `http` untuk terhubung ke API. Unduh dependensi dengan menjalankan perintah berikut di terminal:
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi:**
    Pastikan emulator sudah berjalan atau perangkat fisik sudah terhubung. Jalankan aplikasi dengan perintah:
    ```bash
    flutter run
    ```

## 🧪 Cara Menjalankan Unit Test (TDD)

Proyek ini dibangun menggunakan pendekatan TDD pada bagian logika (*business logic*). Untuk membuktikan bahwa fungsi kalkulasi berjalan dengan benar (termasuk skenario *error handling*), jalankan *unit test* tanpa harus membuka UI aplikasi:

1.  Buka terminal di dalam root direktori proyek.
2.  Jalankan perintah pengujian:
    ```bash
    flutter test
    ```
3.  Terminal akan mengeksekusi file `test/currency_converter_test.dart` dan akan menampilkan status hijau (`All tests passed!`) jika seluruh logika perhitungan terverifikasi akurat.

## 📁 Struktur Direktori Utama
* `lib/main.dart` : Berisi antarmuka pengguna (UI) dan logika pemanggilan API.
* `lib/currency_converter.dart` : Berisi *class* logika konversi mata uang (Otak aplikasi).
* `test/currency_converter_test.dart` : Berisi skenario *unit test* TDD (Fase Red, Green, Refactor).
