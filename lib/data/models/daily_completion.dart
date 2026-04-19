import 'package:hive/hive.dart';

/// Catatan presensi untuk 1 habit di 1 tanggal.
/// - Binary habit: cukup ada record = selesai.
/// - Target habit: [progressValue] menumpuk; selesai jika >= targetSnapshot.
class DailyCompletion {
  final String id;
  final String habitId;
  final String dateKey; // yyyy-MM-dd
  final DateTime completionDate;
  DateTime completedAt; // waktu tap terakhir
  int progressValue; // jumlah tap (binary=1) atau akumulasi (target)
  int? targetSnapshot; // snapshot target pada hari ini

  DailyCompletion({
    required this.id,
    required this.habitId,
    required this.dateKey,
    required this.completionDate,
    required this.completedAt,
    this.progressValue = 1,
    this.targetSnapshot,
  });

  bool get isFullyCompleted {
    if (targetSnapshot == null) return true; // binary
    return progressValue >= targetSnapshot!;
  }

  double get progressRatio {
    if (targetSnapshot == null) return 1.0;
    if (targetSnapshot == 0) return 0.0;
    return (progressValue / targetSnapshot!).clamp(0.0, 1.0);
  }
}

class DailyCompletionAdapter extends TypeAdapter<DailyCompletion> {
  @override
  final int typeId = 12; // bumped dari 2 ke 12

  @override
  DailyCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return DailyCompletion(
      id: fields[0] as String? ?? '',
      habitId: fields[1] as String? ?? '',
      dateKey: fields[2] as String? ?? '',
      completionDate: (fields[3] as DateTime?) ?? DateTime.now(),
      completedAt: (fields[4] as DateTime?) ?? DateTime.now(),
      progressValue: (fields[5] as int?) ?? 1,
      targetSnapshot: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyCompletion obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.dateKey)
      ..writeByte(3)
      ..write(obj.completionDate)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.progressValue)
      ..writeByte(6)
      ..write(obj.targetSnapshot);
  }
}
