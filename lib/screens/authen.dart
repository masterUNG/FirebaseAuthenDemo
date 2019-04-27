import 'package:flutter/material.dart';
import './register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String appName = "Firebase Authen";
  final formKey = GlobalKey<FormState>();
  String email, password;

  // For Firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Widget showAppName() {
    return Text(
      appName,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget emailTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email :',
          hintText: 'you@email.com',
          icon: Icon(Icons.email)),
      validator: (String value) {
        if (value.length == 0) {
          return 'Please Type Your Email';
        } else if (!((value.contains('@')) && (value.contains('.')))) {
          return 'Please Type Format you@email.com';
        }
      },
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget passwordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: 'Password :',
          hintText: 'More 6 Charactor'),
      validator: (String value) {
        if (value.length == 0) {
          return 'Please Type Your Password';
        } else if (value.length <= 5) {
          return 'Password More 5 Charactor';
        }
      },
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget signInButton() {
    return RaisedButton.icon(
      color: Colors.blue[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      icon: Icon(
        Icons.input,
        color: Colors.white,
      ),
      label: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          checkAuthen();
        }
      },
    );
  }

  void checkAuthen() async {
    print('email = $email, password = $password');

    FirebaseUser firebaseUser = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('value1 ==> $value');
    }).catchError((value) {
      print('value2 ==> $value');
    });
  }

  Widget singUpButton(BuildContext context) {
    return RaisedButton.icon(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      icon: Icon(
        Icons.group_add,
        color: Colors.blue[700],
      ),
      label: Text(
        'Sign Up',
        style: TextStyle(color: Colors.blue[700]),
      ),
      onPressed: () {
        var registerRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(registerRoute);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                center: Alignment(0, -1),
                colors: [Colors.white, Colors.blue],
                radius: 1.0)),
        padding: EdgeInsets.all(50.0),
        alignment: Alignment(0, -1),
        child: Column(
          children: <Widget>[
            Container(
              child: showAppName(),
            ),
            Container(
              child: emailTextFormField(),
            ),
            Container(
              child: passwordTextFormField(),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: signInButton(),
                  ),
                  Expanded(
                    child: singUpButton(context),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
