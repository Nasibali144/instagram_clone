import 'dart:convert';
import 'package:http/http.dart';
import 'package:instagram_clone/core/error/exception.dart';

abstract class NotificationDataSource {
  Map<String, dynamic> notificationParams(String fcmToken, String username, String someoneName);
  Future<String> pushNotification(Map<String, dynamic> params);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final Client client;
  String BASE = 'fcm.googleapis.com';
  String API_SEND = '/fcm/send';
  Map<String, String> headers = {
    'Authorization': 'key=AAAA5MHM-E4:APA91bEfK5pcHOIsxSiRilfQM0PeGjIvlzyoJ61ubTkNEIBHywEkWXL19mqWaPLSfpQK0Tf7hVQbLL0zBaynnsMFuGZdwU2QeN6hQRZSUISG0aTNTseET4F0nq-FVpYhDn5QSxMoT6jv',
    'Content-Type': 'application/json'
  };

  NotificationDataSourceImpl({required this.client});

  @override
  Map<String, dynamic> notificationParams(String fcmToken, String username, String someoneName) {
    Map<String, dynamic> params = {};
    params.addAll({
      'notification': {
        'title': 'My Instagram: $someoneName',
        'body': '$username followed you!'
      },
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }

  @override
  Future<String> pushNotification(Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw ServerException();
    }
  }
}