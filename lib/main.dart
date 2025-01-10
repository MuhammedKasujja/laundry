// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use, unnecessary_string_escapes

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/helpar/routes_helper.dart';
import 'package:laundry/localstring.dart';
import 'package:laundry/utils/Custom_widget.dart';
import 'package:laundry/utils/cart_item.dart';
import 'package:laundry/utils/cartitem_adapter.dart';
import 'firebase_options.dart';
import 'helpar/get_di.dart' as di;

void main() async {
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cart');
  await di.init();
  initPlatformState();
  runApp(
    GetMaterialApp(
      title: "Fast Laundry",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        dividerColor: Colors.transparent,
        primarySwatch: Colors.blue,
        fontFamily: "Gilroy",
        useMaterial3: false,
        // androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      translations: LocaleString(),
      locale: getData.read("lan2") != null
          ? Locale(getData.read("lan2"), getData.read("lan1"))
          : Locale('en_US', 'en_US'),
      initialRoute: Routes.initial,
      getPages: getPages,
    ),
  );
}