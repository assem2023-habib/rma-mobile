enum RatingForType {
  service('Service', 'الخدمة'),
  branch('Branch', 'الفرع'),
  employee('Employee', 'الموظف'),
  parcel('Parcel', 'الطرد'),
  delivery('Delivery', 'التوصيل'),
  application('Application', 'التطبيق'),
  chatSession('ChatSession', 'المحادثة');

  final String value;
  final String label;
  const RatingForType(this.value, this.label);

  static RatingForType fromString(String value) {
    return RatingForType.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => RatingForType.application,
    );
  }
}
