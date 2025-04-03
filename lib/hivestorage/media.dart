import 'package:hive_flutter/hive_flutter.dart';
part "media.g.dart";

@HiveType(typeId:0)
class Media extends HiveObject
{
  @HiveField(0)
  String path;
  Media({required this.path});
}
