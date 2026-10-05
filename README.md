Markdown
# 📝 Modern To-Do List App — KodeKita Studio

Aplikasi manajemen tugas harian modern berbasis **Flutter** untuk antarmuka pengguna (*frontend*), **Express.js** sebagai *backend RESTful API*, dan **MySQL** sebagai sistem basis data. Proyek ini dikembangkan sebagai bagian dari simulasi tim pengembang perangkat lunak dengan menerapkan alur kerja kolaborasi Git & GitHub standar industri.
👥 Profil Kelompok & Pembagian Peran
Nama Anggota	Peran (Role)	Tanggung Jawab Utama
[Nama PM]	Project Manager (PM)	Mengelola repository, menyusun Issues, memantau alur Git, dan me-review Pull Request
[Nama Backend Dev]	Back-End Developer	Merancang skema MySQL dan membangun RESTful API menggunakan Express.js
[Nama Frontend Dev]	Front-End Developer	Membangun UI/UX modern dengan Flutter dan mengintegrasikan HTTP REST API
[Nama UI/UX & Docs]	UI/UX & Dokumentasi	Merancang alur antarmuka, menyusun README.md, dan menyiapkan Laporan Kolaborasi
[Nama QA]	Quality Assurance (QA)	Menguji fitur CRUD, mencatat issue bug, dan memverifikasi alur aplikasi
🛠️ Tools & Teknologi
Frontend
Flutter (Dart) — Framework UI Lintas Platform

HTTP Package (http: ^1.2.0) — Integrasi REST API

Backend & Database
Node.js & Express.js — Runtime & REST API Framework

MySQL — Database Relasional

Dependencies Backend: express, mysql2, cors, dotenv

Tools Kolaborasi & Pengujian
Git & GitHub — Version Control & Branching Strategy (main, develop, feature/*)

Postman / Bruno — Pengujian Endpoint API

🚀 Fitur Utama (CRUD)
➕ Create: Menambahkan daftar tugas baru beserta deskripsi.

📋 Read: Menampilkan daftar seluruh tugas harian secara real-time.

🔄 Update / Toggle: Memperbarui status penyelesaian tugas (selesai / belum selesai) serta detail tugas.

❌ Delete: Menghapus tugas dari daftar.

💻 Cara Menjalankan Proyek
1. Persiapan Database (MySQL)
Buka MySQL / phpMyAdmin.

Buat database baru dan jalankan query SQL berikut:

SQL
CREATE DATABASE IF NOT EXISTS todolist_db;
USE todolist_db;

CREATE TABLE IF NOT EXISTS todos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
2. Setup & Jalankan Backend (Express.js)
Masuk ke direktori backend:

Bash
cd backend
Install dependensi Node.js:

Bash
npm install
Jalankan server:

Bash
node server.js
Server backend akan berjalan di http://localhost:3000.

3. Setup & Jalankan Frontend (Flutter)
Masuk ke direktori frontend:

Bash
cd frontend
Unduh paket dependensi Flutter:

Bash
flutter pub get
Jalankan aplikasi:

Bash
flutter run
(Catatan: Jika menggunakan Emulator Android, pastikan URL endpoint API mengarah ke http://10.0.2.2:3000/api/todos).

🌿 Alur Kerja Git (Branching Strategy)
Proyek ini menerapkan branching strategy sebagai berikut:

main : Versi rilis stabil / produk final.

develop : Branch integrasi utama tempat semua fitur digabungkan.

feature/* : Branch fitur spesifik (contoh: feature/flutter-ui-todolist, feature/express-crud-api).

fix/* : Branch perbaikan bug (contoh: fix/koneksi-database).

📸 Tampilan Aplikasi
Halaman Utama (Daftar Tugas)	Form Tambah Tugas
(Isi dengan screenshot tampilan Flutter)	(Isi dengan screenshot modal tambah Flutter)
