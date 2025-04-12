import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_survey/features/with_held_survey_page/view_model/with_held_survey_store.dart';
import 'package:school_survey/utils/colors.dart';

class WithheldSurveysPage extends StatelessWidget {
  WithheldSurveysPage({super.key});

  final WithheldSurveyStore store = WithheldSurveyStore();

  @override
  Widget build(BuildContext context) {
    store.fetchWithheldSurveys();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Observer(
        builder: (_) {
          if (store.errorMessage != null) {
            return Center(
              child: Text('Error: ${store.errorMessage}', style: const TextStyle(color: AppColors.primaryWhite)),
            );
          }

          final stream = store.withheldSurveysStream;
          if (stream == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading withheld surveys', style: TextStyle(color: AppColors.primaryWhite)),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No with-held Data', style: TextStyle(color: AppColors.primaryPurple)),
                );
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
                          AppColors.primaryBlack.withOpacity(0.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.3),
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
                            const Icon(Icons.assignment, color: AppColors.primaryPurple),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data['name'] ?? 'No name',
                                style: const TextStyle(
                                  color: AppColors.primaryWhite,
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
          );
        },
      ),
    );
  }
}
