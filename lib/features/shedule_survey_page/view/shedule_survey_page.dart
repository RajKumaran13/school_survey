import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_survey/features/add_survey_page/view/add_survey_page.dart';
import 'package:school_survey/features/shedule_survey_page/view_model/shedule_survey_store.dart';
import 'package:school_survey/utils/colors.dart';

class ScheduledSurveysPage extends StatelessWidget {
  ScheduledSurveysPage({super.key});
  final ScheduledSurveyStore store = ScheduledSurveyStore();

  @override
  Widget build(BuildContext context) {
    store.fetchScheduledSurveys();
    return Container(
      color: AppColors.primaryBlack,
      child: Observer(
        builder: (_) {
          if (store.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${store.errorMessage}',
                style: const TextStyle(color: AppColors.primaryWhite),
              ),
            );
          }

          final stream = store.scheduledSurveysStream;
          if (stream == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPurple),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasError)
                return const Center(
                  child: Text(
                    'Error loading surveys',
                    style: TextStyle(color: AppColors.primaryWhite),
                  ),
                );
              if (!snapshot.hasData)
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryPurple,
                  ),
                );

              final docs = snapshot.data!.docs;
              if (docs.isEmpty)
                return const Center(
                  child: Text(
                    'No scheduled surveys found.',
                    style: TextStyle(color: AppColors.primaryWhite),
                  ),
                );

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final surveyName = data['name'] ?? 'Unnamed Survey';
                  final reference = data['reference'] ?? 'N/A';
                  final assignedBy = data['assigned_by'] ?? 'N/A';
                  final assignedTo = data['assigned_to'] ?? 'N/A';
                  final commenceDate = data['commencement_date'] ?? 'N/A';
                  final dueDate = data['due_date'] ?? 'N/A';
                  final discription = data['description'] ?? 'N/A';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryPurple.withOpacity(0.2),
                          AppColors.primaryBlack.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.primaryPurple,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              isScrollControlled: true,
                              builder:
                                  (_) => DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.5,
                                    minChildSize: 0.4,
                                    maxChildSize: 0.95,
                                    builder:
                                        (_, controller) => Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    16,
                                                    16,
                                                    16,
                                                    80,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      width: 40,
                                                      height: 4,
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white54,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Survey Details",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          AppColors
                                                              .primaryWhite,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      controller: controller,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildDetail(
                                                            "Name",
                                                            surveyName,
                                                          ),
                                                          _buildDetail(
                                                            "Reference",
                                                            reference,
                                                          ),
                                                          _buildDetail(
                                                            "Assigned By",
                                                            assignedBy,
                                                          ),
                                                          _buildDetail(
                                                            "Assigned To",
                                                            assignedTo,
                                                          ),
                                                          _buildDetail(
                                                            "Commencement Date",
                                                            commenceDate,
                                                          ),
                                                          _buildDetail(
                                                            "Due Date",
                                                            dueDate,
                                                          ),
                                                          _buildDetail(
                                                            "Description",
                                                            discription,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Floating Close Button
                                            Positioned(
                                              bottom: 20,
                                              right: 20,
                                              child:
                                                  FloatingActionButton.extended(
                                                    backgroundColor:
                                                        Colors.white,
                                                    label: const Text(
                                                      "Close",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors
                                                                .primaryPurple,
                                                      ),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color:
                                                          AppColors
                                                              .primaryPurple,
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                  ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "REF NO : $reference",
                                style: const TextStyle(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  //decoration: TextDecoration.underline,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                                size: 20,
                                color: AppColors.primaryPurple,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          surveyName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                context.push('/commencement');
                              },
                              child: Container(
                                height: 22,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Edit Survey',
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primaryPurple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AddSurveyPage(
                                          surveyData: docs[index],
                                          isEditing: true,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: 'Delete Survey',
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.primaryPurple,
                              ),
                              onPressed: () => store.deleteSurvey(docs[index]),
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

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryWhite,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
