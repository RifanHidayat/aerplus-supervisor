import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/repositories/api.dart';


class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage > {
  bool _obscureText = false;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();





  File image=File("");
  var imagePath="";



  Repositories repo = new Repositories();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: body());
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //logo
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 45, right: 45),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "aer",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: "frankfurter-reguler",
                          color: baseColor),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "plus",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: "frankfurter-reguler",
                          color: baseColor2),
                    )
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 50,
              child: TextFormField(
                controller: usernameController,
                style: TextStyle(fontFamily: "Metropolis-medium"),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 2, left: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(width: 0, color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: baseColor, width: 2.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(
                        color: textFieldColor,
                        fontFamily: "Metropolis-medium")),

                // validator: (value) =>
                // state.isValidPassword ? null : "password is too short",
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 50,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: !_obscureText,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: "Metropolis-medium"),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: textFieldColor,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.only(top: 2, left: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(width: 0, color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: baseColor, width: 2.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor, width: 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: textFieldColor,
                          fontFamily: "Metropolis-medium")),

                  // validator: (value) =>
                  //     state.isValidUsername ? null : "username is too short",
                )),

            const SizedBox(
              height: 50,
            ),

            Container(
              width: Get.mediaQuery.size.width,
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    //Get.to(TrackPage());
                    repo.loginEmployee(context, usernameController.text, passwordController.text);
                  },
                  // onPressed: _loading
                  //     ? null
                  //     : () {
                  //         //Get.to(Na)
                  //         // Get.to(Nav());
                  //
                  //         if (_formKey.currentState!.validate()) {}
                  //       },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(baseColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                  ),
                  child: _loading
                      ? Container(
                      width: 30,
                      height: 30,
                      child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )))
                      : const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 20, fontFamily: "Metropolis-semi-bold"),
                  )),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(color: textFieldColor),
                      )),
                  InkWell(
                      onTap: () {
                        //  Get.toNamed(Routes.recoveryPassword);
                      },
                      child: Container(
                          child: Text(
                            " Reset password",
                            style: TextStyle(color: baseColor),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void chooseImage() async{


  }
}
