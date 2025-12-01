import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleepys/widgets/user_profile.dart';
import 'package:sleepys/widgets/logout_button.dart';
import 'package:sleepys/widgets/feedback.dart';
import 'package:sleepys/helper/ProfileImageProvider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: FutureBuilder<String?>(
        future: _getImagePath(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error loading profile image: ${snapshot.error}');
            return Center(child: Text('Error loading profile image'));
          } else if (snapshot.hasData && snapshot.data != null) {
            String imagePath = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.grey,
                    backgroundImage: FileImage(File(imagePath)),
                    child: imagePath.isEmpty
                        ? Icon(
                            Icons.person,
                            size: screenSize.width * 0.15,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Divider(color: Colors.grey),
                  Infoprofile(screenSize: screenSize),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.01,
                      horizontal: screenSize.width * 0.05,
                    ),
                    child: Card(
                      color: Color(0xFF272E49),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.025),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                              'assets/images/detil.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Detil profil',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Userprofile(email: email),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.15,
                            ),
                            child: Divider(color: Colors.grey, height: 0),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/terms.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.15,
                            ),
                            child: Divider(color: Colors.grey, height: 0),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/feedback.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Feedback',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  LogoutButton(screenSize: screenSize),
                ],
              ),
            );
          } else {
            
            return Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: screenSize.width * 0.15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Divider(color: Colors.grey),
                  Infoprofile(screenSize: screenSize),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.01,
                      horizontal: screenSize.width * 0.05,
                    ),
                    child: Card(
                      color: Color(0xFF272E49),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenSize.width * 0.025),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                              'assets/images/detil.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Detil profil',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Userprofile(email: email),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.15,
                            ),
                            child: Divider(color: Colors.grey, height: 0),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/terms.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.15,
                            ),
                            child: Divider(color: Colors.grey, height: 0),
                          ),
                          ListTile(
                            leading: Image.asset(
                              'assets/images/feedback.png',
                              height: screenSize.width * 0.06,
                              width: screenSize.width * 0.06,
                            ),
                            title: Text(
                              'Feedback',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Image.asset(
                              'assets/images/next.png',
                              height: screenSize.width * 0.08,
                              width: screenSize.width * 0.08,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  LogoutButton(screenSize: screenSize),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<String?> _getImagePath(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return prefs.getString('${email}_profile_image');
  }
}

class Infoprofile extends StatelessWidget {
  final Size screenSize;

  Infoprofile({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
      ],
    );
  }
}
