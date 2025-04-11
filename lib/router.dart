import 'package:go_router/go_router.dart';
import 'package:school_survey/pages/add_survey.dart';
import 'package:school_survey/pages/commoncement_pages/commencement_page.dart';
import 'package:school_survey/pages/landing_page.dart';
import 'package:school_survey/pages/login_user.dart';
import 'package:school_survey/pages/register_user.dart';

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
