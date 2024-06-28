// ignore_for_file: unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/agarly/screens/new/firebase/ChatsScreen.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

import 'agarly/screens/new/HomeDrawer.dart';
import 'agarly/screens/new/add.dart';
import 'agarly/screens/new/chat.dart';
import 'agarly/screens/new/explore.dart';
import 'agarly/screens/new/firebase/splashScreen.dart';
import 'agarly/screens/new/homeScreen.dart';
import 'agarly/screens/new/profile.dart';
import 'agarly/screens/new/whishlist.dart';
import 'home.dart';
import 'prechat.dart';

////////////////////////////////
Future<void> main() async {
// ...
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyD4JX1WWQ2ze0fd7kZI--dMnd3pdovzBjc",
          appId: "1:723789969350:android:8d909fd724fa06d38424c7",
          messagingSenderId: "723789969350",
          projectId: "agarly-a8560",
        ))
      : await Firebase.initializeApp();
  runApp(MyApp2());
}

MethodChannel channel = MethodChannel('kommunicate_flutter');

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState2 createState() => _MyAppState2();
}

class _MyAppState2 extends State<MyApp2> {
  @override
  void initState() {
    channel.setMethodCallHandler((call) {
      if (call.method == 'onPluginLaunch') {
        print(call.arguments);
      } else if (call.method == 'onPluginDismiss') {
        print(call.arguments);
      } else if (call.method == 'onConversationResolved') {
        print(call.arguments);
      } else if (call.method == 'onConversationRestarted') {
        print(call.arguments);
      } else if (call.method == 'onRichMessageButtonClick') {
        print(call.arguments);
      } else if (call.method == 'onStartNewConversation') {
        print(call.arguments);
      } else if (call.method == 'onMessageSent') {
        print(call.arguments);
      }

      return Future(() => null);
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Color(0xff5c5aa7),
        //   // title: const Text('Kommunicate sample app'),
        // ),
        body: SplashScreen(),
      ),
    );
  }
}

//new host home page

class HostHomePage extends StatefulWidget {
  const HostHomePage({Key? key}) : super(key: key);

  @override
  _HostHomePageState createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    WishlistScreen(),
    UploadDataPage(),
    chatscreenn(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Agarly'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    WishlistScreen(),
    // const UploadDataPage(),
    chatscreenn(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Agarly'),
      ),

      //add drawer ya zara3

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add),
          //   label: 'Add',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        onTap: _onItemTapped,
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  TextEditingController userId = new TextEditingController();
  TextEditingController password = new TextEditingController();

  void loginAsVisitor(context) {
    KommunicateFlutterPlugin.loginAsVisitor("36cc72f6ad3530b45de5a28435823ecc5")
        .then((result) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      print("Login as visitor successful : " + result.toString());
    }).catchError((error) {
      print("Login as visitor failed : " + error.toString());
    });
  }

  void buildConversation() {
    dynamic conversationObject = {'appId': "36cc72f6ad3530b45de5a28435823ecc5"};

    KommunicateFlutterPlugin.buildConversation(conversationObject)
        .then((result) {
      print("Conversation builder success : " + result.toString());
    }).catchError((error) {
      print("Conversation builder error occurred : " + error.toString());
    });
  }

  void buildConversationWithPreChat(context) {
    try {
      KommunicateFlutterPlugin.isLoggedIn().then((value) {
        print("Logged in : " + value.toString());
        if (value) {
          KommunicateFlutterPlugin.buildConversation({
            'isSingleConversation': true,
            'appId': "36cc72f6ad3530b45de5a28435823ecc5"
          }).then((result) {
            print("Conversation builder success : " + result.toString());
          }).catchError((error) {
            print("Conversation builder error occurred : " + error.toString());
          });
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PreChatPage()));
        }
      });
    } on Exception catch (e) {
      print("isLogged in error : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    KommunicateFlutterPlugin.openConversations();
    // Navigator.pop(context);
    try {
      KommunicateFlutterPlugin.isLoggedIn().then((value) {
        print("Logged in : " + value.toString());
        if (value) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    } on Exception catch (e) {
      print("isLogged in error : " + e.toString());
    }

    return SizedBox();
  }
}
