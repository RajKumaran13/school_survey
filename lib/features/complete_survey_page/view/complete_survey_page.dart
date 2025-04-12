import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:school_survey/features/commencement_page/model/schood.dart';
import 'package:school_survey/features/complete_survey_page/view_model/completed_survey_store.dart';
import 'package:school_survey/utils/colors.dart';


class SchoolDataListPage extends StatefulWidget {
  const SchoolDataListPage({super.key});

  @override
  State<SchoolDataListPage> createState() => _SchoolDataListPageState();
}

class _SchoolDataListPageState extends State<SchoolDataListPage> {
  final SchoolDataStore _store = SchoolDataStore();

  @override
  void initState() {
    super.initState();
    _store.loadSchoolData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: Observer(
        builder: (_) {
          if (_store.schoolList.isEmpty) {
            return const Center(
              child: Text(
                'No school data found',
                style: TextStyle(color: AppColors.primaryWhite, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _store.schoolList.length,
            itemBuilder: (context, index) {
              final school = _store.schoolList[index];
              return _buildSchoolCard(school);
            },
          );
        },
      ),
    );
  }

  Widget _buildSchoolCard(SchoolData school) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            color: AppColors.primaryPurple.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.primaryWhite.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: const TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow('Type', school.type),
                _infoRow('Established', school.establishedOn.toLocal().toString().split(' ')[0]),
                _infoRow('Curriculum', school.curriculum.join(', ')),
                _infoRow('Grades', school.grades.join(', ')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [ 
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
