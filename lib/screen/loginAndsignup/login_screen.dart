// ignore_for_file: non_constant_identifier_names, unused_field, prefer_const_constructors, unnecessary_brace_in_string_interps, avoid_print, file_names, sort_child_properties_last

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/login_controller.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/Custom_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cuntryCode = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: WhiteColor,
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: Get.size.height * 0.2,
                    width: Get.size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            BackButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: WhiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Sign in to start".tr,
                              style: TextStyle(
                                color: WhiteColor,
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: gradient.defoultColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    right: 50,
                    bottom: -30,
                    child: Container(
                      height: 60,
                      width: 120,
                      alignment: Alignment.center,
                      // child: Text(
                      //   "Laundry",
                      //   style: TextStyle(
                      //     fontFamily: FontFamily.gilroyBold,
                      //     fontSize: 15,
                      //     color: BlackColor,
                      //   ),
                      // ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/AppIcon.svg",
                              height: 35,
                              width: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              "assets/AppName.svg",
                              height: 25,
                              width: 80,
                            ),
                          ]),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(
                              0.5,
                              0.5,
                            ),
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                        color: WhiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            "Mobile Number".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        IntlPhoneField(
                          initialCountryCode: "IN",
                          keyboardType: TextInputType.number,
                          cursorColor: BlackColor,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: loginController.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          disableLengthCheck: true,
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: greytext,
                          ),
                          dropdownTextStyle: TextStyle(
                            color: greytext,
                          ),
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BlackColor,
                          ),
                          onCountryChanged: (value) {
                            loginController.number.text = '';
                            loginController.password.text = '';
                          },
                          onChanged: (value) {
                            cuntryCode = value.countryCode;
                          },
                          decoration: InputDecoration(
                            hintText: "Mobile Number".tr,
                            hintStyle: TextStyle(
                              color: greytext,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          invalidNumberMessage:
                              "Please enter your mobile number".tr,
                        ),
                        SizedBox(height: Get.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            "Password".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        GetBuilder<LoginController>(builder: (context) {
                          return TextFormField(
                            controller: loginController.password,
                            obscureText: loginController.showPassword,
                            cursorColor: BlackColor,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: BlackColor,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password'.tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  loginController.showOfPassword();
                                },
                                child: !loginController.showPassword
                                    ? Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/showpassowrd.png",
                                          height: 25,
                                          width: 25,
                                          color: greytext,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/HidePassword.png",
                                          height: 25,
                                          width: 25,
                                          color: greytext,
                                        ),
                                      ),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/Unlock.png",
                                  height: 25,
                                  width: 25,
                                  color: greytext,
                                ),
                              ),
                              hintText: "Password".tr,
                              hintStyle: TextStyle(
                                color: greytext,
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: Get.height * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: GetBuilder<LoginController>(
                                  builder: (context) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: BlackColor),
                                      child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        value: loginController.isChecked,
                                        activeColor: BlackColor,
                                        onChanged: (value) async {
                                          loginController
                                              .changeRememberMe(value);

                                          save('Remember', true);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Remember me".tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Gilroy Medium",
                                        color: BlackColor,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.resetPassword);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Forgot Password?".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    color: gradient.defoultColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.02),
                        GestButton(
                          Width: Get.size.width,
                          height: 50,
                          buttoncolor: blueColor,
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          buttontext: "Login".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: WhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          onclick: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              loginController.getLoginApiData(cuntryCode);
                            } else {}
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                color: greyColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.signUpScreen);
                              },
                              child: Text(
                                " Sign Up".tr,
                                style: TextStyle(
                                  color: gradient.defoultColor,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
