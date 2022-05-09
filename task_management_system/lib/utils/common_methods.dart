import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:task_management_system/routes/app_routes.dart';
import 'package:toast/toast.dart';

Future<bool> goToLogin(BuildContext context) {
  return Navigator.of(context)
      .pushReplacementNamed(AppRoutes.LOGOUT)
      // we dont want to pop the screen, just replace it completely
      .then((_) => false);
}

showToast(String msg) {
  Toast.show(
    msg,
    duration: Toast.lengthLong,
    gravity: Toast.bottom,
  );
}

Future sendEmail(String subject, List<String> recipients, String body) async {
  String email = 'task.management.smtp@gmail.com';
  String password = r'Lt@mjVf&$6GM';
  String emailName = 'Task Management';
  // final smtpServer = gmailSaslXoauth2('userEmail', 'accessToken');
  // ignore: deprecated_member_use
  final smtpServer = gmail(email, password);

  final message = Message()
    ..from = Address(email, emailName)
    ..recipients = recipients
    ..subject = subject
    ..text = body;
  try {
    await send(message, smtpServer);
    print('Email sent to ($recipients)');
  } catch (e) {
    showToast('Send mail Failed!');
    print(e);
  }
  return null;
}
