import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remedy/component/a.dart';

import '../auth.dart';
import '../component/user_credentials.dart';
import '../widget_tree.dart';
import 'google_maps.dart';
import 'home_page_new.dart';
import 'medicine_description.dart';
import 'onboarding_screen.dart';

// ignore_for_file: body_might_complete_normally_nullable

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? currentUser = Auth().currentUser;

  final FirebaseFirestore _firestoreAuth = FirebaseFirestore.instance;
  final TextEditingController _inputNameController = TextEditingController();

  Future<void> signOut() async {
    await Auth().signOut();
    Get.to(const WidgetTree());
  }

  // To get only currentusers data
  Future<UserCredentials?> okuUser() async {
    final docUser = _firestoreAuth.collection('Person').doc(currentUser?.uid);
    final snaphot = await docUser.get();

    if (snaphot.exists) {
      return UserCredentials.fromJson(snaphot.data()!);
    }
  }

  Widget buildUser(UserCredentials usercredentials) {
    return Text(
      usercredentials.name,
    );
  }

  Widget userUser(UserCredentials usercredentials) {
    return Text(
      usercredentials.email,
    );
  }

  /*  to get all user datas
    Stream<List<UserCredentials>> readUsers() => FirebaseFirestore.instance
      .collection('Person')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserCredentials.fromJson(doc.data()))
          .toList());
*/

  Widget _title() {
    return const Text('Remedy');
  }

  Widget _userUid() {
    return Text(currentUser?.email ?? 'User email');
  }

  Widget _merhaba() {
    return const Text('Merhaba!');
  }

  Widget _inputName() {
    return TextField(
      controller: _inputNameController,
      decoration: const InputDecoration(labelText: 'isim'),
    );
  }

// TODO: more updates and visual page required
  Widget _updateName() {
    return ElevatedButton(
      child: const Text('Update name'),
      onPressed: () {
        var docUser = _firestoreAuth.collection('Person').doc(currentUser?.uid);
        docUser.update(
          {
            'name': _inputNameController.text,
          },
        );
        Get.to(HomePage());
      },
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Widget _goToDescription() {
    return ElevatedButton(
        onPressed: () => Get.to(const MedicineDescription()),
        child: const Text("Go To Description List"));
  }

  Widget _goToGPS() {
    return ElevatedButton(
        onPressed: () => Get.to(const MapsPage()), child: const Text("GPS"));
  }

  Widget _goToOnBoardingScreen() {
    return ElevatedButton(
      onPressed: () => Get.to(OnBoardingScreen()),
      child: const Text("Go To OnBoarding Screen."),
    );
  }

  Widget _goToNewHomePage() {
    return ElevatedButton(
        onPressed: () => Get.to(NewHomePage()),
        child: const Text("Go To New Home Page."));
  }

  Widget _goToTestHomePage() {
    return ElevatedButton(
        onPressed: () => Get.to(MyHomePage()),
        child: const Text("Go To Test Home Page"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu), //Menü ayarlanacak.
          onPressed: () => Get.to(HomePage()),
        ),
        centerTitle: true,
        title: _title(),
      ),
      body: FutureBuilder<UserCredentials?>(
          future: okuUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final okuUser = snapshot.data!;
              return Column(
                children: [
                  buildUser(okuUser),
                  userUser(okuUser),
                  _merhaba(),
                  _userUid(),
                  _signOutButton(),
                  _goToDescription(),
                  _goToGPS(),
                  _goToOnBoardingScreen(),
                  _goToNewHomePage(),
                  _updateName(),
                  _inputName(),
                  _goToTestHomePage(),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
