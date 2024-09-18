import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<Map<String, String>> getDeviceDetails() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceName = '';
  String deviceVersion = '';
  String identifier = ''; // UUID

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model ?? 'Unknown';
    deviceVersion = androidInfo.version.release ?? 'Unknown';
    identifier = androidInfo.id ?? 'Unknown'; // Menggunakan 'id' untuk mendapatkan androidId
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.name ?? 'Unknown';
    deviceVersion = iosInfo.systemVersion ?? 'Unknown';
    identifier = iosInfo.identifierForVendor ?? 'Unknown'; // Untuk iOS
  }

  return {
    'deviceName': deviceName,
    'deviceVersion': deviceVersion,
    'identifier': identifier,
  };
}
