import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:board_project/models/user.dart';
import '../constants/colors.dart';
import 'package:board_project/providers/user_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:board_project/screens/login_secure.dart';

class LoginScreenTest extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenTest> {
  //final _auth = FirebaseAuth.instance;

  UserFirebase userFirebase = UserFirebase(); // UserFirebase 클래스 인스턴스 생성

  late String email;
  late String id;
  late String password;
  bool _saving = false;

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserByEmail(String email) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a query to find the document with the matching email
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('user')
          .where('user_id', isEqualTo: email)
          .limit(1)
          .get();

      // Check if the query returned any results
      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document found (since we used limit(1))
        return querySnapshot.docs.first;
      } else {
        // Return null if no document with the matching email was found
        return null;
      }
    } catch (e) {
      // Handle any errors that may occur during the query
      print('없어: $e');
      return null;
    }
  }
  Future <String> getUserPw(String email) async {

    DocumentSnapshot<Map<String, dynamic>>? userSnapshot = await getUserByEmail(email);
    //print(userSnapshot);
    if (userSnapshot != null) {
      // Document with the matching email found

      Map<String, dynamic> userData = userSnapshot.data()!;

      // Access the user data using the userData map
      String userPassword = userData['user_pw'];

      print(userPassword);

      return userPassword;

    } else {
      // Document with the matching email not found
      print('User with email $email not found');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    userFirebase.initDb();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 150.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                 const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
          ),
              Column(
                children: [
                  RoundedButton(
                    "로그인",
                    Colors.blue,
                        () async {
                      setState(() {
                        _saving = true;
                      });

                        var auth = FirebaseAuthProvider();
                        AuthStatus getLogin=await auth.signIn(email, password);
                        if (!mounted) return;

                        if(getLogin==AuthStatus.loginSuccess){
                          Navigator.pushNamed(context, '/tab');

                        }
                        else
                         {
                           showDialog(
                          context: context,
                          builder: (context) {
                              return AlertDialog(
                                title: const Text("안돼! 다시!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                        );
                      setState(() {
                      email = ''; // Clear the email text field
                      password = ''; // Clear the password text field
                      _saving = false;
                      });

                      }
                    },
                  ),
                  Row(
                    children: [
                      RoundedButton(
                        "아이디 찾기", //아직 구현 안함
                        Colors.blue,
                            () async {

                          },
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      RoundedButton(
                        "비밀번호 찾기", //아직 구현 안함
                        Colors.blue,
                            () async {

                        },
                      ),
                      RoundedButton(
                        "삭제 테스트",
                        Colors.blue,
                            () async {
                              try {
                                await FirebaseAuthProvider().deleteUser(email);
                              logger.i('User with email $email has been deleted.');
                              } catch (e) {
                              logger.e('Error deleting user: $e');
                              }
                          },
                      ),
                      RoundedButton(
                        "회원가입 테스트",
                        Colors.blue,
                            () async {
                          try {
                            await FirebaseAuthProvider().createUser(email,password);
                            //logger.i('User with email $email has been created.');
                          } catch (e) {
                            logger.e('Error creating user: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              )
          ]
        ),
      ),
    )
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton(this.title, this.colour, this.onPressed, {super.key});

  late String title;
  late Color colour;
  late Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 50.0,
          height: 42.0,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}





