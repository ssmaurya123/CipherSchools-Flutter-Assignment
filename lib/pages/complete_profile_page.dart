import 'dart:io';

import 'package:cipherschools_flutter_assignment/main.dart';
import 'package:cipherschools_flutter_assignment/models/user_model.dart';
import 'package:cipherschools_flutter_assignment/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final _formKey = GlobalKey<FormState>();

  List<String> GenderCategories = ['Male', 'Female', 'Other'];
  bool _image = false;
  String _fname = '';
  String _lname = '';
  String gender = 'Male';
  String profileUrl = '';
  bool loading = false;
  File? selectedImage;

  Future getImage() async {
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (image != null) {
        await _cropImage(image);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future _cropImage(XFile imageFile) async {
    try {
      CroppedFile? cropfile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );

      if (cropfile != null) {
        setState(() {
          _image = true;
          selectedImage = File(cropfile.path);
        });
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Set up your profile",
          style: GoogleFonts.notoSans(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 115,
                        width: 100,
                        child: Stack(children: [
                          Positioned(
                            top: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _image
                                  ? Image.file(
                                      selectedImage!,
                                      height: 100,
                                      width: 100,
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/profile_male.svg',
                                      height: 100,
                                      width: 100,
                                    ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 30,
                              left: 30,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Color.fromARGB(255, 214, 56, 185),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      getImage();
                                    },
                                  )))
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "First name",
                      style: GoogleFonts.notoSans(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter First name.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _fname = value;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 237, 237),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              LineIcons.user,
                              color: Color.fromARGB(255, 214, 56, 185),
                            ),
                            hintText: "First Name"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Last name",
                      style: GoogleFonts.notoSans(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Last name.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _lname = value;
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            filled: true,
                            fillColor: Color.fromARGB(255, 246, 237, 237),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              LineIcons.user,
                              color: Color.fromARGB(255, 214, 56, 185),
                            ),
                            hintText: "Last Name"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Gender",
                      style: GoogleFonts.notoSans(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 17),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 246, 237, 237)),
                      child: DropdownButton(
                        isExpanded: true,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        hint: const Text(
                            'Select Your Gender'), // Not necessary for Option 1
                        value: gender,
                        onChanged: (newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        items: GenderCategories.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(height: 10.0),
                    loading
                        ? const SpinKitThreeInOut(
                            color: Color.fromARGB(255, 214, 56, 185),
                            size: 30.0,
                          )
                        : SizedBox(
                            width: width - 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  try {
                                    await userProvider.updateUserInfo(
                                        UserModel(
                                            email: FirebaseAuth
                                                .instance.currentUser!.email
                                                .toString(),
                                            lname: _lname,
                                            fname: _fname,
                                            gender: gender,
                                            purl: 'purl'),
                                        selectedImage);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage()));
                                  } catch (e) {
                                    print('Error updating user info: $e');
                                  } finally {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor:
                                      const Color.fromARGB(255, 214, 56, 185),
                                  padding: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'notoSans',
                                  )),
                              child: const Text('Signup',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
