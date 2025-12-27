enum AuthorizationStatus {
  pending('Pending', 'قيد الانتظار'),
  active('Active', 'نشط'),
  expired('Expired', 'منتهي الصلاحية'),
  used('Used', 'مُستخدم'),
  cancelled('Cancelled', 'ملغى');

  final String value;
  final String label;
  const AuthorizationStatus(this.value, this.label);

  static AuthorizationStatus fromString(String value) {
    return AuthorizationStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => AuthorizationStatus.pending,
    );
  }
}
