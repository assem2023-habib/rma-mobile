enum SenderType {
  user('User', 'مستخدم مسجل'),
  guestUser('GuestUser', 'ضيف');

  final String value;
  final String label;
  const SenderType(this.value, this.label);

  static SenderType fromString(String value) {
    return SenderType.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => SenderType.user,
    );
  }
}
