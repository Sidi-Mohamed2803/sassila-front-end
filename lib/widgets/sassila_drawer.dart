// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SassilaDrawer extends StatelessWidget {
  const SassilaDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'images/sassilaDrawer.png',
              ),
              radius: 40,
            ),

            /*decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),*/
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.home,
          //   ),
          //   title: const Text('Home'),
          //   onTap: () => Navigator.pushNamed(context, 'home'),
          // ),
          ListTile(
            leading: Icon(
              Icons.restaurant_menu,
            ),
            title: const Text('Menus'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'menus');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.groups_outlined,
            ),
            title: const Text('Partners'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'partners');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
            ),
            title: const Text('Subscription'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'subscription');
            },
          ),
        ],
      ),
    );
  }
}
