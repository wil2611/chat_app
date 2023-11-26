import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../data/model/app_user.dart';
import 'authentication_controller.dart';

class UserController extends GetxController {
  var _users = <AppUser>[].obs;

  final databaseRef = FirebaseDatabase.instance.ref();

  late StreamSubscription<DatabaseEvent> newEntryStreamSubscription;

  late StreamSubscription<DatabaseEvent> updateEntryStreamSubscription;

  String? selectedUserUid;

  void setSelectedUserUid(String uid) {
    selectedUserUid = uid;
  }

  String? getSelectedUserUid() {
    return selectedUserUid;
  }

  get users {
    AuthenticationController authenticationController = Get.find();
    return _users
        .where((entry) => entry.uid != authenticationController.getUid())
        .toList();
  }

  get allUsers => _users;

  void start() {
    _users.clear();

    newEntryStreamSubscription =
        databaseRef.child("userList").onChildAdded.listen(_onEntryAdded);

    updateEntryStreamSubscription =
        databaseRef.child("userList").onChildChanged.listen(_onEntryChanged);
  }

  void stop() {
    newEntryStreamSubscription.cancel();
    updateEntryStreamSubscription.cancel();
  }

  _onEntryAdded(DatabaseEvent event) {
    final json = event.snapshot.value as Map<dynamic, dynamic>;
    _users.add(AppUser.fromJson(event.snapshot, json));
  }

  _onEntryChanged(DatabaseEvent event) {
    var oldEntry = _users.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    final json = event.snapshot.value as Map<dynamic, dynamic>;
    _users[_users.indexOf(oldEntry)] = AppUser.fromJson(event.snapshot, json);
  }

  Future<void> createUser(email, uid) async {
    logInfo("Creating user in realTime for $email and $uid");
    try {
      logInfo("Creating user in realTime for $email and $uid");
      await databaseRef
          .child('userList')
          .push()
          .set({'email': email, 'uid': uid});
      logInfo("User created in realTime for $email and $uid");
      return Future.value();
    } catch (error) {
      logError(error);
      return Future.error(error);
    }
  }
}
