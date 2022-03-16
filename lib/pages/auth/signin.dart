import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superviso/assets/colors.dart';
import 'package:superviso/blocs/login/auth_bloc.dart';
import 'package:superviso/blocs/login/auth_event.dart';
import 'package:superviso/blocs/login/auth_state.dart';
import 'package:superviso/blocs/login/form_submission.dart';
import 'package:superviso/nav.dart';
import 'package:superviso/pages/track/track.dart';
import 'package:superviso/repositories/api.dart';
import 'package:superviso/repositories/auth.dart';
import 'package:workmanager/workmanager.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

enum statusLogin { signIn, notSignIn }

class _SigninPageState extends State<SigninPage> {
  bool _obscureText = false;
  bool _loading = false;
  statusLogin _loginStatus = statusLogin.notSignIn;
  final _formKey = GlobalKey<FormState>();
  var usernameController = new TextEditingController();
  var passwordController = new TextEditingController();

  File image = File("");
  var imagePath = "";
  var isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataPref();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }



  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case statusLogin.notSignIn:
        return Scaffold(
            backgroundColor: Colors.white,
            body: BlocProvider(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
              child: body(),
            ));

        break;
      case statusLogin.signIn:
        return Nav();
        break;
    }
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          width: Get.mediaQuery.size.width,
          height: Get.mediaQuery.size.height,
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
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 50,
                  child: TextFormField(
                    controller: usernameController,
                    style: TextStyle(
                        fontFamily: "roboto-regular", color: blackColor2),
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
                            color: textFieldColor, fontFamily: "roboto-regular")),

                    // validator: (value) =>
                    // state.isValidPassword ? null : "password is too short",
                    onChanged: (value) =>
                        context.read<AuthBloc>().add(AuthUsernameChange(value)),
                  ),
                );
              }),

              const SizedBox(
                height: 30,
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_obscureText,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "roboto-regular", color: blackColor2),
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
                            borderSide:
                                BorderSide(color: borderColor, width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: textFieldColor,
                              fontFamily: "roboto-regular")),
                      onChanged: (value) {
                        print(value);
                        context.read<AuthBloc>().add(AuthPasswordChange(value));
                      },

                      // validator: (value) =>
                      //     state.isValidUsername ? null : "username is too short",
                    ));
              }),

              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                final formStatus = state.formStatus;

                if (formStatus is SubmissionFaied) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(
                      formStatus.exception.toString(),
                      style: TextStyle(
                          color: Colors.red,
                          fontFamily: "roboto-regular",
                          fontSize: 11),
                    ),
                  );
                }
                return Container();
              }),

              const SizedBox(
                height: 50,
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return state.formStatus is FormSubmitting
                    ? CircularProgressIndicator(color: baseColor,)
                    : Container(
                        width: Get.mediaQuery.size.width,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 40,
                        child: ElevatedButton(
                            onPressed: _loading
                                ? null
                                : () {
                                    // Get.to(TrackPage());
                                    // Get.to(Nav());

                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<AuthBloc>()
                                          .add(AuthSubmitted());
                                    }
                                  },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(baseColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
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
                                    "Sign In",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "roboto-regular"),
                                  )),
                      );
              }),

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
      ),
    );
  }

  void getDataPref() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print("employee_id${sharedPreferences.getInt("employee_id")}");
    setState(() {
      var isLogin = sharedPreferences.getBool('isLogin');
      _loginStatus =
          isLogin == true ? statusLogin.signIn : statusLogin.notSignIn;
    });
  }
}
