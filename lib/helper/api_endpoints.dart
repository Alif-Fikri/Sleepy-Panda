class ApiEndpoints {
  static const String baseUrl = 'http://0.0.0.0:8000';

  
  static Uri authRegister() => Uri.parse('$baseUrl/auth/register');
  static Uri authLogin() => Uri.parse('$baseUrl/auth/login');
  static Uri authToken() => Uri.parse('$baseUrl/auth/token');
  static Uri authLogout() => Uri.parse('$baseUrl/auth/logout');
  static Uri authRequestOtp(String email) =>
      Uri.parse('$baseUrl/auth/request-otp').replace(queryParameters: {
        'email': email,
      });
  static Uri authVerifyOtp(String email, String otp) =>
      Uri.parse('$baseUrl/auth/verify-otp').replace(queryParameters: {
        'email': email,
        'otp': otp,
      });
  static Uri authResetPassword(String email, String newPassword) =>
      Uri.parse('$baseUrl/auth/reset-password').replace(queryParameters: {
        'email': email,
        'new_password': newPassword,
      });

  
  static Uri usersBasic() => Uri.parse('$baseUrl/users/basic');
  static Uri usersByEmail(String email) =>
      Uri.parse('$baseUrl/users/${Uri.encodeComponent(email)}');
  static Uri usersWork(String email) =>
      Uri.parse('$baseUrl/users/${Uri.encodeComponent(email)}/work');
  static Uri usersPatch(String email) => usersByEmail(email);
  static Uri usersMetrics(String email) =>
      Uri.parse('$baseUrl/users/${Uri.encodeComponent(email)}/metrics');
  static Uri usersMe() => Uri.parse('$baseUrl/users/me');
  static Uri usersMeProfile() => Uri.parse('$baseUrl/users/me/profile');

  
  static Uri predictionsRun() => Uri.parse('$baseUrl/predictions/run');
  static Uri predictionsSave() => Uri.parse('$baseUrl/predictions/save');
  static Uri predictionsWeekly() => Uri.parse('$baseUrl/predictions/weekly');
  static Uri predictionsWeeklySave() =>
      Uri.parse('$baseUrl/predictions/weekly/save');
  static Uri predictionsMonthly() => Uri.parse('$baseUrl/predictions/monthly');
  static Uri predictionsMonthlySave() =>
      Uri.parse('$baseUrl/predictions/monthly/save');

  
  static Uri sleepRecords() => Uri.parse('$baseUrl/sleep/records');
  static Uri sleepRecordsByEmail(String email) =>
      Uri.parse('$baseUrl/sleep/records/${Uri.encodeComponent(email)}');
  static Uri sleepWeekly(String email, {String? startDate, String? endDate}) {
    final uri =
        Uri.parse('$baseUrl/sleep/weekly/${Uri.encodeComponent(email)}');
    return uri.replace(queryParameters: {
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  static Uri sleepMonthly(String email, {String? month, String? year}) {
    final uri =
        Uri.parse('$baseUrl/sleep/monthly/${Uri.encodeComponent(email)}');
    return uri.replace(queryParameters: {
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    });
  }

  
  static Uri feedback() => Uri.parse('$baseUrl/feedback');
}
