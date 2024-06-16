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
        // appBar: AppBar(
        //   title: const Text('Profile Page'),
        // ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(userProvider.userInfo.purl.toString()),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${userProvider.userInfo.fname} ${userProvider.userInfo.lname}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                    },
                  ),
                ],
              ),
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
