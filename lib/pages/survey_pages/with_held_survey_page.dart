import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WithheldSurveysPage extends StatelessWidget {
  const WithheldSurveysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid)
            .collection('withheld_surveys')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading withheld surveys', style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No with-held Data', style: TextStyle(color: Colors.purple),));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No withheld surveys.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.assignment, color: Colors.purpleAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            data['name'] ?? 'No name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number, color: Colors.white70, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Ref: ${data['reference'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class WithheldSurveysPage extends StatelessWidget {
//   const WithheldSurveysPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(  
//       //appBar: AppBar(title: const Text('Withheld Surveys')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('withheld_surveys')
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return const Center(child: Text('Error loading withheld surveys'));
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//           final docs = snapshot.data!.docs;

//           if (docs.isEmpty) {
//             return const Center(child: Text('No withheld surveys.'));
//           }

//           return ListView.separated(
//             itemCount: docs.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;

//               return ListTile(
//                 title: Text(data['name'] ?? 'No name'),
//                 subtitle: Text('Ref: ${data['reference'] ?? 'N/A'}'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
