# 📝 To-Do List App with Supabase

Aplikasi To-Do List sederhana yang dibangun dengan **Flutter** dan **Supabase** untuk menyimpan data tugas secara cloud.

## ✨ Fitur
- ✅ Tambah tugas baru
- ✅ Tandai tugas sebagai selesai/belum
- ✅ Hapus tugas
- ✅ Data tersimpan di Supabase (cloud database)
- ✅ Tampilan responsif
- ✅ Error handling
- ✅ Auto-refresh data

## 🚀 Cara Penggunaan

### 📋 Prasyarat:
1. **Flutter SDK** - [Instalasi Flutter](https://docs.flutter.dev/get-started/install)
2. **Git** - Untuk clone repository
3. **Akun Supabase** - [Daftar di sini](https://supabase.com/)

---

### 🔧 Langkah 1: Clone Repository
```bash
git clone https://github.com/username/todo_list_app.git
cd todo_list_app
```
### 🗄️ Langkah 2: Setup Supabase
2.1 Buat project Supabase
1. Kunjungi [Supabase](https://supabase.com/)
2. klik **"New Project"**
3. isi nama project dan password database
4. pilih region terdekat
5. Tunggu hingga siap

2.2
1. Masuk ke SQL Editor di dashboard Supabase
```bash
CREATE TABLE todos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task TEXT NOT NULL,
  is_done BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

2.3 Konfigurasi Row Level Security
```bash
CREATE POLICY "Allow all operations" 
ON todos FOR ALL USING (true);
``` 

2.4 Dapatkan API Keys
1. Buka **Settings → API**
2. Copy:
   - URL
   - anon public key

### ⚙️ Langkah 3: Konfigurasi Aplikasi
3.1 Setup File Konfigurasi 
```bash
# Copy file template
cp lib/supabase_template.dart lib/supabase.dart
```

3.2 Edit File Konfigurasi
Buka **lib/supabase.dart** dan ganti dengan keys yang Anda punya:
```dart
class SupabaseConfig {
  static const String url = 'https://your-project.supabase.co';  // Ganti dengan URL Anda
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';  // Ganti dengan anon key Anda
  // ... kode lainnya tetap
}
```

### 📦 Langkah 4: Install Dependencies
```bash
flutter pub get
```

### ▶️ Langkah 5: Jalankan Aplikasi
```bash
flutter run
```

# Demo
https://github.com/user-attachments/assets/17537fb7-f8ba-4d5c-b550-bc70ebec1aab

# Pembuat
Muhammad Hafidh Fadilah (20)
Kelas XII RPL 1
