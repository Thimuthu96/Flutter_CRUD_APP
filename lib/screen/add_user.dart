import 'dart:convert';

import 'package:demo_app/const/constants.dart';
import 'package:demo_app/screen/widgets/confirmation_dialog.dart';
import 'package:demo_app/screen/widgets/my_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new user'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    'Hi,',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Text(
                    'Fill user details below',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  children: [
                    MyFormFiled(
                      hint: 'Name here',
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name must be need';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormFiled(
                      hint: 'Email here',
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Email must be need';
                        } else if (!_isValidEmail(text)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormFiled(
                      hint: 'Contact Number here',
                      inputType: TextInputType.number,
                      controller: contactNumberController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Contact number must be need';
                        } else if (text.length != 10) {
                          return 'Please enter valid contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // check validation
                          if (_formKey.currentState!.validate()) {
                            showAlertDialog(
                              context,
                              'Add User!',
                              'Are you sure to add this user?',
                              () async {
                                await _createUser();
                              },
                            );
                          } else {
                            setState(
                              () => _autovalidateMode = AutovalidateMode.always,
                            );
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   label: Text('Add here'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  Future _createUser() async {
    //API end-point url
    final url = Uri.parse('${baseUrl}api/users');

    //Data to be sent in to request body
    final Map<String, dynamic> data = {
      "name": nameController.text,
      "email": emailController.text,
      "contact_number": int.parse(contactNumberController.text),
    };

    //Encode the data to the json

    final dataJson = jsonEncode(data);

    try {
      //Send POST request
      final res = await http.post(url, body: dataJson, headers: {
        'Content-Type': 'application/json',
      });

      //check response status code
      if (res.statusCode == 200) {
        debugPrint('POST request successful!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'User added successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      } else {
        debugPrint('POST request failed with status code : ${res.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
