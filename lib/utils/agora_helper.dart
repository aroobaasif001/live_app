import 'package:cloud_functions/cloud_functions.dart';

class AgoraHelper {
  Future<String> getAgoraToken(String channelName, int uid,
      {String role = 'publisher'}) async {
    final functions = FirebaseFunctions.instance;
    try {
      final result = await functions.httpsCallable('generateAgoraToken').call({
        'channelName': channelName,
        'uid': uid,
        'role': role,
      });
      return result.data['token'];
    } catch (e) {
      print('Error generating token: $e');
      return '';
    }
  }
}
