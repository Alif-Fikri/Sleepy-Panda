import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sleepys/helper/ProfileImageProvider.dart';
import 'package:provider/provider.dart';
import 'package:sleepys/helper/api_endpoints.dart';

class Userprofile extends StatefulWidget {
  final String email;
  final ImagePicker _picker = ImagePicker();

  Userprofile({super.key, required this.email});

  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  String? selectedGender;
  bool isLoading = true;
  File? _image;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _pickImage() async {
    final pickedFile = await widget._picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('${widget.email}_profile_image', pickedFile.path);
    }
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    
    final imagePath = prefs.getString('${widget.email}_profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }

    if (token == null) {
      print('No token found');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        ApiEndpoints.usersByEmail(widget.email),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response Data: $data'); 

        setState(() {
          nameController.text = data['name'] ?? 'N/A';
          emailController.text = widget.email;

          
          if (data['gender'] != null) {
            selectedGender = data['gender'] == 1 ? 'male' : 'female';
          } else {
            selectedGender = null;
          }

          if (data['date_of_birth'] != null) {
            DateTime dob = DateTime.parse(data['date_of_birth']);
            dobController.text = DateFormat('dd/MM/yyyy').format(dob);
          } else {
            dobController.text = 'N/A';
          }

          isLoading = false;
        });
      } else {
        print('Failed to load user data');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('No token found');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.patch(
        ApiEndpoints.usersPatch(widget.email),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          
          'email': widget.email,
          'name': nameController.text,
          'gender': selectedGender == 'male' ? 1 : 0, 
          'date_of_birth': DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd/MM/yyyy').parse(dobController.text)),
        }),
      );
      print('Data dikirim: ${jsonEncode(<String, dynamic>{
            'email': widget.email,
            'name': nameController.text,
            'gender': selectedGender == 'male' ? 1 : 0,
            'date_of_birth': DateFormat('yyyy-MM-dd')
                .format(DateFormat('dd/MM/yyyy').parse(dobController.text)),
          })}');

      if (response.statusCode == 200) {
        print('User data updated successfully');
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Berhasil!",
            text: "Data telah diperbarui.",
          ),
        );
        Navigator.pop(context);
      } else {
        print('Failed to update user data');
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Gagal!",
            text: "Gagal memperbarui data.",
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      await ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title: "Kesalahan!",
          text: "Terjadi kesalahan, coba lagi nanti.",
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF20223F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF20223F),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                children: [
                  Container(
                    width:
                        screenSize.width * 0.2, 
                    height: screenSize.width * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Colors.grey, 
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit
                                  .cover, 
                            )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: screenSize.width * 0.15,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  SizedBox(
                      height:
                          10), 
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Text(
                      'Ubah Foto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildProfileItem('assets/images/detil.png', 'Nama',
                      nameController, true, screenSize),
                  buildProfileItem('assets/images/email.png', 'Email',
                      emailController, false, screenSize),
                  buildGenderDropdown(screenSize),
                  buildDatePicker(screenSize),
                  SizedBox(height: screenSize.height * 0.03),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.0625,
                      width: screenSize.width * 0.875,
                      child: ElevatedButton(
                        onPressed: () {
                          updateUserData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00ADB5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenSize.width * 0.05),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.045,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildProfileItem(String imagePath, String label,
      TextEditingController controller, bool showPencilIcon, Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: screenSize.width * 0.035,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Container(
              width: screenSize.width * 0.875,
              height: screenSize.height * 0.06875,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {},
                readOnly: label == 'Email', 
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF272E49),
                  hintText: label,
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(screenSize.width * 0.03),
                    child: Image.asset(
                      imagePath,
                      width: screenSize.width * 0.06,
                      height: screenSize.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: showPencilIcon && label != 'Email'
                      ? Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.035),
                          child: Image.asset(
                            'assets/images/edit.png',
                            height: screenSize.width * 0.05,
                            width: screenSize.width * 0.05,
                            color: Colors.white,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.025),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGenderDropdown(Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: screenSize.width * 0.035,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Container(
              width: screenSize.width * 0.875,
              height: screenSize.height * 0.06875,
              child: DropdownButtonFormField<String>(
                value: selectedGender, 
                hint: Text(
                  'Pilih Gender',
                  style: TextStyle(color: Colors.white),
                ),
                dropdownColor: Color(0xFF272E49),
                items: ['male', 'female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Urbanist')),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF272E49),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.025),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal Lahir',
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.white,
                fontSize: screenSize.width * 0.035,
              ),
            ),
            SizedBox(height: screenSize.height * 0.01),
            Container(
              width: screenSize.width * 0.875,
              height: screenSize.height * 0.06875,
              child: TextField(
                controller: dobController,
                onTap: () async {
                  DateTime? date = await DatePicker.showSimpleDatePicker(
                    context,
                    initialDate: DateTime(1994),
                    firstDate: DateTime(1960),
                    lastDate: DateTime(2012),
                    dateFormat: "dd-MMMM-yyyy",
                    locale: DateTimePickerLocale.id,
                    looping: true,
                  );
                  if (date != null) {
                    setState(() {
                      dobController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF272E49),
                  hintText: 'Tanggal Lahir',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Urbanist',
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(screenSize.width * 0.03),
                    child: Image.asset(
                      'assets/images/calendar.png',
                      width: screenSize.width * 0.06,
                      height: screenSize.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(screenSize.width * 0.025),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Urbanist',
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
