import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserOffline extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String avatar;

  UserOffline({required this.name, required this.avatar});
}
