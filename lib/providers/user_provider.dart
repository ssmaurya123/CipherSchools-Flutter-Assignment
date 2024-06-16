import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  late UserModel _userInfo;
  bool _isLoading = true;

  UserModel get userInfo => _userInfo;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      _isLoading = true;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      _userInfo = UserModel(
        email: data['email'],
        lname: data['lname'],
        fname: data['fname'],
        gender: data['gender'],
        purl: data['purl'],
      );
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error loading user data: $error');
      // Handle the error as needed, e.g., set default values
      _userInfo = UserModel(
        email: 'JohnDoe@gmail.com',
        fname: 'John',
        lname: 'Doe',
        gender: 'Male',
        purl:
            'https://firebasestorage.googleapis.com/v0/b/cipherschools-assignment-007.appspot.com/o/profile_images%2Fim12.jpg?alt=media&token=ac9b84be-add7-4fe8-94ea-5d9de60fbd50',
      );
      _isLoading = false;

      // Notify listeners even in case of an error to update the UI
      notifyListeners();
    }
  }

  Future<void> updateUserInfo(UserModel user, File? selectedImage) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    String profileUrl = userInfo.purl;

    try {
      _isLoading = true;
      if (selectedImage != null) {
        final imagesRef =
            FirebaseStorage.instance.ref().child("profile_images/$userId.jpeg");
        try {
          await imagesRef.putFile(
              selectedImage, SettableMetadata(contentType: "images/jpeg"));
          profileUrl = (await imagesRef.getDownloadURL()).toString();
        } on FirebaseException catch (e) {
          print(e.toString());
        }
      }
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': FirebaseAuth.instance.currentUser!.email,
        'lname': user.lname,
        'purl': profileUrl,
        'fname': user.fname,
        'gender': user.gender,
      });

      _userInfo = UserModel(
          email: FirebaseAuth.instance.currentUser!.email.toString(),
          lname: user.lname,
          fname: user.fname,
          gender: user.gender,
          purl: profileUrl);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}