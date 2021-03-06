import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  String name, email, password;

  // for Firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Widget nameTextFormField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Name :',
            hintText: 'Type Your Name',
            icon: Icon(Icons.face)),
        validator: (String value) {
          if (value.length == 0) {
            return 'Please fill Your Name in the Blank';
          }
        },
        onSaved: (String value) {
          name = value;
        },
      ),
    );
  }

  Widget emailTextFormField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Email :',
            hintText: 'you@email.com',
            icon: Icon(Icons.email)),
        validator: (String value) {
          if (value.length == 0) {
            return 'Please Fill Email in the Blank';
          } else if (!((value.contains('@')) && (value.contains('.')))) {
            return 'Please Type Format Email';
          }
        },
        onSaved: (String value) {
          email = value;
        },
      ),
    );
  }

  Widget passwordTextFormField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Password :',
            hintText: 'More 6 Charactor',
            icon: Icon(Icons.lock)),
        validator: (String value) {
          if (value.length <= 5) {
            return 'Please More 6 Charactor';
          }
        },
        onSaved: (String value) {
          password = value;
        },
      ),
    );
  }

  Widget uploadButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          uplodaValueToFirebase();
        }
      },
    );
  }

  void uplodaValueToFirebase() async {
    print('name = $name, email = $email, password = $password');
    final FirebaseUser firebaseUser = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      print('SignUp Success');
    }).catchError((error) {
      print('Error ==> $error');
    });

    await firebaseAuth.currentUser().then((value){
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      value.updateProfile(userUpdateInfo);
      print('DisplayName ==> ${firebaseUser.displayName}');
    });

    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          actions: <Widget>[uploadButton()],
        ),
        body: Form(
          key: formKey,
          child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    radius: 1.2,
                    colors: [Colors.white, Colors.blue],
                    center: Alignment(0, -1))),
            padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
            child: Column(
              children: <Widget>[
                nameTextFormField(),
                emailTextFormField(),
                passwordTextFormField()
              ],
            ),
          ),
        ));
  }
}
