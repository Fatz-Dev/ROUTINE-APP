import 'package:hive/hive.dart';

/// Model Habit dengan dukungan HYBRID tracking:
/// - Binary (default): cukup 1 tap fingerprint per hari untuk "selesai".
/// - Target-based: setiap tap naikkan counter. Selesai jika counter >= target.
class Habit {
  final String id;
  String name;
  String iconKey;
  int colorIndex; // legacy, tidak dipakai di UI monokromatik
  String category;
  String? description;
  bool isActive;

  // Target (opsional)
  bool hasTarget;
  int? targetValue; // 8 gelas, 30 menit, dll
  String? targetUnit; // 'gelas', 'menit', 'halaman', 'kali', 'ml'
  int incrementStep; // berapa nilai ditambah per 1 tap fingerprint (default 1)

  DateTime createdAt;
  DateTime updatedAt;

  Habit({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorIndex,
    required this.category,
    this.description,
    this.isActive = true,
    this.hasTarget = false,
    this.targetValue,
    this.targetUnit,
    this.incrementStep = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  Habit copyWith({
    String? name,
    String? iconKey,
    int? colorIndex,
    String? category,
    String? description,
    bool? isActive,
    bool? hasTarget,
    int? targetValue,
    String? targetUnit,
    int? incrementStep,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      colorIndex: colorIndex ?? this.colorIndex,
      category: category ?? this.category,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      hasTarget: hasTarget ?? this.hasTarget,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      incrementStep: incrementStep ?? this.incrementStep,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  String get targetLabel {
    if (!hasTarget || targetValue == null) return '';
    final unit = targetUnit ?? '';
    return 'Target: $targetValue $unit'.trim();
  }
}

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 11; // bumped dari 1 ke 11 karena schema baru

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Habit(
      id: fields[0] as String? ?? '',
      name: fields[1] as String? ?? 'Unnamed Habit',
      iconKey: fields[2] as String? ?? 'default',
      colorIndex: (fields[3] as int?) ?? 0,
      category: fields[4] as String? ?? 'General',
      description: fields[5] as String?,
      isActive: (fields[6] as bool?) ?? true,
      hasTarget: (fields[7] as bool?) ?? false,
      targetValue: fields[8] as int?,
      targetUnit: fields[9] as String?,
      incrementStep: (fields[10] as int?) ?? 1,
      createdAt: (fields[11] as DateTime?) ?? DateTime.now(),
      updatedAt: (fields[12] as DateTime?) ?? DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconKey)
      ..writeByte(3)
      ..write(obj.colorIndex)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.hasTarget)
      ..writeByte(8)
      ..write(obj.targetValue)
      ..writeByte(9)
      ..write(obj.targetUnit)
      ..writeByte(10)
      ..write(obj.incrementStep)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }
}
