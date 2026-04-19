# Catatan untuk Info.plist (iOS)
#
# Package flutter_local_notifications SDK terbaru sudah otomatis
# meminta izin notifikasi saat pertama kali dipakai. Namun untuk
# iOS yang lebih ketat, tambahkan key berikut di `ios/Runner/Info.plist`
# (di dalam tag <dict>):
#
# <key>NSUserNotificationsUsageDescription</key>
# <string>Kami gunakan notifikasi untuk mengingatkanmu presensi habit harian.</string>
#
# Untuk dukungan notifikasi background saat app terminated:
# <key>UIBackgroundModes</key>
# <array>
#     <string>fetch</string>
#     <string>remote-notification</string>
# </array>
