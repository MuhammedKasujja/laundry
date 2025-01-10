// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, unnecessary_string_interpolations, sort_child_properties_last, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundry/controller/signup_controller.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/Custom_widget.dart';

import '../../controller/login_controller.dart';
import '../../controller/msg_otp_controller.dart';
import '../../controller/sms_type_controller.dart';
import '../../controller/twilio_otp_controller.dart';
import 'otp_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static String verifay = "";

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  SignUpController signUpController = Get.find();
  SmsTypeController smsTypeController = Get.put(SmsTypeController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
  TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());

  TextEditingController number = TextEditingController();

  String cuntryCode = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Forgot password".tr,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
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
                    keyboardType: TextInputType.number,
                    cursorColor: BlackColor,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    initialCountryCode: 'IN',
                    controller: number,
                    onChanged: (value) {
                      cuntryCode = value.countryCode;
                    },
                    onCountryChanged: (value) {
                      number.text = '';
                    },
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: greytext,
                    ),
                    dropdownTextStyle: TextStyle(
                      color: greytext,
                    ),
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BlackColor,
                    ),
                    decoration: InputDecoration(
                      helperText: null,
                      labelText: "Mobile Number".tr,
                      labelStyle: TextStyle(
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
                    validator: (p0) {
                      if (p0!.completeNumber.isEmpty) {
                        return 'Please enter your number'.tr;
                      } else {}
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestButton(
                    Width: Get.size.width,
                    height: 50,
                    buttoncolor: blueColor,
                    margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                    buttontext: "Request OTP".tr,
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: WhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    onclick: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        signUpController.checkMobileInResetPassword(number: number.text, cuntryCode: cuntryCode).then((value) {
                          print("+++++++++++ ${value}");
                          var decodeValue = jsonDecode(value);
                          if(decodeValue["Result"] == "false"){
                            smsTypeController.smsTypeApi().then((smsType) {
                              if(smsType["Result"] == "true"){
                                print("cscvdxvdcvfcbgbgn");
                                if(smsType["otp_auth"] == "No"){
                                  forgetPasswordBottomSheet();
                                } else{
                                  if(smsType["SMS_TYPE"] == "Firebase"){
                                    sendOTP(number.text, cuntryCode);
                                    Get.to(() =>
                                        OtpScreen(
                                          ccode: cuntryCode,
                                          number: number.text,
                                          Email: signUpController.email.text,
                                          FullName: signUpController.name.text,
                                          Password: signUpController.password.text,
                                          Signup: "resetScreen",
                                          otpCode: "",
                                          msgType: smsType["SMS_TYPE"],
                                        ));
                                  }else if (smsType["SMS_TYPE"] == "Msg91"){
                                    //  msg_otp;
                                    print("cscvdxvdcvfcbgbgn");
                                    msgOtpController.msgOtpApi(mobile: "$cuntryCode${number.text}").then((msgOtp) {
                                      print("************* ${msgOtp}");
                                      if(msgOtp["Result"] == "true"){
                                        Get.to(() =>
                                            OtpScreen(
                                              ccode: cuntryCode,
                                              number: number.text,
                                              Email: signUpController.email.text,
                                              FullName: signUpController.name.text,
                                              Password: signUpController.password.text,
                                              Signup: "resetScreen",
                                              otpCode: msgOtp["otp"].toString(),
                                              msgType: smsType["SMS_TYPE"],
                                            ));
                                        print("++++++++msgOtp+++++++++++ ${msgOtp["otp"]}");
                                      }else{
                                        showToastMessage("Invalid mobile number");
                                      }
                                    },);
                                  }else if(smsType["SMS_TYPE"] == "Twilio"){
                                    print("cscvdxvdcvfcbgbgn");
                                    twilioOtpController.twilioOtpApi(mobile: "$cuntryCode${number.text}").then((twilioOtp) {
                                      print("---------- $twilioOtp");
                                      if(twilioOtp["Result"] == "true"){
                                        Get.to(() =>
                                            OtpScreen(
                                              ccode: cuntryCode,
                                              number: number.text,
                                              Email: signUpController.email.text,
                                              FullName: signUpController.name.text,
                                              Password: signUpController.password.text,
                                              Signup: "resetScreen",
                                              otpCode: twilioOtp["otp"].toString(),
                                              msgType: smsType["SMS_TYPE"],
                                            ));
                                        print("++++++++twilioOtp+++++++++++ ${twilioOtp["otp"]}");
                                      }else{
                                        showToastMessage("Invalid mobile number".tr);
                                      }
                                    },);
                                  }else{
                                    showToastMessage("Invalid mobile number".tr);
                                  }

                                }
                              }else{
                                showToastMessage("Invalid mobile number".tr);
                              }
                            },
                            );
                          }else{
                            showToastMessage(decodeValue["ResponseMsg"]);
                          }
                        },);
                      }
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
                        "You remember your password?".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          color: greytext,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.loginScreen);
                        },
                        child: Text(
                          " Log In".tr,
                          style: TextStyle(
                            color: blueColor,
                            fontFamily: FontFamily.gilroyMedium,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  LoginController loginController = Get.put(LoginController());
  Future forgetPasswordBottomSheet() {
    return Get.bottomSheet(
      GetBuilder<LoginController>(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 350,
            width: Get.size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Forgot Password".tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Divider(
                    color: greytext,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    "Create Your New Password".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      color: BlackColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: loginController.newPassword,
                    obscureText: loginController.newShowPassword,
                    cursorColor: BlackColor,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyMedium,
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
                        borderSide: BorderSide(color: greycolor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          loginController.newShowOfPassword();
                        },
                        child: !loginController.newShowPassword
                            ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/showpassowrd.png",
                            height: 22,
                            width: 22,
                            color: greytext,
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/HidePassword.png",
                            height: 22,
                            width: 22,
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
                      labelText: "Password".tr,
                      labelStyle: TextStyle(
                        color: greytext,
                        fontFamily: FontFamily.gilroyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: loginController.newConformPassword,
                    obscureText: loginController.conformPassword,
                    cursorColor: BlackColor,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 14,
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
                        borderSide: BorderSide(color: greycolor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: greycolor),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          loginController.newConformShowOfPassword();
                        },
                        child: !loginController.conformPassword
                            ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/showpassowrd.png",
                            height: 22,
                            width: 22,
                            color: greytext,
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/HidePassword.png",
                            height: 22,
                            width: 22,
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
                      labelText: "Conform Password".tr,
                      labelStyle: TextStyle(
                        color: greytext,
                        fontFamily: FontFamily.gilroyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestButton(
                  Width: Get.size.width,
                  height: 50,
                  buttoncolor: blueColor,
                  margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                  buttontext: "Continue".tr,
                  style: TextStyle(
                    fontFamily: "Gilroy Bold",
                    color: WhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  onclick: () {
                    if (loginController.newPassword.text ==
                        loginController.newConformPassword.text) {
                      loginController.setForgetPasswordApi(ccode: cuntryCode, mobile: number.text);
                    } else {
                      showToastMessage("Please Enter Valid Password".tr);
                    }
                  },
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<void> sendOTP(String phonNumber, String cuntryCode,) async {
  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: '${cuntryCode + phonNumber}',
    verificationCompleted: (PhoneAuthCredential credential) {},
    verificationFailed: (FirebaseAuthException e) {
      print(e.toString());
    },
    timeout: Duration(seconds: 60),
    codeSent: (String verificationId, int? resendToken) {
      ResetPasswordScreen.verifay = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
