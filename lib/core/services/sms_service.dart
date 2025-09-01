import 'package:telephony/telephony.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  Future<void> sendSMS(String message, String recipient) async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == true) {
      await telephony.sendSms(to: recipient, message: message);
      print("SMS sent to $recipient");
    } else {
      print("SMS permission not granted");
    }
  }
}
