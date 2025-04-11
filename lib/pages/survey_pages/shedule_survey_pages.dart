import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_survey/pages/add_survey.dart';

class ScheduledSurveysPage extends StatelessWidget {
  const ScheduledSurveysPage({super.key});

  Future<void> _deleteSurvey(BuildContext context, DocumentSnapshot doc) async {
    try {
      await FirebaseFirestore.instance.collection('withheld_surveys').add(doc.data() as Map<String, dynamic>);
      await FirebaseFirestore.instance.collection('surveys').doc(doc.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Survey moved to withheld")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('surveys')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading surveys', style: TextStyle(color: Colors.white)));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent));

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No scheduled surveys found.', style: TextStyle(color: Colors.white)));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final surveyName = data['name'] ?? 'Unnamed Survey';
              final reference = data['reference'] ?? 'N/A';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surveyName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Survey Reference"),
                            content: Text(reference),
                            actions: [
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Ref: $reference",
                        style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: 'Start Survey',
                          icon: const Icon(Icons.play_arrow, color: Colors.green),
                          onPressed: () {
                            context.push('/commencement');
                          },
                        ),
                        IconButton(
                          tooltip: 'Edit Survey',
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddSurveyPage(
                                  surveyData: docs[index],
                                  isEditing: true,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Delete Survey',
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteSurvey(context, docs[index]),
                        ),
                      ],
                    )
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
// import 'package:go_router/go_router.dart';
// import 'package:school_survey/pages/add_survey.dart';
// import 'package:school_survey/pages/survey_pages/with_held_survey_page.dart';

// class ScheduledSurveysPage extends StatelessWidget {
//   const ScheduledSurveysPage({super.key});

//   Future<void> _deleteSurvey(BuildContext context, DocumentSnapshot doc) async {
//     try {
//       // Move survey to 'withheld_surveys'
//       await FirebaseFirestore.instance.collection('withheld_surveys').add(doc.data() as Map<String, dynamic>);
//       // Delete original
//       await FirebaseFirestore.instance.collection('surveys').doc(doc.id).delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Survey moved to withheld")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error deleting: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('surveys')
//             .orderBy('created_at', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return const Center(child: Text('Error loading surveys'));
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//           final docs = snapshot.data!.docs;

//           if (docs.isEmpty) return const Center(child: Text('No scheduled surveys found.'));

//           return ListView.separated(
//             itemCount: docs.length,
//             separatorBuilder: (_, __) => const Divider(),
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;

//               return ListTile(
//                 title: Text(data['name'] ?? 'No name'),
//                 subtitle: Text('Ref: ${data['reference'] ?? 'N/A'}'),
//                 trailing: Wrap(
//                   spacing: 8,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.play_arrow, color: Colors.green),
//                       tooltip: 'Start Survey',
//                       onPressed: () {
//                         context.push('/commencement');
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       tooltip: 'Edit Survey',
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => AddSurveyPage(
//                               surveyData: docs[index],
//                               isEditing: true,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       tooltip: 'Delete Survey',
//                       onPressed: () => _deleteSurvey(context, docs[index]),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
