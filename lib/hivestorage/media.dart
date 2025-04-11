import 'package:hive/hive.dart';

part 'media.g.dart'; // Make sure this matches your filename

@HiveType(typeId: 0)
class Media extends HiveObject {
  @HiveField(0)
  String path;

  @HiveField(1)
  String? model;

  @HiveField(2)
  String? make;

  @HiveField(3)
  String? width;

  @HiveField(4)
  String? height;

  @HiveField(5)
  String? orientation;

  @HiveField(6)
  String? dateCreated;

  @HiveField(7)
  String? timeCreated;

  @HiveField(8)
  String? fNumber;

  @HiveField(9)
  String? isoSpeed;

  @HiveField(10)
  String? flash;

  @HiveField(11)
  String? focalLength;

  @HiveField(12)
  DateTime? date;

  Media({
    required this.path,
    this.model,
    this.make,
    this.width,
    this.height,
    this.orientation,
    this.dateCreated,
    this.timeCreated,
    this.fNumber,
    this.isoSpeed,
    this.flash,
    this.focalLength,
    this.date,
  });
}
