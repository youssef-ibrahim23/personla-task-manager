class Validators {

  static String? validateName(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Name is required';
    }
    if(value.length < 3){
      return 'Name is Very Short';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Phone Number is required';
    }
    if(value.length != 11){
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=(?:.*\d){3,})[A-Za-z\d@$!%*?&]{7,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 7 characters long,\ninclude at least 1 uppercase letter,\nand at least 3 numbers';
    }

    return null;
  }

  static String? validateNotNull(String? value , String action) {
    if (value == null || value.trim().isEmpty) {
      return 'Please $action';
    }
    return null;
  }

  static String? validateStartDateIsBeforeEndDate(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      if (startDate.isAfter(endDate)) {
        return 'Start date must be before end date';
      }
    }
    return null;
  }
}
