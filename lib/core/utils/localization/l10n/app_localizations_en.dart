// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Personal Tasks';

  @override
  String get login => 'Login';

  @override
  String get logging => 'logging';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get register => 'Register';

  @override
  String get registering => 'Registering';

  @override
  String get not_have_account => 'Don\'t Have An Account?';

  @override
  String get create_your_account => 'Create Your Account';

  @override
  String get select_image_source => 'Select Image Source';

  @override
  String get where_do_you_want_to_pick_image => 'Where do you want to pick the image from?';

  @override
  String get gallery => 'Gallery';

  @override
  // TODO: implement week_password
  String get week_password => 'Week Password';

  @override

  @override
  String get camera => 'Camera';

  @override

  @override
  String get open_mail => 'Open mail';

  @override
  String get name_required => 'Name required';

  @override
  String get phone_number_required => 'Phone number required';

  @override
  String get email_required => 'Email Is Required';

  @override
  String get password_required => 'Password Is Required';

  @override
  String get please_enter_valid_email => 'Please Enter Valid Email';

  @override
  String get connection_Error_no_internet => 'Connection Error, No Internet';

  @override
  String get this_user_not_found => 'This user not found';

  @override
  String get email_is_not_verified => 'Email is not verified';

  @override
  // TODO: implement you_can_not_edit_on_task
  String get you_can_not_edit_on_task => 'You can not edit on this task, you are not the owner';

  @override
  String get pending_tasks => 'Tasks Waiting to Upload';

  @override
  String get no_tasks_found => 'No tasks found';

  @override
  String get add_images => 'Add Images';

  @override
  String get no_images_selected => 'No Images Selected';

  @override
  String get name => 'Name';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get already_have_account => 'Already Have An Account';

  @override
  String get home => 'Home';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get passwords_match => 'Passwords match';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get login_failed => 'Login Failed';

  @override
  String get register_failed => 'Field To Register';

  @override
  String get something_went_wrong => 'Something went wrong please , try again';

  @override
  String get register_success => 'Register Success';

  @override
  String get email_verification_sent => 'We were sent a email verification to your email, check your email';

  @override
  String get password_not_match => 'Password Not Match';

  @override
  String get more => 'More';

  @override
  String get profile => 'Profile';

  @override
  String get change_password => 'Change Password';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get error => 'Error';

  @override
  String get reset_password_email_sent => 'Reset password email sent';

  @override
  String get reset_password_email_message => 'We sent to your email password reset link, please check your mail';

  @override
  String get task_details => 'Task Details';

  @override
  String get add_task => 'Add Task';

  @override
  String get add_reminder => 'Add Reminder';

  @override
  String get before_2_minutes => 'Before 2 minutes';

  @override
  String get before_5_minutes => 'Before 5 minutes';

  @override
  String get before_10_minutes => 'Before 10 minutes';

  @override
  String get before_20_minutes => 'Before 20 minutes';

  @override
  String get enter_task_title => 'Enter Task Title';

  @override
  String get enter_task_description => 'Enter Task Description';

  @override
  String get select_task_category => 'Select Task Category';

  @override
  String get select_task_priority => 'Select Task Priority';

  @override
  String get select_start_date_time => 'Select Start Date & Time';

  @override
  String get select_end_date_time => 'Select End Date & Time';

  @override
  String get public_task => 'Public Task';

  @override
  String get attachments => 'Attachments';

  @override
  String images(int count) {
    return '$count images';
  }

  @override
  String get save_task => 'Save Task';

  @override
  String get my_tasks => 'My Tasks';

  @override
  String get public_tasks => 'Public';

  @override
  String get see_all => 'See All';

  @override
  String get no_internet_connection => 'No Internet Connection';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get kph => 'kph';

  @override
  String get delete => 'Delete';

  @override
  String get delete_task => 'Delete Task';

  @override
  String get delete_task_confirmation => 'Are you sure you want to delete this task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get task_deleted => 'Task deleted';

  @override
  String get work => 'Work';

  @override
  String get study => 'Study';

  @override
  String get personal => 'Personal';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get change_theme => 'Change Theme';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get light_mode => 'Light Mode';

  @override
  String get change_language => 'Change Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get settings_and_preferences => 'Settings & Preferences';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get logout_failed => 'Logout failed. Please try again.';

  @override
  String get logout_confirmation => 'Are you sure you want to logout?';

  @override
  String get weather => 'Weather';

  @override
  String get feels_like => 'Feels Like';

  @override
  String get visibility => 'Visibility';

  @override
  String get pressure => 'Pressure';

  @override
  String get cloud => 'Cloud';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get dew_point => 'Dew Point';

  @override
  String get gust => 'Gust';

  @override
  String get uv_index => 'UV Index';

  @override
  String get low_uv => 'Low';

  @override
  String get moderate_uv => 'Moderate';

  @override
  String get high_uv => 'High';

  @override
  String get very_high_uv => 'Very High';

  @override
  String get extreme_uv => 'Extreme';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get weather_details => 'Weather Details';

  @override
  String get current_weather => 'Current Weather';

  @override
  String get temperature => 'Temperature';

  @override
  String get weather_condition => 'Weather Condition';

  @override
  String get additional_info => 'Additional Info';

  @override
  String get weather_error => 'Weather Data Error';

  @override
  String get fetching_weather => 'Fetching weather data...';

  @override
  String get last_updated => 'Last Updated';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get sunset => 'Sunset';

  @override
  String get chance_of_rain => 'Chance of Rain';

  @override
  String get wind_direction => 'Wind Direction';

  @override
  String get air_quality => 'Air Quality';

  @override
  String get good => 'Good';

  @override
  String get moderate => 'Moderate';

  @override
  String get unhealthy => 'Unhealthy';

  @override
  String get hazardous => 'Hazardous';

  @override
  String get weather_forecast => 'Weather Forecast';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get this_week => 'This Week';

  @override
  String get hourly_forecast => 'Hourly Forecast';

  @override
  String get daily_forecast => 'Daily Forecast';

  @override
  String get max_temp => 'Max Temp';

  @override
  String get min_temp => 'Min Temp';

  @override
  String feels_like_temp(String temp) {
    return 'Feels like $temp°C';
  }

  @override
  String weather_in(String city) {
    return 'Weather in $city';
  }

  @override
  String get save_task_failed => 'Failed To Save Task';

  @override
  String tasks_count(int count) {
    return '$count tasks';
  }

  @override
  String completed_count(int count) {
    return '$count completed';
  }

  @override
  String get no_tasks => 'No tasks';

  @override
  String get swipe_to_delete_hint => 'Swipe left on any task to delete it';

  @override
  String get swipe_to_delete_hint_owner => 'Swipe left on your tasks to delete them';

  @override
  String get task_deleted_successfully => 'Task deleted successfully';

  @override
  String get no_tasks_in_category => 'It looks like you don\'t have any tasks in this category yet.';

  @override
  String get create_new_task => 'Create New Task';

  @override
  String get stats => 'Stats';

  @override
  String get task_statistics => 'Task Statistics';

  @override
  String get total_tasks => 'Total Tasks';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get high_priority => 'High Priority';

  @override
  String get completion_progress => 'Completion Progress';

  @override
  String delete_task_confirmation_with_title(String title) {
    return 'Are you sure you want to delete "$title"?';
  }

  @override
  String get weather_data_unavailable => 'Weather data unavailable';

  @override
  String get unknown_location => 'Unknown Location';

  @override
  String get start_by_creating_task => 'Start by creating a new task';

  @override
  String get not_completed => 'Not Completed';

  @override
  String get overview_of_your_tasks => 'Overview of your tasks';

  @override
  String get basic_information => 'Basic Information';

  @override
  String get category_priority => 'Category & Priority';

  @override
  String get date_time => 'Date & Time';

  @override
  String get settings => 'Settings';
}
