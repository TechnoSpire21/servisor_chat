

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:servisor_chat/event/event.dart';
import 'package:servisor_chat/model/model.dart';
import 'package:servisor_chat/pages/fragment/fragment.dart';
import 'package:servisor_chat/utils/utils.dart';

part 'dashboard.dart';
part 'login.dart';
part 'register.dart';
part 'forgot_password.dart';
part 'chat_room.dart';