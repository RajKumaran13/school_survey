import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const TopBar({super.key,this.title =''});

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.purple,
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
      ),
      actions: [
            PopupMenuButton<String>(
              color: Colors.black,
              icon: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage(
                      'assets/images/avatar.png',
                    ),
                    radius: 16,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              onSelected: (value) {
                switch (value) {
                  case 'home':
                    context.go('/landing');
                    break;
                  
                  case 'signout':
                    FirebaseAuth.instance.signOut();
                    context.go('/');
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(value: 'home', child: Text('Home',style: TextStyle(color: Colors.white),)),
                    
                    const PopupMenuItem(
                      value: 'signout',
                      child: Text('Sign Out',style: TextStyle(color: Colors.white)),
                    ),
                  ],
            ),
      ],
    );
  }
}
