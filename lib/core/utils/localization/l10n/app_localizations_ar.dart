// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'المهام الشخصية';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logging => 'يتم تسجيل الدخول';

  @override
  String get email => 'البريد الألكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get register => 'تسجيل';

  @override
  String get registering => 'يتم التسجيل';

  @override
  String get not_have_account => 'لا تمتلك حساب؟';

  @override
  String get create_your_account => 'انشئ حسابك';

  @override
  String get select_image_source => 'اختر مصدر الصورة';

  @override
  String get where_do_you_want_to_pick_image => 'من اين انت تريد ان تختار الصورة؟';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get open_mail => 'فتح البريد الالكتروني';

  @override
  String get name_required => 'الاسم مطلوب';

  @override
  String get phone_number_required => 'رقم الهاتف مطلوب';

  @override
  String get week_password => 'الباسورد ضعيف';

  @override
  String get email_required => 'البريد الاكتروني مطلوب';

  @override
  String get password_required => 'الباسورد مطلوب';

  @override
  String get please_enter_valid_email => 'من فضلك ادخل ايميل صالح';

  @override
  String get connection_Error_no_internet => 'خطاء في الاتصال,لا يوجد انترنت';

  @override
  String get this_user_not_found => 'هذا المستخدم غير موجود';

  @override
  String get email_is_not_verified => 'الايميل غير متحقق';

  @override
  String get you_can_not_edit_on_task => 'لا يمكنك التعديل على مهمة ليست لك';
  @override
  String get pending_tasks => 'مهام في انتظار الرفع';

  @override
  String get no_tasks_found => 'لا يوجد مهام';

  @override
  String get add_images => 'اضف صور';

  @override
  String get no_images_selected => 'لا يوجد صور';

  @override
  String get name => 'الاسم';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get already_have_account => '!بالفعل لديك حساب';

  @override
  String get home => 'الرئيسية';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get passwords_match => 'كلمات المرور متطابقة';

  @override
  String get passwords_do_not_match => 'كلمات المرور غير متطابقة';

  @override
  String get login_failed => 'فشل تسجيل الدخول';

  @override
  String get register_failed => 'فشل التسجيل';

  @override
  String get something_went_wrong => 'حدث خطأ ما، يرجى المحاولة مرة أخرى';

  @override
  String get register_success => 'نجح التسجيل';

  @override
  String get email_verification_sent => 'تم إرسال رسالة التحقق إلى بريدك الإلكتروني، يرجى التحقق من بريدك';

  @override
  String get password_not_match => 'كلمة المرور غير متطابقة';

  @override
  String get more => 'المزيد';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get error => 'خطأ';

  @override
  String get reset_password_email_sent => 'تم إرسال بريد إعادة تعيين كلمة المرور';

  @override
  String get reset_password_email_message => 'أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني، يرجى التحقق من بريدك';

  @override
  String get task_details => 'تفاصيل المهمة';

  @override
  String get add_task => 'إضافة مهمة';

  @override
  String get add_reminder => 'إضافة تذكير';

  @override
  String get before_2_minutes => 'قبل دقيقتين';

  @override
  String get before_5_minutes => 'قبل 5 دقائق';

  @override
  String get before_10_minutes => 'قبل 10 دقائق';

  @override
  String get before_20_minutes => 'قبل 20 دقيقة';

  @override
  String get enter_task_title => 'أدخل عنوان المهمة';

  @override
  String get enter_task_description => 'أدخل وصف المهمة';

  @override
  String get select_task_category => 'اختر فئة المهمة';

  @override
  String get select_task_priority => 'اختر أولوية المهمة';

  @override
  String get select_start_date_time => 'اختر تاريخ ووقت البدء';

  @override
  String get select_end_date_time => 'اختر تاريخ ووقت الانتهاء';

  @override
  String get public_task => 'مهمة عامة';

  @override
  String get attachments => 'المرفقات';

  @override
  String images(int count) {
    return '$count صورة';
  }

  @override
  String get save_task => 'حفظ المهمة';

  @override
  String get my_tasks => 'مهامي';

  @override
  String get public_tasks => 'العامة';

  @override
  String get see_all => 'عرض الكل';

  @override
  String get no_internet_connection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get wind => 'الرياح';

  @override
  String get kph => 'كم/ساعة';

  @override
  String get delete => 'حذف';

  @override
  String get delete_task => 'حذف المهمة';

  @override
  String get delete_task_confirmation => 'هل أنت متأكد أنك تريد حذف هذه المهمة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get task_deleted => 'تم حذف المهمة';

  @override
  String get work => 'عمل';

  @override
  String get study => 'دراسة';

  @override
  String get personal => 'شخصي';

  @override
  String get high => 'عالي';

  @override
  String get medium => 'متوسط';

  @override
  String get low => 'منخفض';

  @override
  String get change_theme => 'تغيير المظهر';

  @override
  String get dark_mode => 'الوضع الداكن';

  @override
  String get light_mode => 'الوضع الفاتح';

  @override
  String get change_language => 'تغيير اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get settings_and_preferences => 'الإعدادات والتفضيلات';

  @override
  String get account => 'الحساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logout_failed => 'فشل تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get logout_confirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

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
    return 'الطقس في $city';
  }

  @override
  String get save_task_failed => 'فشل حفظ المهمة';

  @override
  String tasks_count(int count) {
    return '$count مهمة';
  }

  @override
  String completed_count(int count) {
    return '$count مكتملة';
  }

  @override
  String get no_tasks => 'لا توجد مهام';

  @override
  String get swipe_to_delete_hint => 'اسحب يساراً على أي مهمة لحذفها';

  @override
  String get swipe_to_delete_hint_owner => 'اسحب يميناً على مهامك لحذفها';

  @override
  String get task_deleted_successfully => 'تم حذف المهمة بنجاح';

  @override
  String get no_tasks_in_category => 'يبدو أنه ليس لديك أي مهام في هذه الفئة بعد.';

  @override
  String get create_new_task => 'إنشاء مهمة جديدة';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get task_statistics => 'إحصائيات المهام';

  @override
  String get total_tasks => 'إجمالي المهام';

  @override
  String get completed => 'مكتملة';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get high_priority => 'أولوية عالية';

  @override
  String get completion_progress => 'تقدم الإنجاز';

  @override
  String delete_task_confirmation_with_title(String title) {
    return 'هل أنت متأكد أنك تريد حذف "$title"؟';
  }

  @override
  String get weather_data_unavailable => 'بيانات الطقس غير متاحة';

  @override
  String get unknown_location => 'موقع غير معروف';

  @override
  String get start_by_creating_task => 'ابدأ بإنشاء مهمة جديدة';

  @override
  String get not_completed => 'غير مكتملة';

  @override
  String get overview_of_your_tasks => 'نظرة عامة على مهامك';

  @override
  String get basic_information => 'المعلومات الأساسية';

  @override
  String get category_priority => 'الفئة والأولوية';

  @override
  String get date_time => 'التاريخ والوقت';

  @override
  String get settings => 'الإعدادات';

  @override
  // TODO: implement good_morning
  String get good_morning => 'صباح الخير';

  @override
  String get welcome_back => 'مرحباً بعودتك';

  @override
  String get tasks_completed => 'المهام المكتملة';

  @override
  String get no_tasks_available => 'لا توجد مهام متاحة';

  @override
  String get tasks_will_appear_here => 'ستظهر المهام هنا';
}
