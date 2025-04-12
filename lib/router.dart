import 'package:go_router/go_router.dart';
import 'package:school_survey/features/add_survey_page/view/add_survey_page.dart';
import 'package:school_survey/features/commencement_page/view/commencement_page.dart';
import 'package:school_survey/features/landing_page/view/landing_page.dart';
import 'package:school_survey/features/login_page/view/login_view.dart';
import 'package:school_survey/features/register_page/view/register_view.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/landing', builder: (context, state) => const LandingPage()),
    GoRoute(
      path: '/addsurvey',
      builder: (context, state) => const AddSurveyPage(),
    ),
    GoRoute(
      path: '/commencement',
      builder: (context, state) => const CommencementPage(),
    ),
  ],
);
