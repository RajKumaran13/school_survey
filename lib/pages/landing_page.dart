

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:school_survey/common/top_bar.dart';
import 'package:school_survey/pages/survey_pages/complete_survey_page.dart';
import 'package:school_survey/pages/survey_pages/shedule_survey_pages.dart';
import 'package:school_survey/pages/survey_pages/with_held_survey_page.dart';
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

    Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final name = doc.data()?['name'] ?? 'User';
      setState(() {
        _userName = name;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar:  TopBar(title: 'Hi,$_userName',),
          body: Column(
            children: [
              Container(
                color: Colors.purple,
                child: const TabBar(
                  
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: 'Scheduled Surveys'),
                    Tab(text: 'Completed Surveys'),
                    Tab(text: 'With-held Surveys'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ScheduledSurveysPage(),
                    SchoolDataListPage(), 
                    WithheldSurveysPage(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/addsurvey'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Survey',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    elevation: 6,
                    shadowColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
// import 'package:school_survey/common/top_bar.dart';

// class LandingPage extends StatelessWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return Scaffold(
//       appBar: const TopBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome, ${user?.email ?? 'Guest'}!',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
                
//               },
//               //onPressed: () => context.go('/add-survey'),
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: const Text(
//                 'Add Survey',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo, // Button color
//                 elevation: 6,
//                 shadowColor: Colors.indigoAccent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
