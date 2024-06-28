import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/profile.dart';
import 'package:flutter_application_1/prechat.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // # category

            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              alignment: Alignment.center,
              color: Colors.grey,
              child: Text(
                '\n Agarly \n  ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            // first category

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 9),
                  Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  SizedBox(width: 3),
                  Text(
                    ' My Profile ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),

            TextButton(
              onPressed: () {
                // Handle Notifications button press
              },
              child: Row(
                children: [
                  SizedBox(width: 9),
                  Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  SizedBox(width: 3),
                  Text(
                    ' Notifications ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),

            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(
              height: 22,
            ),

            // second category

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 9),
                  Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  SizedBox(width: 3),
                  Text(
                    ' Settings ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),

            TextButton(
              onPressed: () {
                // Handle Technical Support button press
                // !!!!!! don't here ?!
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PreChatPage()));
              },
              child: Row(
                children: [
                  SizedBox(width: 9),
                  Icon(
                    Icons.help,
                    size: 30,
                  ),
                  SizedBox(width: 3),
                  Text(
                    ' Technical Support ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            TextButton(
              onPressed: () {
                // Handle Rate App button press
              },
              child: Row(
                children: [
                  SizedBox(width: 9),
                  Icon(
                    Icons.star,
                    size: 30,
                  ),
                  SizedBox(width: 3),
                  Text(
                    ' Rate App ! ',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  )
                ],
              ),
            ),
            // SizedBox(
            //   height: 18,
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ProfileScreen(),
            //       ),
            //     );
            //     // Handle Rate App button press
            //   },
            //   child: Row(
            //     children: [
            //       SizedBox(width: 9),
            //       Icon(
            //         Icons.add_alert,
            //         size: 30,
            //       ),
            //       SizedBox(width: 3),
            //       Text(
            //         ' zarea  ',
            //         style: TextStyle(
            //           fontSize: 21,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
