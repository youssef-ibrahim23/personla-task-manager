import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Personal Tasks'**
  String get app_title;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logging.
  ///
  /// In en, this message translates to:
  /// **'logging'**
  String get logging;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering'**
  String get registering;

  /// No description provided for @not_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have An Account?'**
  String get not_have_account;

  /// No description provided for @create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get create_your_account;

  /// No description provided for @select_image_source.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get select_image_source;

  /// No description provided for @where_do_you_want_to_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to pick the image from?'**
  String get where_do_you_want_to_pick_image;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @open_mail.
  ///
  /// In en, this message translates to:
  /// **'Open mail'**
  String get open_mail;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get name_required;

  /// No description provided for @phone_number_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number required'**
  String get phone_number_required;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email Is Required'**
  String get email_required;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password Is Required'**
  String get password_required;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid Email'**
  String get please_enter_valid_email;

  /// No description provided for @connection_Error_no_internet.
  ///
  /// In en, this message translates to:
  /// **'Connection Error, No Internet'**
  String get connection_Error_no_internet;

  /// No description provided for @this_user_not_found.
  ///
  /// In en, this message translates to:
  /// **'This user not found'**
  String get this_user_not_found;

  /// No description provided for @email_is_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified'**
  String get email_is_not_verified;

  /// No description provided for @pending_tasks.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending_tasks;

  String get you_can_not_edit_on_task;

  String get week_password;

  /// No description provided for @no_tasks_found.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get no_tasks_found;

  /// No description provided for @add_images.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get add_images;

  /// No description provided for @no_images_selected.
  ///
  /// In en, this message translates to:
  /// **'No Images Selected'**
  String get no_images_selected;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already Have An Account'**
  String get already_have_account;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @passwords_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwords_match;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get login_failed;

  /// No description provided for @register_failed.
  ///
  /// In en, this message translates to:
  /// **'Field To Register'**
  String get register_failed;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong please , try again'**
  String get something_went_wrong;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Register Success'**
  String get register_success;

  /// No description provided for @email_verification_sent.
  ///
  /// In en, this message translates to:
  /// **'We were sent a email verification to your email, check your email'**
  String get email_verification_sent;

  /// No description provided for @password_not_match.
  ///
  /// In en, this message translates to:
  /// **'Password Not Match'**
  String get password_not_match;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @reset_password_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Reset password email sent'**
  String get reset_password_email_sent;

  /// No description provided for @reset_password_email_message.
  ///
  /// In en, this message translates to:
  /// **'We sent to your email password reset link, please check your mail'**
  String get reset_password_email_message;

  /// No description provided for @task_details.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get task_details;

  /// No description provided for @add_task.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get add_task;

  /// No description provided for @add_reminder.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get add_reminder;

  /// No description provided for @before_2_minutes.
  ///
  /// In en, this message translates to:
  /// **'Before 2 minutes'**
  String get before_2_minutes;

  /// No description provided for @before_5_minutes.
  ///
  /// In en, this message translates to:
  /// **'Before 5 minutes'**
  String get before_5_minutes;

  /// No description provided for @before_10_minutes.
  ///
  /// In en, this message translates to:
  /// **'Before 10 minutes'**
  String get before_10_minutes;

  /// No description provided for @before_20_minutes.
  ///
  /// In en, this message translates to:
  /// **'Before 20 minutes'**
  String get before_20_minutes;

  /// No description provided for @enter_task_title.
  ///
  /// In en, this message translates to:
  /// **'Enter Task Title'**
  String get enter_task_title;

  /// No description provided for @enter_task_description.
  ///
  /// In en, this message translates to:
  /// **'Enter Task Description'**
  String get enter_task_description;

  /// No description provided for @select_task_category.
  ///
  /// In en, this message translates to:
  /// **'Select Task Category'**
  String get select_task_category;

  /// No description provided for @select_task_priority.
  ///
  /// In en, this message translates to:
  /// **'Select Task Priority'**
  String get select_task_priority;

  /// No description provided for @select_start_date_time.
  ///
  /// In en, this message translates to:
  /// **'Select Start Date & Time'**
  String get select_start_date_time;

  /// No description provided for @select_end_date_time.
  ///
  /// In en, this message translates to:
  /// **'Select End Date & Time'**
  String get select_end_date_time;

  /// No description provided for @public_task.
  ///
  /// In en, this message translates to:
  /// **'Public Task'**
  String get public_task;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'{count} images'**
  String images(int count);

  /// No description provided for @save_task.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get save_task;

  /// No description provided for @my_tasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get my_tasks;

  /// No description provided for @public_tasks.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public_tasks;

  /// No description provided for @see_all.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet_connection;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @kph.
  ///
  /// In en, this message translates to:
  /// **'kph'**
  String get kph;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @delete_task.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get delete_task;

  /// No description provided for @delete_task_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get delete_task_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @task_deleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get task_deleted;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @change_theme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get change_theme;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settings_and_preferences.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settings_and_preferences;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_failed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed. Please try again.'**
  String get logout_failed;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirmation;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @feels_like.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feels_like;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation;

  /// No description provided for @dew_point.
  ///
  /// In en, this message translates to:
  /// **'Dew Point'**
  String get dew_point;

  /// No description provided for @gust.
  ///
  /// In en, this message translates to:
  /// **'Gust'**
  String get gust;

  /// No description provided for @uv_index.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uv_index;

  /// No description provided for @low_uv.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low_uv;

  /// No description provided for @moderate_uv.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate_uv;

  /// No description provided for @high_uv.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high_uv;

  /// No description provided for @very_high_uv.
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get very_high_uv;

  /// No description provided for @extreme_uv.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get extreme_uv;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @weather_details.
  ///
  /// In en, this message translates to:
  /// **'Weather Details'**
  String get weather_details;

  /// No description provided for @current_weather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get current_weather;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @weather_condition.
  ///
  /// In en, this message translates to:
  /// **'Weather Condition'**
  String get weather_condition;

  /// No description provided for @additional_info.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additional_info;

  /// No description provided for @weather_error.
  ///
  /// In en, this message translates to:
  /// **'Weather Data Error'**
  String get weather_error;

  /// No description provided for @fetching_weather.
  ///
  /// In en, this message translates to:
  /// **'Fetching weather data...'**
  String get fetching_weather;

  /// No description provided for @last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get last_updated;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @chance_of_rain.
  ///
  /// In en, this message translates to:
  /// **'Chance of Rain'**
  String get chance_of_rain;

  /// No description provided for @wind_direction.
  ///
  /// In en, this message translates to:
  /// **'Wind Direction'**
  String get wind_direction;

  /// No description provided for @air_quality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get air_quality;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @unhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get unhealthy;

  /// No description provided for @hazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get hazardous;

  /// No description provided for @weather_forecast.
  ///
  /// In en, this message translates to:
  /// **'Weather Forecast'**
  String get weather_forecast;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get this_week;

  /// No description provided for @hourly_forecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourly_forecast;

  /// No description provided for @daily_forecast.
  ///
  /// In en, this message translates to:
  /// **'Daily Forecast'**
  String get daily_forecast;

  /// No description provided for @max_temp.
  ///
  /// In en, this message translates to:
  /// **'Max Temp'**
  String get max_temp;

  /// No description provided for @min_temp.
  ///
  /// In en, this message translates to:
  /// **'Min Temp'**
  String get min_temp;

  /// No description provided for @feels_like_temp.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}°C'**
  String feels_like_temp(String temp);

  /// No description provided for @weather_in.
  ///
  /// In en, this message translates to:
  /// **'Weather in {city}'**
  String weather_in(String city);

  /// No description provided for @save_task_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed To Save Task'**
  String get save_task_failed;

  /// No description provided for @tasks_count.
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tasks_count(int count);

  /// No description provided for @completed_count.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String completed_count(int count);

  /// No description provided for @no_tasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get no_tasks;

  /// No description provided for @swipe_to_delete_hint.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on any task to delete it'**
  String get swipe_to_delete_hint;

  /// No description provided for @swipe_to_delete_hint_owner.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on your tasks to delete them'**
  String get swipe_to_delete_hint_owner;

  /// No description provided for @task_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get task_deleted_successfully;

  /// No description provided for @no_tasks_in_category.
  ///
  /// In en, this message translates to:
  /// **'It looks like you don't have any tasks in this category yet.'**
  String get no_tasks_in_category;

  /// No description provided for @create_new_task.
  ///
  /// In en, this message translates to:
  /// **'Create New Task'**
  String get create_new_task;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @task_statistics.
  ///
  /// In en, this message translates to:
  /// **'Task Statistics'**
  String get task_statistics;

  /// No description provided for @total_tasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get total_tasks;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @high_priority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get high_priority;

  /// No description provided for @completion_progress.
  ///
  /// In en, this message translates to:
  /// **'Completion Progress'**
  String get completion_progress;

  /// No description provided for @delete_task_confirmation_with_title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete "{title}"?'**
  String delete_task_confirmation_with_title(String title);

  /// No description provided for @weather_data_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather data unavailable'**
  String get weather_data_unavailable;

  /// No description provided for @unknown_location.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknown_location;

  /// No description provided for @start_by_creating_task.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a new task'**
  String get start_by_creating_task;

  /// No description provided for @not_completed.
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get not_completed;

  /// No description provided for @overview_of_your_tasks.
  ///
  /// In en, this message translates to:
  /// **'Overview of your tasks'**
  String get overview_of_your_tasks;

  /// No description provided for @basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_information;

  /// No description provided for @category_priority.
  ///
  /// In en, this message translates to:
  /// **'Category & Priority'**
  String get category_priority;

  /// No description provided for @date_time.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get date_time;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  String get good_morning;

  String get welcome_back;

  String get tasks_completed;

  String get no_tasks_available;

  String get tasks_will_appear_here;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
