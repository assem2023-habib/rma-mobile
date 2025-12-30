# توثيق نظام الإشعارات الحية (Live Notifications) باستخدام Laravel Reverb

يوضح هذا المستند التفاصيل الكاملة لعملية تنفيذ نظام الإشعارات الحية في تطبيق RMA Customer باستخدام Flutter و Laravel Reverb (المتوافق مع بروتوكول Pusher).

## 1. تحليل المتطلبات والبيانات الأولية

قبل البدء في الكود، قمنا بتحليل البيانات التقنية المقدمة:

- **البروتوكول**: `ws` (WebSockets) عبر `pusher_channels_flutter`.
- **الخادم (Host)**: `10.43.226.236` (بيئة تطوير محلية).
- **المنفذ (Port)**: `6001`.
- **مفتاح التطبيق (App Key)**: `z8gmvgvmclvhoezjsfil`.
- **التوثيق (Authentication)**:
  - رابط: `http://10.43.226.236:8000/api/broadcasting/auth`.
  - النوع: قنوات خاصة (`private-User.{userId}`).
  - الهيدرز: `Authorization: Bearer {USER_TOKEN}`.
- **الحدث (Event)**: `Illuminate\Notifications\Events\BroadcastNotificationCreated`.

---

## 2. إعداد التبعيات (Dependencies)

### إضافة المكتبات

تم تعديل ملف `pubspec.yaml` لإضافة مكتبة `pusher_channels_flutter` الرسمية، وهي المكتبة الموصى بها للتعامل مع بروتوكول Pusher/Reverb في Flutter.

```yaml
dependencies:
  # ...
  pusher_channels_flutter: ^2.2.0
```

### تهيئة Android

بما أن السيرفر يعمل على بيئة محلية (`10.43.226.236`) وببروتوكول `http/ws` غير المشفر، يتطلب نظام Android 9+ إذنًا خاصًا للسماح بحركة مرور البيانات غير المشفرة (Cleartext Traffic).

تم تعديل ملف `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="rma_customer"
    android:name="${applicationName}"
    android:usesCleartextTraffic="true"  <!-- هذا السطر تم إضافته -->
    android:icon="@mipmap/ic_launcher">
```

---

## 3. بناء الطبقة البرمجية (Core Services)

تم إنشاء خدمة مخصصة `LiveNotificationService` لتغليف كل ما يتعلق بالاتصال بـ Reverb.

**المسار**: `lib/core/services/live_notification_service.dart`

### أبرز الوظائف في الخدمة:

1.  **التهيئة (Initialization)**:

    - نستخدم `pusher.init` مع تمرير `host` و `port` (أو الاعتماد على الإعدادات الافتراضية مع التعديل إذا لزم الأمر، لكن في التنفيذ اعتمدنا على `init` الشائعة مع معالجات الأحداث).
    - تم تعطيل `useTLS: false` لأن الاتصال محلي وغير مشفر.

2.  **التوثيق المخصص (Custom Authorizer)**:

    - بما أن القنوات "خاصة" (`private-`), يطلب الـ SDK توثيقًا عند محاولة الاشتراك.
    - قمنا بتنفيذ دالة `onAuthorizer` التي تقوم بإرسال طلب `POST` إلى سكريبت التوثيق في الـ Backend.
    - يتم إرسال `socket_id` و `channel_name` مع الـ `Bearer Token` الخاص بالمستخدم.

3.  **الاستماع للأحداث (Event Listening)**:
    - عند استقبال حدث `BroadcastNotificationCreated`، نقوم بفك تشفير بيانات JSON (`jsonDecode`).
    - يتم تمرير البيانات عبر `StreamController` لكي تتمكن أجزاء التطبيق الأخرى من الاستماع لها.

---

## 4. حقن التبعيات (Dependency Injection)

لضمان سهولة الوصول للخدمة وفصل الاعتماديات، قمنا بتسجيل الخدمة في حاوية الحقن `GetIt`.

**الملف**: `lib/injection_container.dart`

```dart
// تسجيل الخدمة كـ LazySingleton
sl.registerLazySingleton(() => LiveNotificationService(sl()));
```

---

## 5. إدارة الحالة (State Management Integration)

لربط الأحداث القادمة من الـ WebSocket بواجهة المستخدم، قمنا بتحديث `NotificationsBloc`.

**1. تحديث الكيان (Entity)**:
تأكدنا من وجود `NotificationEntity` لتمثيل شكل البيانات.

**2. تحديث الأحداث (Events)**:
أضفنا حدثًا جديدًا `NotificationReceivedEvent` في ملف `notifications_event.dart`:

```dart
class NotificationReceivedEvent extends NotificationsEvent {
  final NotificationEntity notification;
  const NotificationReceivedEvent(this.notification);
  // ...
}
```

**3. تحديث الـ Blob (Logic)**:
في ملف `notifications_bloc.dart`، أضفنا معالجًا لهذا الحدث:

```dart
on<NotificationReceivedEvent>(_onNotificationReceived);

Future<void> _onNotificationReceived(event, emit) async {
  if (state is NotificationsLoaded) {
    // إضافة الإشعار الجديد لأعلى القائمة وزيادة العداد
    // ...
  } else {
    // إعادة تحميل الإشعارات إذا لم تكن القائمة محملة
    add(GetNotificationsEvent());
  }
}
```

---

## 6. الربط مع واجهة التطبيق (UI Integration)

هذه خطوة حاسمة. نحتاج لمكان في التطبيق يستمع لـ "حالة تسجيل الدخول" (AuthStatus) ليقرر متى يتصل بـ Reverb ومتى يقطع الاتصال.

لذلك، قمنا بإنشاء ويدجت تغليف (Wrapper Widget).

**المسار**: `lib/core/widgets/live_notification_wrapper.dart`

**وظيفتها**:

1.  **تراقب `AuthBloc`**:
    - إذا أصبح المستخدم `Authenticated` -> تستدعي `service.init(userId)`.
    - إذا أصبح المستخدم `Unauthenticated` (تسجيل خروج) -> تستدعي `service.disconnect()`.
2.  **تراقب `LiveNotificationService`**:
    - تستمع للـ `stream` القادم من الخدمة.
    - عند وصول بيانات، تقوم بتحويلها لـ `NotificationEntity`.
    - ترسل حدث `NotificationReceivedEvent` إلى `NotificationsBloc`.

أخيراً، قمنا بتغليف التطبيق بالكامل بهذا الـ Wrapper في `main.dart`:

```dart
builder: (context, child) {
  return LiveNotificationWrapper(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    ),
  );
},
```

---

## 7. الخلاصة

الآن، دورة حياة الإشعار هي كالتالي:

1.  يفتح المستخدم التطبيق ويسجل الدخول.
2.  يقوم `LiveNotificationWrapper` ببدء اتصال WebSocket مع Reverb.
3.  يتم توثيق القناة الخاصة عبر API.
4.  يرسل السيرفر إشعارًا.
5.  يستقبله `LiveNotificationService` ويمرره للـ Wrapper.
6.  يقوم الـ Wrapper بإرساله للـ `NotificationsBloc`.
7.  يقوم الـ Bloc بتحديث الحالة (State).
8.  تتحدث واجهة المستخدم (زياة عداد الإشعارات، ظهور الإشعار في القائمة).

تم حفظ هذا الملف في مشروعك للرجوع إليه مستقبلاً.
