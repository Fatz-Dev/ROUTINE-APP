import 'package:hive/hive.dart';

class UserProfile {
  String name;
  DateTime createdAt;
  DateTime lastActive;
  bool onboardingDone;

  UserProfile({
    required this.name,
    required this.createdAt,
    required this.lastActive,
    this.onboardingDone = false,
  });

  UserProfile copyWith({
    String? name,
    DateTime? lastActive,
    bool? onboardingDone,
  }) {
    return UserProfile(
      name: name ?? this.name,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    return UserProfile(
      name: reader.readString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      lastActive: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      onboardingDone: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeInt(obj.lastActive.millisecondsSinceEpoch);
    writer.writeBool(obj.onboardingDone);
  }
}
