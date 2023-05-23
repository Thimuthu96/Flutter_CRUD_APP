import 'dart:convert';

import 'package:demo_app/const/constants.dart';
import 'package:demo_app/screen/models/user_model.dart';
import 'package:demo_app/screen/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<User>> fetchData() async {
    var url = Uri.parse('${baseUrl}api/users');
    late http.Response res;

    List<User> userData = [];

    try {
      res = await http.get(url);
      if (res.statusCode == 200) {
        // Map data1 = jsonDecode(res.body);
        List<dynamic> data = jsonDecode(res.body);

        for (var user in data) {
          var id = user["id"];
          var email = user["email"];
          var name = user["name"];
          var contactNumber = user["contact_number"];

          User newUser = User(id, name, email, contactNumber);
          userData.add(newUser);
        }
      } else {
        return Future.error(
            'Something went wrong! Status code : ${res.statusCode}');
      }
    } catch (e) {
      return Future.error(e.toString());
    }

    return userData;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.dashboard),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-new',
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement the refreshing logic here
          fetchData();
          await Future.delayed(const Duration(seconds: 2));
          setState(() {
            // Update your data or state variables here
            // For example: myData = fetchData();
          });
        },
        child: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else {
                if (snapshot.data.length == 0) {
                  return const Center(
                    child: Text('No data!'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].email),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/update-user",
                                arguments: jsonEncode({
                                  "id": snapshot.data[index].id,
                                  "name": snapshot.data[index].name,
                                  "email": snapshot.data[index].email,
                                  "contactNumber":
                                      snapshot.data[index].contactNumber,
                                }));
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                        onLongPress: () {
                          showAlertDialog(context, 'Delete user!',
                              'Are you sure to delete this user?', () async {
                            await deleteUser(snapshot.data[index].id);
                          });
                        },
                      );
                    },
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }

  Future deleteUser(int id) async {
    //Api end point url
    final url = Uri.parse('${baseUrl}api/users/$id');

    try {
      //send DELETE request
      final res = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      //check response
      if (res.statusCode == 200) {
        debugPrint('DELETE request successful!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'User deleted successfully!',
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
        debugPrint(
            'DELETE request failed with status code : ${res.statusCode}');
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
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
