import 'package:cipherschools_flutter_assignment/main.dart';
import 'package:cipherschools_flutter_assignment/pages/edit_profile_page.dart';
import 'package:cipherschools_flutter_assignment/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
    }

    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                  '${userProvider.userInfo.fname} ${userProvider.userInfo.lname}'),
              currentAccountPicture: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1)),
                child: Container(
                    child: ClipOval(
                  child: Image(
                    image: NetworkImage(userProvider.userInfo.purl.toString()),
                  ),
                )),
              ),
              accountEmail: Text(userProvider.userInfo.email),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.purple),
              title: const Text('Account'),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.purple),
              title: const Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.purple),
              title: const Text('Export Data'),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      );
    });
  }
}