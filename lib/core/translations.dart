import 'package:flutter/material.dart';

class AppTranslations {
  static const String appName = 'Shifor';
  
  static final Map<String, Map<String, String>> translations = {
    'ar': {  // Arabic
      'welcome': 'مرحباً',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'jobs': 'وظائف',
      'drivers': 'سائقين',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'search': 'بحث',
      'apply': 'تقديم',
      'save': 'حفظ',
      'cancel': 'إلغاء',
    },
    'en': {  // English
      'welcome': 'Welcome',
      'login': 'Sign In',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'jobs': 'Jobs',
      'drivers': 'Drivers',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'search': 'Search',
      'apply': 'Apply',
      'save': 'Save',
      'cancel': 'Cancel',
    },
    'fr': {  // French
      'welcome': 'Bienvenue',
      'login': 'Connexion',
      'signup': 'Inscription',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'jobs': 'Emplois',
      'drivers': 'Chauffeurs',
      'profile': 'Profil',
      'settings': 'Paramètres',
      'logout': 'Déconnexion',
      'search': 'Rechercher',
      'apply': 'Postuler',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
    },
    'tr': {  // Turkish
      'welcome': 'Hoşgeldiniz',
      'login': 'Giriş Yap',
      'signup': 'Kaydol',
      'email': 'E-posta',
      'password': 'Şifre',
      'jobs': 'İşler',
      'drivers': 'Şoförler',
      'profile': 'Profil',
      'settings': 'Ayarlar',
      'logout': 'Çıkış Yap',
      'search': 'Ara',
      'apply': 'Başvur',
      'save': 'Kaydet',
      'cancel': 'İptal',
    },
  };

  static String get(String key, {String lang = 'en'}) {
    return translations[lang]?[key] ?? translations['en']?[key] ?? key;
  }

  static List<String> get supportedLanguages => ['ar', 'en', 'fr', 'tr'];
  
  static String getLanguageName(String code) {
    switch(code) {
      case 'ar': return 'العربية';
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'tr': return 'Türkçe';
      default: return code;
    }
  }
}