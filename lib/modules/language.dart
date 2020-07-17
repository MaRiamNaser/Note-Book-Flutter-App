class Language {
  int id;
  String flag;
  String name;
  String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇪🇬', 'العربية', 'ar'),
      Language(2, '🇺🇸', 'English', 'en'),
    ];
  }
}
