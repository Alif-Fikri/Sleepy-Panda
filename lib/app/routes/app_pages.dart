import 'package:get/get.dart';

import '../modules/alarm/alarm_binding.dart';
import '../modules/alarm/alarm_view.dart';
import '../modules/auth/auth_choice/auth_choice_binding.dart';
import '../modules/auth/auth_choice/auth_choice_view.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/signup/signup_binding.dart';
import '../modules/auth/signup/signup_view.dart';
import '../modules/feedback/feedback_binding.dart';
import '../modules/feedback/feedback_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/metrics/blood_pressure/blood_pressure_binding.dart';
import '../modules/metrics/blood_pressure/blood_pressure_view.dart';
import '../modules/metrics/daily_steps/daily_steps_binding.dart';
import '../modules/metrics/daily_steps/daily_steps_view.dart';
import '../modules/metrics/heart_rate/heart_rate_binding.dart';
import '../modules/metrics/heart_rate/heart_rate_view.dart';
import '../modules/metrics/sleep_schedule/sleep_schedule_binding.dart';
import '../modules/metrics/sleep_schedule/sleep_schedule_view.dart';
import '../modules/onboarding/date/date_binding.dart';
import '../modules/onboarding/date/date_view.dart';
import '../modules/onboarding/gender/gender_binding.dart';
import '../modules/onboarding/gender/gender_view.dart';
import '../modules/onboarding/height/height_binding.dart';
import '../modules/onboarding/height/height_view.dart';
import '../modules/onboarding/name/name_binding.dart';
import '../modules/onboarding/name/name_view.dart';
import '../modules/onboarding/weight/weight_binding.dart';
import '../modules/onboarding/weight/weight_view.dart';
import '../modules/onboarding/work/work_binding.dart';
import '../modules/onboarding/work/work_view.dart';
import '../modules/prediction/agreement/prediction_agreement_binding.dart';
import '../modules/prediction/agreement/prediction_agreement_view.dart';
import '../modules/prediction/result/prediction_result_binding.dart';
import '../modules/prediction/result/prediction_result_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile_detail/profile_detail_binding.dart';
import '../modules/profile_detail/profile_detail_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.authChoice,
      page: AuthChoiceView.new,
      binding: AuthChoiceBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: LoginView.new,
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: SignupView.new,
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingName,
      page: OnboardingNameView.new,
      binding: OnboardingNameBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingGender,
      page: OnboardingGenderView.new,
      binding: OnboardingGenderBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingWork,
      page: OnboardingWorkView.new,
      binding: OnboardingWorkBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingDate,
      page: OnboardingDateView.new,
      binding: OnboardingDateBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingHeight,
      page: OnboardingHeightView.new,
      binding: OnboardingHeightBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingWeight,
      page: OnboardingWeightView.new,
      binding: OnboardingWeightBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.predictionDaily,
      page: PredictionAgreementView.new,
      binding: PredictionDailyBinding(),
    ),
    GetPage(
      name: AppRoutes.predictionWeek,
      page: PredictionAgreementView.new,
      binding: PredictionWeeklyBinding(),
    ),
    GetPage(
      name: AppRoutes.predictionMonth,
      page: PredictionAgreementView.new,
      binding: PredictionMonthlyBinding(),
    ),
    GetPage(
      name: AppRoutes.predictionResult,
      page: PredictionResultView.new,
      binding: PredictionResultBinding(),
    ),
    GetPage(
      name: AppRoutes.metricsBloodPressure,
      page: BloodPressureView.new,
      binding: BloodPressureBinding(),
    ),
    GetPage(
      name: AppRoutes.metricsDailySteps,
      page: DailyStepsView.new,
      binding: DailyStepsBinding(),
    ),
    GetPage(
      name: AppRoutes.metricsHeartRate,
      page: HeartRateView.new,
      binding: HeartRateBinding(),
    ),
    GetPage(
      name: AppRoutes.metricsSleep,
      page: SleepScheduleView.new,
      binding: SleepScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: ProfileView.new,
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.profileDetail,
      page: ProfileDetailView.new,
      binding: ProfileDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: FeedbackView.new,
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: AppRoutes.alarm,
      page: AlarmView.new,
      binding: AlarmBinding(),
    ),
  ];
}
