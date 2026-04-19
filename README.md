# ROUTINE

> Habit tracker dengan mekanisme presensi unik.

**Versi:** 1.0.0
**Platform:** Android & iOS (Flutter)
**Bahasa default:** Indonesia

---

## ✨ Fitur Utama

- 🎯 **Presensi Sidik Jari** — Setiap habit di-tap pakai tombol fingerprint besar. Fokus, cepat, memuaskan.
- 🔢 **HYBRID Binary + Target Tracking** — Habit bisa binary (1 tap selesai) atau target-based (misalnya 8 gelas air; tiap tap +1).
- 🎉 **Animasi & Confetti** — Tiap habit fully selesai disambut confetti + haptic feedback.
- 🗓️ **Rekap Bulanan** — Kalender interaktif + completion rate + kontribusi per habit.
- 📊 **Statistik & Streak** — Current streak, longest streak, heatmap 14 minggu ala GitHub.
- 💬 **Quote Harian Motivasi** (konsisten per tanggal).
- 🏷️ **Kategori Habit** — Kesehatan, Produktivitas, Mindfulness, Sosial, Keuangan, Lainnya.
- ↩️ **Undo Presensi 5 detik** — Jaga-jaga salah tekan.
- 🔔 **Pengingat Harian** — Notifikasi lokal jam yang bisa diatur.
- 🌓 **Dark mode** + mengikuti sistem.
- 📴 **100% Offline** — Semua data di-local dengan Hive.

---

## 🎨 Design System

- **Palet:** Monokromatik **teal green** (`#00A676`), background putih bersih (`#F6FAF8`).
- **Font Display:** Playfair Display (heading besar — elegant serif).
- **Font Body:** Plus Jakarta Sans.
- **Logo:** "ROUTINE" dengan letter-spacing 3.6 (premium corporate).
- **Cards:** Rounded 24-28px, soft shadow hijau.
- **Material 3** + dark mode.

## 📱 Flow Screen

1. **Splash 2-stage**: Clean (fingerprint + "TEMUKAN IRAMAMU") → Corporate (card + "ROUTINE TECHNOLOGIES • 2026").
2. **Onboarding 3-slide**: Heading display dengan 1 kata highlight hijau, preview card, page indicator.
3. **Welcome Screen**: Illustration card dengan sticker "READY?" + CTA "Tambah Habit Pertama".
4. **Add Initial Habits**: Grid 12 rekomendasi (Olahraga 30 menit, Minum Air 8 gelas, dll) — sebagian punya target preset.
5. **Home Screen (Core)**:
   - Header ROUTINE + icon grafik + greeting + tanggal uppercase
   - Progress ring % habit selesai
   - Quote motivasi harian
   - **Featured Card habit teratas**: icon bulat gradient, nama (serif display), target (jika ada), fingerprint button, progress bar live
   - Section **"Langkah Selanjutnya"** — list mini tile habit lain (dengan circular progress kecil jika target-based)
   - Footer pill: "X dari Y habit hari ini"
6. **Bottom Nav 5 tab**: Home • Kalender • [+] FAB fingerprint tengah (Tambah Habit) • Achievement • Settings
7. **Add/Edit Habit**: Nama, deskripsi, kategori chip, icon picker, **switch "Pakai Target?"** → input jumlah + satuan (gelas, menit, halaman, dll).
8. **Rekap/Statistik/Profil**: kalender table, pie chart, heatmap 14 minggu, streak, settings.

## 📁 Struktur Project

```
flutter_routine/
├── pubspec.yaml
├── lib/
│   ├── main.dart & app.dart
│   ├── core/
│   │   ├── theme/             # AppTheme (Playfair + Jakarta), AppColors (monokromatik teal)
│   │   ├── constants/         # Icons, Suggestions (dengan target preset), Quotes, Categories
│   │   └── utils/             # Date & Haptic helpers
│   ├── data/
│   │   ├── models/
│   │   │   ├── habit.dart             # + hasTarget, targetValue, targetUnit, incrementStep
│   │   │   ├── daily_completion.dart  # + progressValue, targetSnapshot, isFullyCompleted
│   │   │   ├── user_profile.dart
│   │   │   └── user_streak.dart
│   │   ├── repositories/      # Habit, Completion (tap/undoTap), User
│   │   └── services/          # Hive, Notifications
│   └── presentation/
│       ├── providers/         # Riverpod – TodayState dengan completions map
│       ├── screens/
│       │   ├── splash_screen.dart              # 2-stage (clean → corporate)
│       │   ├── onboarding/
│       │   │   ├── onboarding_screen.dart      # Heading display + highlight hijau
│       │   │   ├── welcome_screen.dart         # NEW – card ilustrasi READY?
│       │   │   └── add_initial_habits_screen.dart
│       │   ├── home/
│       │   │   ├── home_screen.dart            # Featured card + list Langkah Selanjutnya
│       │   │   └── all_completed_screen.dart
│       │   ├── rekap/
│       │   ├── statistik/
│       │   ├── profil/
│       │   ├── habit/
│       │   │   ├── add_habit_screen.dart       # + switch target + unit
│       │   │   └── habit_list_screen.dart
│       │   └── main_navigation.dart            # 5 tab + FAB fingerprint tengah
│       └── widgets/
│           ├── habit_featured_card.dart        # NEW – card besar + progress bar
│           ├── habit_mini_tile.dart            # NEW – tile list Langkah Selanjutnya
│           ├── fingerprint_button.dart
│           ├── progress_ring.dart
│           ├── heatmap_calendar.dart
│           └── pickers.dart                    # icon picker (color picker dihapus – mono)
└── README.md
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- **Flutter 3.27+** (stable channel) – wajib karena pakai API `.withValues()`.
- Android Studio / VS Code + Flutter plugin
- Perangkat Android 8.0+ atau iOS 12+ (atau emulator)

### Langkah
```bash
cd flutter_routine
# Scaffold folder android/ & ios/ native (tanpa menimpa lib/):
flutter create . --project-name routine --org com.routine
# Install dependencies
flutter pub get
# Jalankan
flutter run
```

---

## 🔧 Konfigurasi Notifikasi

### Android (`android/app/src/main/AndroidManifest.xml`)
Tambahkan di dalam `<manifest>`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### iOS (`ios/Runner/Info.plist`)
Sudah di-handle oleh `flutter_local_notifications`. Untuk teks izin custom:
```xml
<key>NSUserNotificationsUsageDescription</key>
<string>Kami gunakan notifikasi untuk mengingatkan presensi habit harian.</string>
```

---

## 📐 Arsitektur Singkat

- **State Management:** Riverpod 2.x (StateNotifier + Provider).
- **Storage:** Hive (offline-first). TypeAdapter **manual** — tidak butuh `build_runner`.
- **Model utama:**
  - `Habit` — id, name, iconKey, category, description, **hasTarget, targetValue, targetUnit, incrementStep**, timestamps
  - `DailyCompletion` — id, habitId, dateKey, completionDate, completedAt, **progressValue, targetSnapshot**
  - `UserProfile` — name, createdAt, lastActive, onboardingDone
  - `UserStreak` — computed di runtime
- **Tap logic (HYBRID):**
  - *Binary*: buat record sekali, habit selesai.
  - *Target*: setiap tap naikkan `progressValue` sebesar `incrementStep`. Habit fully selesai jika `progressValue >= targetSnapshot`.
- **Streak:** dihitung dari hari-hari "perfect" (semua habit aktif fully completed).

---

## 🗂️ Roadmap (Out of MVP v1.0)

- Frekuensi habit non-harian (mingguan, custom days).
- Cloud sync + multi-device (Firebase Auth + Firestore).
- Gamification lengkap (level, badge, poin).
- Social sharing streak.
- Reminder per habit individual.
- Export data CSV / JSON.
- i18n (Bahasa Inggris).
- Home Widget Android/iOS untuk presensi tanpa buka app.

---

## 📜 Lisensi

Aplikasi ini dibuat dari PRD kustom. Bebas digunakan untuk keperluan pribadi & pembelajaran.


**Versi:** 1.0.0
**Platform:** Android & iOS (Flutter)
**Bahasa default:** Indonesia

---

## ✨ Fitur Utama

- 🎯 **Presensi Sidik Jari** — Setiap habit di-tap satu kali pakai tombol fingerprint besar, lalu card meluncur ke kanan.
- 🎉 **Animasi & Confetti** — Tiap presensi selesai disambut confetti + haptic feedback.
- 🗓️ **Rekap Bulanan** — Kalender interaktif + pie chart kontribusi per habit + completion rate.
- 📊 **Statistik & Streak** — Current streak, longest streak, heatmap 14 minggu ala GitHub.
- 💬 **Quote Harian Motivasi** (konsisten per tanggal).
- 🏷️ **Kategori Habit** — Kesehatan, Produktivitas, Mindfulness, Sosial, Keuangan, Lainnya.
- ↩️ **Undo Presensi 5 detik** — Jaga-jaga salah tekan.
- 🔔 **Pengingat Harian** — Notifikasi lokal jam yang bisa diatur.
- 🌓 **Dark mode** + mengikuti sistem.
- 📴 **100% Offline** — Semua data di-local dengan Hive.

---

## 📁 Struktur Project

```
flutter_routine/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── theme/             # AppTheme, AppColors
│   │   ├── constants/         # Icons, Suggestions, Quotes, Categories
│   │   └── utils/             # Date & Haptic helpers
│   ├── data/
│   │   ├── models/            # Habit, DailyCompletion, UserProfile, UserStreak
│   │   ├── repositories/      # Habit, Completion, User repositories
│   │   └── services/          # Hive, Notifications
│   └── presentation/
│       ├── providers/         # Riverpod (habit, completion, user, settings, theme)
│       ├── screens/
│       │   ├── splash_screen.dart
│       │   ├── onboarding/    # Onboarding + Add Initial Habits
│       │   ├── home/          # Home + All Completed
│       │   ├── rekap/         # Rekap + Daily Detail
│       │   ├── statistik/     # Statistik & Heatmap
│       │   ├── profil/        # Profil & Pengaturan
│       │   ├── habit/         # Add/Edit Habit + Habit List
│       │   └── main_navigation.dart
│       └── widgets/           # HabitCard, FingerprintButton, ProgressRing, Heatmap, QuoteCard, Pickers
└── README.md
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- **Flutter 3.27+** (stable channel)
- Android Studio / VS Code + Flutter plugin
- Perangkat Android 8.0+ atau iOS 12+ (atau emulator)

### Langkah
```bash
# 1. Masuk ke folder project
cd flutter_routine

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

> **Catatan:** Project ini **belum di-scaffold** dengan folder Android/iOS native lengkap. Jika folder `android/` dan `ios/` belum ada atau belum lengkap, jalankan dulu:
>
> ```bash
> flutter create . --project-name routine --org com.routine
> ```
>
> Perintah di atas akan menambahkan folder `android/` dan `ios/` bawaan tanpa menimpa `lib/` dan `pubspec.yaml`.

---

## 🔧 Konfigurasi Notifikasi

### Android (`android/app/src/main/AndroidManifest.xml`)
Tambahkan di dalam `<manifest>`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### iOS (`ios/Runner/Info.plist`)
Sudah di-handle oleh package `flutter_local_notifications`. Saat pertama kali dipicu, iOS akan meminta izin notifikasi ke pengguna.

---

## 📐 Arsitektur Singkat

- **State Management:** Riverpod 2.x (`StateNotifier` + `Provider`).
- **Storage:** Hive (offline-first). TypeAdapter **manual** (tanpa `build_runner`) untuk semua model.
- **Model utama:**
  - `Habit` (id, name, iconKey, colorIndex, category, description, isActive, timestamps)
  - `DailyCompletion` (id, habitId, dateKey, completionDate, completedAt)
  - `UserProfile` (name, createdAt, lastActive, onboardingDone)
  - `UserStreak` (computed at runtime dari DailyCompletion)
- **Boxes:** `habits`, `completions`, `profile`, `settings`.
- **Key presensi:** `<habitId>_<yyyy-MM-dd>` — memastikan 1 habit hanya bisa di-presensi sekali per hari.

---

## 🎨 Design System

- **Font:** Plus Jakarta Sans (Google Fonts).
- **Palet:** Hijau (`#22C55E` primary), Biru (`#3B82F6`), Oranye (`#F97316`).
- **Material 3** + dark mode.
- 12 warna habit card, 30+ ikon builtin.

---

## 🗂️ Roadmap (Out of MVP v1.0)

- Frekuensi habit non-harian (mingguan, custom).
- Cloud sync + multi-device (Firebase Auth + Firestore).
- Gamification (poin, level, badge).
- Social sharing streak.
- Reminder per habit individual.
- Export data CSV.
- i18n (Bahasa Inggris).

---

## 📜 Lisensi

Aplikasi ini dibuat dari PRD kustom. Bebas digunakan untuk keperluan pribadi & pembelajaran.
