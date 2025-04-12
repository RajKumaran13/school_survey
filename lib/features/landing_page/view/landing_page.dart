import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:school_survey/common/top_bar.dart';
import 'package:school_survey/features/complete_survey_page/view/complete_survey_page.dart';
import 'package:school_survey/features/landing_page/view_model/landing_store.dart';
import 'package:school_survey/features/shedule_survey_page/view/shedule_survey_page.dart';
import 'package:school_survey/features/with_held_survey_page/view/with_held_survey_page.dart';
import 'package:school_survey/utils/colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final UserStore userStore = UserStore();

  @override
  void initState() {
    super.initState();
    userStore.loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (userStore.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.primaryBlack,
            body: Center(
              child: CircularProgressIndicator(color: Colors.purpleAccent),
            ),
          );
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppColors.primaryBlack,
            appBar: TopBar(title: 'Hi, ${userStore.userName}'),
            body: Column(
              children: [
                Container(
                  color: AppColors.primaryPurple,
                  child: const TabBar(
                    labelColor: AppColors.primaryWhite,
                    unselectedLabelColor: AppColors.primaryBlack,
                    indicatorColor: AppColors.primaryWhite,
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
                    icon: const Icon(Icons.add, color: AppColors.primaryWhite),
                    label: const Text(
                      'Add Survey',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
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
        );
      },
    );
  }
}
