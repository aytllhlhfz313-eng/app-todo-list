<img width="316" height="643" alt="image" src="https://github.com/user-attachments/assets/dae47c3e-ba2d-42e7-9a84-8714e3eb3a4a" />Status: Completed
Role: UI/UX & Documentation
License: MIT

Aplikasi manajemen tugas (To-Do List) modern, bersih, dan intuitif berbasis web yang dirancang untuk membantu individu maupun tim dalam mengelola project, menjadwalkan tugas harian, dan berkolaborasi secara efisien.

---

## Tim Pengembang - KodeKita Studio

* Project Manager / Team Lead: [ayatullah al hafiz]
  Tanggung Jawab: Mengelola Repo, Issue, Sprint Planning, & Merge PR ke main

* UI/UX & Dokumentasi: Muhamad Daviq Aryanto (@Dapii280)
  Tanggung Jawab: High-Fidelity Design (Figma), Design System, SRS, & README.md

* Front-End Developer: [fathan]
  Tanggung Jawab: Slicing UI Figma ke Code (HTML/CSS/JS/React), Interaktivitas

* Back-End Developer: [nabila]
  Tanggung Jawab: Logika Data, REST API, & Database Management

* Quality Assurance / Tester: [riffat ]
  Tanggung Jawab: Testing Fitur, Bug Tracking, Verification, & Quality Control

---

## Fitur Utama Aplikasi

- Comprehensive Dashboard: Ringkasan status tugas harian (Today, In Progress, Upcoming, Completed) secara real-time.
- Custom Project Management: Pembuatan dan pengelompokan tugas berdasarkan proyek/kategori khusus beserta ikon dan tema warna.
- Advanced Task Creation: Menambah tugas baru lengkap dengan deskripsi, priority badge (High/Medium/Low), due date, subtasks, reminder, dan lampiran file (attachment).
- Empty State Onboarding: Tampilan awal yang ramah dan bersih bagi pengguna baru yang belum memiliki tugas.
- Real-Time Notification Dropdown: Notifikasi aktivitas tim, penugasan tugas baru, dan komentar kolaborasi.
- Bulk Actions Overlay: Mengelola banyak tugas sekaligus (pilih banyak untuk dihapus atau dipindahkan ke proyek lain).
- Clean Light Mode Design System: Antarmuka dengan warna warm cream/off-white yang nyaman di mata tanpa gangguan switch theme.

---

## Design & User Flow (UI/UX Showcase)

Berikut adalah alur penggunaan (User Journey) aplikasi Tada! yang telah dirancang menggunakan Figma:

1. Onboarding & First Impression (Empty State)
Layar pertama saat pengguna baru masuk ke aplikasi dan belum memiliki daftar tugas. Menampilkan ilustrasi ramah dengan Call-to-Action (CTA) "Create your first task".

2. Project Setup (Create Project Modal)
Pengguna membuat kategori/folder proyek baru sebelum menambahkan tugas. Dilengkapi dengan custom icon picker dan pilihan palet warna tema proyek.

3. Task Creation (Add Task Modal)
Modal formulir mendetail untuk memasukkan rincian tugas. Input mencakup Judul, Deskripsi, Kategori Proyek, Prioritas, Tanggal Jatuh Tempo, Subtask, dan Upload Lampiran.

4. Main Operational Workspace (Active Dashboard)
Tampilan pusat kontrol tempat seluruh tugas yang sedang berjalan ditampilkan. Terdapat ringkasan kartu statistik di bagian atas dan daftar tugas interaktif.

5. Team Collaboration (Notification Dropdown)
Pusat pemberitahuan saat terdapat interaksi dari anggota tim lain. Menampilkan log pendelegasian tugas, penyebutan nama (@mention), dan komentar.

6. Mass Management (Bulk Actions Overlay)
Bilah aksi melayang yang muncul ketika pengguna memilih beberapa centang tugas secara bersamaan. Menyediakan tombol cepat: Mark as Done, Move to Project, dan Delete.

---

## Alur Kerja Git & Strategi Branching (Git Workflow)

Proyek ini dikembangkan menggunakan standar alur kerja Git kolaboratif industri:

Struktur Branch:
- main: Branch stabil untuk versi produk siap rilis (hanya dibolehkan via PR oleh PM).
- develop: Branch integrasi utama tempat semua fitur digabungkan dan diuji.
- feature/*: Branch khusus untuk pengembangan satu fitur tertentu (misal: feature/ui-ux-design, feature/add-task-modal).
- fix/*: Branch khusus untuk perbaikan bug hasil temuan QA.

Standar Format Pesan Commit (Conventional Commits):
- docs: untuk perubahan atau penambahan dokumentasi/UI design (contoh: docs: update readme with figma preview).
- feat: untuk penambahan fitur baru di kodingan (contoh: feat: add task filter functional button).
- fix: untuk perbaikan bug (contoh: fix: resolve overlay alignment on mobile view).
- style: untuk penataan tata letak / CSS tanpa mengubah logika program.

---

## Petunjuk Penggunaan & Cara Menjalankan Aplikasi

Prasyarat Sistem:
- Web Browser modern (Google Chrome, Brave, Mozilla Firefox, atau Microsoft Edge).
- Git telah terinstall di komputer lokal.

Langkah Instalasi (Local Setup):

1. Clone Repository ini:
   git clone https://github.com/aytllhlhfz313-eng/app-todo-list.git
   cd [Nama-Repo]

2. Pindah ke Branch Develop:
   git checkout develop
   git pull origin develop

3. Jalankan Aplikasi:
   - Jika berbasis HTML/CSS/JS murni: Buka file index.html langsung di browser atau gunakan ekstensi Live Server di VS Code.
   - Jika menggunakan Node.js/React:
     npm install
     npm run dev

## Lisensi & Hak Cipta
todo list 


<img width="314" height="641" alt="image" src="https://github.com/user-attachments/assets/fcd3c498-8da9-4e31-a47f-c305a0a08f23" />  
<img width="316" height="643" alt="image" src="https://github.com/user-attachments/assets/13f8824b-8160-4b44-8d29-c1429b0cd3f2" />
https://www.figma.com/design/8SWKOeRaQcHBr7Tw3cC9QC/Untitled?node-id=0-1&p=f&t=rK39GHbq0G48FN19-0
