// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/controller/signup_controller.dart';
import 'package:laundry/model/fontfamily_model.dart';
import 'package:laundry/screen/loginAndsignup/login_screen.dart';
import 'package:laundry/screen/loginAndsignup/resetpassword_screen.dart';
import 'package:laundry/utils/Colors.dart';
import 'package:laundry/utils/Custom_widget.dart';

import '../../controller/msg_otp_controller.dart';
import '../../controller/sms_type_controller.dart';
import '../../controller/twilio_otp_controller.dart';
import 'otp_screen.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cuntryCode = "";

  SmsTypeController smsTypeController = Get.put(SmsTypeController());
  MsgOtpController msgOtpController = Get.put(MsgOtpController());
  TwilioOtpController twilioOtpController = Get.put(TwilioOtpController());

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
                            "Create Your Account".tr,
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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          "Full Name".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        controller: signUpController.name,
                        cursorColor: BlackColor,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BlackColor,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/user.png",
                              height: 22,
                              width: 22,
                              color: greytext,
                            ),
                          ),
                          hintText: "Full Name".tr,
                          hintStyle: TextStyle(
                            color: greytext,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          "Email Address".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        controller: signUpController.email,
                        cursorColor: BlackColor,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BlackColor,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "assets/email.png",
                              height: 25,
                              width: 25,
                              color: greytext,
                            ),
                          ),
                          hintText: "Email Address".tr,
                          hintStyle: TextStyle(
                            color: greytext,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'.tr;
                          }
                          return null;
                        },
                      ),
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
                        initialCountryCode: "IN",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: signUpController.number,
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
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BlackColor,
                        ),
                        onChanged: (value) {
                          cuntryCode = value.countryCode;
                        },
                        onCountryChanged: (value) {
                          signUpController.number.text = '';
                        },
                        decoration: InputDecoration(
                          helperText: null,
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
                        validator: (p0) {
                          if (p0!.completeNumber.isEmpty) {
                            return 'Please enter your number'.tr;
                          } else {}
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                      GetBuilder<SignUpController>(builder: (context) {
                        return TextFormField(
                          controller: signUpController.password,
                          obscureText: signUpController.showPassword,
                          cursorColor: BlackColor,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BlackColor,
                          ),
                          onChanged: (value) {},
                          decoration: InputDecoration(
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
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                signUpController.showOfPassword();
                              },
                              child: !signUpController.showPassword
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password'.tr;
                            }
                            return null;
                          },
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Text(
                          "Referral code".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        controller: signUpController.referralCode,
                        cursorColor: BlackColor,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BlackColor,
                        ),
                        decoration: InputDecoration(
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
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          hintText: "Referral code (optional)".tr,
                          hintStyle: TextStyle(
                            color: greytext,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GetBuilder<SignUpController>(builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Transform.scale(
                              scale: 1,
                              child: Checkbox(
                                value: signUpController.chack,
                                side:
                                    const BorderSide(color: Color(0xffC5CAD4)),
                                activeColor: blueColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (newbool) async {
                                  signUpController
                                      .checkTermsAndCondition(newbool);
                                  save('Remember', true);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "By creating an account,you agree to our".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: greytext,
                                    fontFamily: FontFamily.gilroyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "Terms and Condition".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: gradient.defoultColor,
                                    fontFamily: FontFamily.gilroyBold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                      GestButton(
                        Width: Get.size.width,
                        height: 50,
                        buttoncolor: blueColor,
                        margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                        buttontext: "Continue".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyBold,
                          color: WhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        onclick: () {
                          if ((_formKey.currentState?.validate() ?? false) &&
                              (signUpController.chack == true)) {
                            signUpController.checkMobileNumber(cuntryCode).then((value) {
                              var decodeValue = jsonDecode(value);
                              print("++--+98565565556++++++++ ${decodeValue}");
                              if(decodeValue["Result"] == "true"){
                                smsTypeController.smsTypeApi().then((smsType) {
                                  if(smsType["Result"] == "true"){
                                    print("cscvdxvdcvfcbgbgn");
                                    if(smsType["otp_auth"] == "No"){
                                      signUpController.setUserApiData(cuntryCode);
                                    }else {
                                      if (smsType["SMS_TYPE"] == "Firebase") {
                                        print("cscvdxvdcvfcbgbgn");
                                        sendOTP(signUpController.number.text, cuntryCode);
                                        Get.to(() =>
                                            OtpScreen(
                                              ccode: cuntryCode,
                                              number: signUpController.number.text,
                                              Email: signUpController.email.text,
                                              FullName: signUpController.name.text,
                                              Password: signUpController.password.text,
                                              Signup: "signUpScreen",
                                              otpCode: "",
                                              msgType: smsType["SMS_TYPE"],
                                              
                                            ));
                                      } else if (smsType["SMS_TYPE"] == "Msg91") {
                                        //  msg_otp;
                                        print("cscvdxvdcvfcbgbgn");
                                        msgOtpController.msgOtpApi(mobile: "$cuntryCode${signUpController.number.text}").then((msgOtp) {
                                          print("************* $msgOtp");
                                          if (msgOtp["Result"] == "true") {
                                            Get.to(() =>
                                                OtpScreen(
                                                  ccode: cuntryCode,
                                                  number: signUpController.number.text,
                                                  Email: signUpController.email.text,
                                                  FullName: signUpController.name.text,
                                                  Password: signUpController.password.text,
                                                  Signup: "signUpScreen",
                                                  otpCode: msgOtp["otp"].toString(),
                                                  msgType: smsType["SMS_TYPE"],

                                                ));
                                            print("++++++++msgOtp+++++++++++ ${msgOtp["otp"]}");
                                          } else {
                                            showToastMessage(
                                                "Invalid mobile number");
                                          }
                                        },);
                                      } else if (smsType["SMS_TYPE"] == "Twilio") {
                                        print("cscvdxvdcvfcbgbgn");
                                        twilioOtpController.twilioOtpApi(
                                            mobile: "$cuntryCode${signUpController.number.text}").then((twilioOtp) {
                                          print("---------- $twilioOtp");
                                          if (twilioOtp["Result"] == "true") {
                                            Get.to(() =>
                                                OtpScreen(
                                                  ccode: cuntryCode,
                                                  number: signUpController.number.text,
                                                  Email: signUpController.email.text,
                                                  FullName: signUpController.name.text,
                                                  Password: signUpController.password.text,
                                                  Signup: "signUpScreen",
                                                  otpCode: twilioOtp["otp"].toString(),
                                                  msgType: smsType["SMS_TYPE"],
                                                ));
                                            print(
                                                "++++++++twilioOtp+++++++++++ ${twilioOtp["otp"]}");
                                          } else {
                                            showToastMessage(
                                                "Invalid mobile number".tr);
                                          }
                                        },);
                                      } else {
                                        showToastMessage(
                                            "Invalid mobile number".tr);
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
                          } else {
                            if (signUpController.chack == false) {
                              showToastMessage("Please select Terms and Condition".tr);
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                color: greytext,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(LoginScreen());
                              },
                              child: Text(
                                " Login".tr,
                                style: TextStyle(
                                  color: gradient.defoultColor,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
