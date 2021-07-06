
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servisor_chat/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.dart';
part 'notif_controller.dart';