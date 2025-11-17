import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Supported languages
  static const locale = Locale('ar', 'SA');
  static const fallbackLocale = Locale('en', 'US');

  // Supported locales
  static final langs = ['English', 'العربية'];

  // Keys and their translations
  static final Map<String, Map<String, String>> translations = {
    'en_US': {
      'hello': 'Hello',
      'product_list': 'Product List',
      'add_product': 'Add Product',
      'new_product': 'New Product',
      'category': 'Category',
      'price': 'Price',
      'stock': 'Stock'
    },
    'ar_SA': {
      'hello': 'مرحبا',
      'product_list': 'قائمة المنتجات',
      'add_product': 'إضافة منتج',
      'new_product': 'منتج جديد',
      'category': 'الفئة',
      'price': 'السعر',
      'stock': 'المخزون'
    }
  };

  @override
  Map<String, Map<String, String>> get keys => translations;

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  Locale? _getLocaleFromLanguage(String lang) {
    switch (lang) {
      case 'English':
        return const Locale('en', 'US');
      case 'العربية':
        return const Locale('ar', 'SA');
      default:
        return Get.locale;
    }
  }

  void showLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Select Language'.tr),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: LocalizationService.langs.map((lang) {
                    return ListTile(
                        title: Text(lang),
                        onTap: () {
                          changeLocale(lang);
                          Get.back();
                        });
                  }).toList()));
        });
  }
}
