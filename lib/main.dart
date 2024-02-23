

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_client/db_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:sk_kitchen/firebase_options.dart';
import 'package:sk_kitchen/models/cart.dart';
import 'package:sk_kitchen/repositories/cart_repository.dart';
import 'package:sk_kitchen/repositories/category_repository.dart';
import 'package:sk_kitchen/repositories/product_repository.dart';
import 'package:sk_kitchen/screens/cart_screen.dart';
import 'package:sk_kitchen/screens/catalog_screen.dart';
import 'package:sk_kitchen/screens/category_screen.dart';
import 'package:sk_kitchen/screens/checkout_screen.dart';

final dbClient = DbClient();
final categoryRepository = CategoryRepository(dbClient: dbClient);
final productRepository = ProductRepository(dbClient: dbClient);
const cartRepository = CartRepository();
const userId = 'user_1234';
var cart = const Cart(
    userId: userId,
    cartItems: []
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  categoryRepository.createCategories();
  productRepository.createProducts();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_de15012691074b8aa59db63e0809b54f',
      enabledDebugging: true,
      builder: (context,navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const CategoriesScreen(),
          navigatorKey: navKey,
          localizationsDelegates: const [KhaltiLocalizations.delegate
          ],

          onGenerateRoute: (settings) {
            if (settings.name == '/categories') {
              return MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              );
            }
            if (settings.name == '/cart') {
              return MaterialPageRoute(
                builder: (context) => const CartScreen(),
              );
            }

            if (settings.name == '/checkout') {
              return MaterialPageRoute(
                builder: (context) => const CheckoutScreen(),
              );
            }


            if (settings.name == '/catalog') {
              return MaterialPageRoute(
                  builder: (context) => CatalogScreen(
                        category: settings.arguments as String,
                      ));
            } else {
              return MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              );
            }
          },
        );
      }
    );
  }
}
//2:00:30 https://www.youtube.com/watch?v=xYgIY_1ulhw&t=459s
