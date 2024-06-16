import 'dart:io';

import 'package:cipherschools_flutter_assignment/models/user_model.dart';
import 'package:cipherschools_flutter_assignment/providers/user_provider.dart';
import 'package:cipherschools_flutter_assignment/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  bool _image = false;
  File? selectedImage;
  late String fname;
  late String lname;
  String? _gender;

  Future getImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(image);
  }

  Future _cropImage(img) async {
    CroppedFile? cropfile = await ImageCropper().cropImage(
        sourcePath: img.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (cropfile != null) {
      setState(() {
        _image = true;
        selectedImage = File(cropfile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Edit profile",
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                                  : userProvider.userInfo.purl == ''
                                      ? userProvider.userInfo.gender == 'Female'
                                          ? SvgPicture.asset(
                                              'assets/images/profile_female.svg',
                                              height: 100,
                                              width: 100,
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/profile_male.svg',
                                              height: 100,
                                              width: 100,
                                            )
                                      : Image(
                                          image: NetworkImage(
                                              userProvider.userInfo.purl),
                                          height: 100,
                                          width: 100,
                                        )),
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
                  TextFormField(
                    initialValue: userProvider.userInfo.fname,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Color.fromARGB(255, 246, 237, 237),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          LineIcons.user,
                          color: Color.fromARGB(255, 214, 56, 185),
                        ),
                        hintText: "First Name"),
                    onChanged: (value) => fname = value,
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
                  TextFormField(
                    initialValue: userProvider.userInfo.lname,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      filled: true,
                      fillColor: Color.fromARGB(255, 246, 237, 237),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none),
                      prefixIcon: Icon(
                        LineIcons.user,
                        color: Color.fromARGB(255, 214, 56, 185),
                      ),
                      hintText: "Last Name",
                    ),
                    onChanged: (value) => lname = value,
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 17),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(255, 246, 237, 237)),
                    child: DropdownButtonFormField<String>(
                      value: userProvider.userInfo.gender,
                      items: ['Male', 'Female', 'Other'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  isloading
                      ? SpinKitThreeInOut(
                          color: ColorConstants.primary,
                          size: 30.0,
                        )
                      : SizedBox(
                          width: width - 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                setState(() {
                                  isloading = true;
                                });
                                await userProvider.updateUserInfo(
                                    UserModel(
                                        email: 'email',
                                        lname: lname.trim(),
                                        fname: fname.trim(),
                                        gender: _gender.toString(),
                                        purl: userProvider.userInfo.purl),
                                    selectedImage);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor:
                                    const Color.fromARGB(255, 214, 56, 185),
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'notoSans',
                                )),
                            child: const Text('Save',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}