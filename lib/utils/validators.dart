class Validators {
  // 1. التحقق من عدم الفراغ
  static String? notEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  // 2. التحقق من البريد الإلكتروني
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  // 3. التحقق من كلمة المرور
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    }
    return null;
  }

  // 4. التحقق من تطابق كلمتي المرور
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    if (value != originalPassword) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  // 5. التحقق من رقم الهاتف
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$'); // يدعم الأرقام الدولية
    if (!phoneRegex.hasMatch(value)) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }

  // 6. التحقق من الأرقام فقط
  static String? numbersOnly(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل يتطلب أرقامًا فقط';
    }
    final numberRegex = RegExp(r'^[0-9]+$');
    if (!numberRegex.hasMatch(value)) {
      return 'يرجى إدخال أرقام فقط';
    }
    return null;
  }

  // 7. التحقق من النصوص فقط (بدون أرقام أو رموز)
  static String? lettersOnly(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل يتطلب نصوصًا فقط';
    }
    final letterRegex =
        RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$'); // يدعم اللغة العربية والإنجليزية
    if (!letterRegex.hasMatch(value)) {
      return 'يرجى إدخال نصوص فقط بدون أرقام أو رموز';
    }
    return null;
  }

  // 8. التحقق من الطول الأدنى
  static String? minLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    if (value.length < minLength) {
      return 'يجب أن يكون $fieldName على الأقل $minLength أحرف';
    }
    return null;
  }

  // 9. التحقق من الطول الأقصى
  static String? maxLength(String? value, int maxLength, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    if (value.length > maxLength) {
      return 'يجب أن لا يتجاوز $fieldName $maxLength أحرف';
    }
    return null;
  }

  // 10. التحقق من القيم الرقمية ضمن نطاق معين
  static String? range(int? value, int min, int max, String fieldName) {
    if (value == null) {
      return '$fieldName مطلوب';
    }
    if (value < min || value > max) {
      return 'يجب أن يكون $fieldName بين $min و $max';
    }
    return null;
  }

  // 11. التحقق من عنوان URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'عنوان الرابط مطلوب';
    }
    final urlRegex = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$');
    if (!urlRegex.hasMatch(value)) {
      return 'يرجى إدخال عنوان رابط صحيح';
    }
    return null;
  }

  // 12. التحقق من تاريخ بصيغة YYYY-MM-DD
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'التاريخ مطلوب';
    }
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return 'يرجى إدخال تاريخ بصيغة YYYY-MM-DD';
    }
    return null;
  }

  // 13. التحقق من الاسم الكامل (على الأقل كلمتين)
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم الكامل مطلوب';
    }
    // إزالة المسافات الزائدة والتأكد من وجود كلمتين على الأقل
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'يجب أن يتكون الاسم الكامل من كلمتين على الأقل';
    }
    // التحقق من أن كل كلمة تحتوي على أحرف فقط
    for (final word in words) {
      if (!RegExp(r'^[a-zA-Z\u0600-\u06FF]+$').hasMatch(word)) {
        return 'يجب أن يحتوي الاسم على أحرف فقط';
      }
    }
    return null;
  }

  // 14. التحقق من رقم الهاتف العراقي (11 رقم)
  static String? iraqiPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    final phoneRegex = RegExp(r'^\d{11}$'); // بالضبط 11 رقم
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'يجب أن يتكون رقم الهاتف من 11 رقم';
    }
    // التحقق من أن الرقم يبدأ بـ 07 (أرقام الهواتف العراقية)
    if (!value.trim().startsWith('07')) {
      return 'يجب أن يبدأ رقم الهاتف العراقي بـ 07';
    }
    return null;
  }
}
