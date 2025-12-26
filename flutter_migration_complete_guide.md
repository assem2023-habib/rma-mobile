# دليل الهجرة الشامل - تطبيق شحن سريع (Flutter Migration Guide)

---

# 📋 الفهرس

1. [نظرة عامة على المشروع](#overview)
2. [نظام التصميم](#design-system)
3. [تحليل الشاشات](#screens-analysis)
4. [البنية المعمارية](#architecture)
5. [API Endpoints](#api-endpoints)
6. [الحزم المطلوبة](#dependencies)
7. [الكود المشترك](#shared-code)
8. [شاشات المصادقة](#authentication)
9. [شاشة الملف الشخصي](#profile)
10. [وضع الضيف](#guest-mode)
11. [دليل تكامل الخرائط](#maps-guide)
12. [تفاصيل شاشة المسارات](#routes-detail)
13. [حقن التبعيات (Dependency Injection)](#di)
14. [إدارة الحالة (BLoC Pattern)](#bloc)
15. [التعامل مع الأخطاء والشبكة](#network-errors)
16. [التعريب ودعم RTL](#localization)
17. [التحقق والاختبار](#testing)

---

<a name="overview"></a>

# 1. نظرة عامة على المشروع

## 1.1 وصف المشروع

تطبيق لإدارة الشحنات والطرود يدعم:

- تتبع الطرود
- إدارة المسارات
- التخويلات
- عرض الفروع على الخريطة

## 1.2 الشاشات الرئيسية

| الشاشة       | الاسم بالإنجليزية | الوصف                               |
| ------------ | ----------------- | ----------------------------------- |
| الرئيسية     | DashboardHome     | الإحصائيات والإجراءات السريعة       |
| الطرود       | ParcelsList       | قائمة جميع الطرود مع البحث والفلترة |
| طرد جديد     | NewParcel         | نموذج إنشاء طرد جديد                |
| المسارات     | Routes            | عرض المسارات المتاحة                |
| التخويلات    | Authorizations    | إدارة تخويلات استلام الطرود         |
| الخريطة      | BranchesMap       | عرض الفروع والمسارات على الخريطة    |
| الملف الشخصي | Profile           | ملف المستخدم (قريباً)               |

## 1.3 التنقل

- **Bottom Navigation**: 5 أيقونات (الرئيسية، الطرود، الخريطة، التخويلات، حسابي)
- **اتجاه التطبيق**: RTL (من اليمين لليسار)

---

<a name="design-system"></a>

# 2. نظام التصميم (Design System)

## 2.1 لوحة الألوان (Color Palette)

### الألوان الأساسية (Primary Colors)

```dart
// Blue-Indigo Gradient
primaryBlue = Color(0xFF2563EB)      // blue-600
primaryIndigo = Color(0xFF4F46E5)    // indigo-600
primaryBlueHover = Color(0xFF1D4ED8) // blue-700
primaryIndigoHover = Color(0xFF4338CA) // indigo-700
```

### الألوان الدلالية (Semantic Colors)

```dart
// Success (Green)
success = Color(0xFF22C55E)          // green-500
successLight = Color(0xFFDCFCE7)     // green-100
successDark = Color(0xFF15803D)      // green-700

// Warning (Amber)
warning = Color(0xFFF59E0B)          // amber-500
warningLight = Color(0xFFFEF3C7)     // amber-100
warningDark = Color(0xFFB45309)      // amber-700

// Error (Red)
error = Color(0xFFEF4444)            // red-500
errorLight = Color(0xFFFEE2E2)       // red-100
errorDark = Color(0xFFB91C1C)        // red-700
```

### ألوان محايدة (Neutral - Slate)

```dart
slate50 = Color(0xFFF8FAFC)
slate100 = Color(0xFFF1F5F9)
slate200 = Color(0xFFE2E8F0)
slate300 = Color(0xFFCBD5E1)
slate400 = Color(0xFF94A3B8)
slate500 = Color(0xFF64748B)
slate600 = Color(0xFF475569)
slate700 = Color(0xFF334155)
slate800 = Color(0xFF1E293B)
slate900 = Color(0xFF0F172A)
```

### ألوان الميزات (Feature Colors)

```dart
// Routes Feature (Emerald-Teal)
emerald500 = Color(0xFF10B981)
emerald600 = Color(0xFF059669)
teal600 = Color(0xFF0D9488)
teal700 = Color(0xFF0F766E)

// Authorizations Feature (Purple-Pink)
purple500 = Color(0xFFA855F7)
purple600 = Color(0xFF9333EA)
pink600 = Color(0xFFDB2777)
pink700 = Color(0xFFBE185D)
```

## 2.2 أنماط الخطوط (Typography)

### عائلة الخط

```dart
fontFamily = 'Cairo' // أو 'Tajawal' أو 'Noto Sans Arabic'
```

### أحجام الخطوط

```dart
fontSizeXs = 12.0    // text-xs
fontSizeSm = 14.0    // text-sm
fontSizeBase = 16.0  // text-base
fontSizeLg = 18.0    // text-lg
fontSizeXl = 20.0    // text-xl
fontSize2xl = 24.0   // text-2xl
fontSize3xl = 30.0   // text-3xl
```

### أنماط النصوص

| النمط     | الحجم | الوزن  | الارتفاع |
| --------- | ----- | ------ | -------- |
| heading1  | 24    | w500   | 1.5      |
| heading2  | 20    | w500   | 1.5      |
| heading3  | 18    | w500   | 1.5      |
| bodyLarge | 16    | normal | 1.5      |
| bodySmall | 14    | normal | 1.5      |
| caption   | 12    | normal | 1.5      |
| button    | 16    | w500   | 1.5      |

## 2.3 المقاسات والأبعاد (Spacing & Dimensions)

### المسافات (Spacing)

```dart
spacing1 = 4    // 1 unit
spacing2 = 8    // 2 units
spacing3 = 12   // 3 units
spacing4 = 16   // 4 units
spacing5 = 20   // 5 units
spacing6 = 24   // 6 units
spacing8 = 32   // 8 units
spacing10 = 40  // 10 units
spacing12 = 48  // 12 units
```

### نصف قطر الحدود (Border Radius)

```dart
radiusSm = 6
radiusMd = 8
radiusLg = 10
radiusXl = 12
radius2xl = 16
radiusFull = 9999  // للدوائر
```

### أحجام الأيقونات

```dart
iconXs = 12
iconSm = 16
iconMd = 20
iconLg = 24
iconXl = 32
```

### ارتفاعات العناصر الرئيسية

```dart
bottomNavHeight = 80
appBarHeight = 72
mapHeight = 320
quickActionCardHeight = 96
statsCardHeight = 120

avatarSm = 32
avatarMd = 40
avatarLg = 48
avatarXl = 80
```

---

<a name="screens-analysis"></a>

# 3. تحليل الشاشات بالتفصيل

## 3.1 الشاشة الرئيسية (DashboardHome)

### التخطيط

```
┌─────────────────────────────────────┐
│ [AppBar - Gradient Blue-Indigo]     │
│  Logo + "شحن سريع" + ProfileButton  │
├─────────────────────────────────────┤
│ [Quick Actions - Horizontal Scroll] │
│ ┌──────────┬──────────┬──────────┐  │
│ │ طرد جديد │ الخريطة  │ التخويلات│  │
│ └──────────┴──────────┴──────────┘  │
│                                     │
│ [Stats Grid - 2 columns]            │
│ ┌─────────┐ ┌─────────┐             │
│ │ الطرود  │ │تم التوصيل│            │
│ │ النشطة │ │  48 +8  │             │
│ └─────────┘ └─────────┘             │
│ ┌─────────┐ ┌─────────┐             │
│ │قيد     │ │ التقييم │             │
│ │الانتظار│ │ 4.8 +0.2│             │
│ └─────────┘ └─────────┘             │
│                                     │
│ [Latest Parcel Tracker Card]        │
│                                     │
│ [Recent Parcels List]               │
│                                     │
│ [إرسال طرد جديد Button]             │
├─────────────────────────────────────┤
│ [Bottom Navigation - 5 tabs]        │
└─────────────────────────────────────┘
```

### المكونات

1. **AppBar**

   - Background: `LinearGradient(blue-600, indigo-600)`
   - Height: 72px
   - Padding: 16px horizontal
   - Logo container: 40x40, `bg-white/20`, radius-xl
   - Title: "شحن سريع" white
   - Subtitle: "مرحباً بك" white/80

2. **Quick Actions**

   - Horizontal scroll
   - Card size: 160w x 96h
   - Gap: 12px
   - Each card:
     - Gradient background
     - Icon: 32x32 white
     - Title: white, text-sm
     - Description: white/80, text-xs

3. **Stats Grid**

   - 2 columns
   - Gap: 12px
   - Card: white, shadow-sm, border slate-100, radius-2xl, padding-4
   - Icon container: 40x40
   - Change badge: positive=green, negative=red

4. **Parcel Tracker Card**

   - Background: gradient white → blue-50
   - Border: blue-100
   - Contains ParcelTracker widget

5. **Recent Parcels**
   - Card: white, shadow-sm, radius-2xl, padding-4
   - Each item: bg-slate-50, radius-xl, padding-3

### البيانات المطلوبة

```dart
class DashboardStats {
  final int activeParcels;
  final int deliveredParcels;
  final int pendingParcels;
  final double rating;
}

class QuickAction {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
}
```

---

## 3.2 شاشة الطرود (ParcelsList)

### التخطيط

```
┌─────────────────────────────────────┐
│ [Header Card]                       │
│  📦 جميع الطرود                     │
│  🔍 [Search Input]                  │
│  🔽 [Filter Dropdown]               │
├─────────────────────────────────────┤
│ [Parcels List]                      │
│                                     │
│ ┌───────────────────────────────┐   │
│ │ 📦 PKG-2024-001523 [في الطريق]│   │
│ │ 📍 دمشق ← حلب                 │   │
│ │ ┌──────────┬──────────┐       │   │
│ │ │المستلم   │الوزن     │       │   │
│ │ │أحمد محمد │2.5 كغ    │       │   │
│ │ └──────────┴──────────┘       │   │
│ │ ⏰ الوصول: 2024-12-05         │   │
│ │              [التفاصيل]       │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Empty State]                       │
│        📦                           │
│   لا توجد طرود تطابق البحث          │
└─────────────────────────────────────┘
```

### حالات الطرد

```dart
enum ParcelStatus {
  pending('قيد الانتظار', Colors.amber, Colors.amber.shade100, Icons.clock),
  inTransit('في الطريق', Colors.blue, Colors.blue.shade100, Icons.local_shipping),
  delivered('تم التوصيل', Colors.green, Colors.green.shade100, Icons.check_circle),
  cancelled('ملغي', Colors.red, Colors.red.shade100, Icons.cancel);
}
```

### البيانات

```dart
class Parcel {
  final String id;              // PKG-2024-001523
  final String receiverName;    // أحمد محمد
  final String receiverPhone;   // 0991234567
  final String from;            // دمشق
  final String to;              // حلب
  final double weight;          // 2.5
  final ParcelStatus status;
  final DateTime date;
  final DateTime estimatedArrival;
}
```

---

## 3.3 شاشة طرد جديد (NewParcel)

### التخطيط

```
┌─────────────────────────────────────┐
│ [Header - Gradient Blue-Indigo]     │
│  ✉️ إرسال طرد جديد                  │
│  املأ البيانات أدناه                │
├─────────────────────────────────────┤
│ [Route Selection Card]              │
│ 📍 اختر المسار                      │
│ ○ دمشق ← حلب | الأحد 08:00 صباحاً   │
│ ● دمشق ← اللاذقية | الاثنين 09:00   │
│ ○ حلب ← دمشق | الثلاثاء 07:00       │
│                                     │
│ [Receiver Info Card]                │
│ 👤 معلومات المستلم                  │
│ [اسم المستلم - Input]               │
│ [رقم الهاتف - Input]                │
│ [العنوان - TextArea]                │
│                                     │
│ [Parcel Info Card]                  │
│ 📦 معلومات الطرد                    │
│ [الوزن - Number Input]              │
│ [السعر المتوقع - Display]           │
│ ☑️ تم الدفع مسبقاً                  │
│                                     │
│ [✉️ إرسال الطرد] Button             │
└─────────────────────────────────────┘
```

### حساب السعر

```dart
int calculatePrice(double weight) {
  if (weight <= 1) return 5000;
  if (weight <= 3) return 8000;
  if (weight <= 5) return 12000;
  return 15000;
}
```

### بيانات النموذج

```dart
class CreateParcelRequest {
  final int routeId;
  final String receiverName;
  final String receiverPhone;
  final String receiverAddress;
  final double weight;
  final bool isPaid;
}
```

---

## 3.4 شاشة المسارات (Routes)

### التخطيط

```
┌─────────────────────────────────────┐
│ [Header - Gradient Emerald-Teal]    │
│  📍 المسارات المتاحة                │
├─────────────────────────────────────┤
│ [Days Filter - Horizontal Scroll]   │
│ [الكل][الأحد][الاثنين][الثلاثاء]... │
│                                     │
│ [Routes List]                       │
│ ┌───────────────────────────────┐   │
│ │ 🚚 دمشق → حلب        [متاح]   │   │
│ │ 📅 الأحد                      │   │
│ │ ┌───────┬───────┐             │   │
│ │ │المغادرة│الوصول │             │   │
│ │ │08:00  │12:00  │             │   │
│ │ └───────┴───────┘             │   │
│ │ ┌───────┬───────┐             │   │
│ │ │المسافة│السعر/كغ│             │   │
│ │ │350 كم │2,000   │             │   │
│ │ └───────┴───────┘             │   │
│ │ [اختر هذا المسار] Button      │   │
│ └───────────────────────────────┘   │
└─────────────────────────────────────┘
```

### البيانات

```dart
class Route {
  final int id;
  final String from;
  final int fromBranchId;
  final String to;
  final int toBranchId;
  final String day;           // الأحد، الاثنين...
  final String departureTime; // 08:00 صباحاً
  final String arrivalTime;   // 12:00 ظهراً
  final int distance;         // 350 كم
  final int pricePerKg;       // 2000 ل.س
  final bool available;
}
```

### الأيام

```dart
final List<String> days = [
  'all', // الكل
  'الأحد',
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
];
```

---

## 3.5 شاشة التخويلات (Authorizations)

### التخطيط

```
┌─────────────────────────────────────┐
│ [Header - Gradient Purple-Pink]     │
│  🛡️ التخويلات               [➕]   │
├─────────────────────────────────────┤
│ [New Authorization Form - Toggle]   │
│ ┌───────────────────────────────┐   │
│ │ [رقم الطرد - Dropdown]        │   │
│ │ [اسم المخوّل - Input]         │   │
│ │ [رقم الهاتف - Input]          │   │
│ │ [إنشاء التخويل][إلغاء]        │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Authorizations List]               │
│ ┌───────────────────────────────┐   │
│ │ 🛡️ تخويل #1           [نشط]  │   │
│ │ 📦 PKG-2024-001523            │   │
│ │ 👤 المخوّل: محمد أحمد          │   │
│ │ ┌───────────┬─────────────┐   │   │
│ │ │تاريخ الإنشاء│الاستخدام   │   │   │
│ │ │2024-12-01 │لم يستخدم   │   │   │
│ │ └───────────┴─────────────┘   │   │
│ │ [تأكيد الاستخدام][إلغاء]     │   │
│ └───────────────────────────────┘   │
└─────────────────────────────────────┘
```

### حالات التخويل

```dart
enum AuthorizationStatus {
  active('نشط', Colors.green, Colors.green.shade100, Icons.check_circle),
  used('مستخدم', Colors.blue, Colors.blue.shade100, Icons.check_circle),
  cancelled('ملغي', Colors.red, Colors.red.shade100, Icons.cancel);
}
```

### البيانات

```dart
class Authorization {
  final int id;
  final String parcelId;
  final String authorizedUser;
  final String authorizedPhone;
  final DateTime createdAt;
  final DateTime? usedAt;
  final AuthorizationStatus status;
  final String? cancellationReason;
}
```

---

## 3.6 شاشة الخريطة (BranchesMap)

### التخطيط

```
┌─────────────────────────────────────┐
│ [View Mode Toggle]                  │
│ ┌───────────┬───────────┐           │
│ │ 🏢 الفروع  │ 🧭 المسارات│          │
│ └───────────┴───────────┘           │
├─────────────────────────────────────┤
│ [Map Container - 320px height]      │
│ ┌───────────────────────────────┐   │
│ │      📍     📍                │   │
│ │   📍          📍   📍         │   │
│ │ [Legend: 5 فرع]               │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Selected Branch Details]           │
│ ┌───────────────────────────────┐   │
│ │ 🏢 فرع دمشق الرئيسي           │   │
│ │ 📍 ساحة المحافظة              │   │
│ │ ┌───────────┬─────────────┐   │   │
│ │ │📞 الهاتف  │⏰ ساعات العمل│   │   │
│ │ └───────────┴─────────────┘   │   │
│ │ [الحصول على الاتجاهات]        │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Branches List]                     │
└─────────────────────────────────────┘
```

### البيانات

```dart
class Branch {
  final int id;
  final String name;          // فرع دمشق الرئيسي
  final String city;          // دمشق
  final String address;       // ساحة المحافظة - شارع بغداد
  final String phone;         // 011-2234567
  final double lat;           // 33.5138
  final double lng;           // 36.2765
  final String workingHours;  // 8:00 ص - 8:00 م
}

class RouteData {
  final int id;
  final Branch fromBranch;
  final Branch toBranch;
  final String day;
  final String time;
}
```

### الفروع الافتراضية

```dart
final branches = [
  Branch(id: 1, name: 'فرع دمشق الرئيسي', city: 'دمشق', lat: 33.5138, lng: 36.2765, ...),
  Branch(id: 2, name: 'فرع حلب', city: 'حلب', lat: 36.2021, lng: 37.1343, ...),
  Branch(id: 3, name: 'فرع اللاذقية', city: 'اللاذقية', lat: 35.5355, lng: 35.7878, ...),
  Branch(id: 4, name: 'فرع حمص', city: 'حمص', lat: 34.7333, lng: 36.7167, ...),
  Branch(id: 5, name: 'فرع طرطوس', city: 'طرطوس', lat: 34.8899, lng: 35.8869, ...),
];
```

---

## 3.7 مكون تتبع الطرد (ParcelTracker)

### التخطيط

```
┌───────────────────────────────────────┐
│ [Parcel Info Card]                    │
│ رقم التتبع: PKG-2024-001523           │
│ ┌──────────┬──────────┐               │
│ │المرسل إليه│الوزن     │               │
│ │ أحمد محمد │ 2.5 كغ   │               │
│ └──────────┴──────────┘               │
│ ┌──────────┬──────────┐               │
│ │من        │إلى       │               │
│ │ دمشق     │ حلب      │               │
│ └──────────┴──────────┘               │
│                                       │
│ [Progress Bar] ████████░░░░ 60%       │
│                                       │
│ [Tracking Steps]                      │
│ ● تم الاستلام - دمشق         10:30 AM │
│ │                                     │
│ ◉ في الطريق - حمص (الموقع الحالي)     │
│ │                                     │
│ ○ الوجهة - حلب               متوقع    │
│                                       │
│ [Estimated Arrival Card - Gradient]   │
│ ⏰ الوصول المتوقع                     │
│ 2024-12-05                            │
└───────────────────────────────────────┘
```

### بيانات التتبع

```dart
class TrackingStep {
  final String title;
  final String location;
  final TrackingStatus status;  // completed, current, pending
  final IconData icon;
  final String time;
}
```

---

## 3.8 مكون بطاقة الإحصائيات (StatsCard)

### التخطيط

```
┌─────────────────────────────┐
│ [Icon Container]  [Change]  │
│     📦              +3      │
│                             │
│ الطرود النشطة               │
│ 12                          │
└─────────────────────────────┘
```

### البيانات

```dart
class StatsCardData {
  final String title;
  final String value;
  final String change;        // +3 أو -2
  final IconData icon;
  final List<Color> gradient; // for icon background
  final Color bgColor;        // light background
  final Color textColor;      // value color
}
```

---

<a name="architecture"></a>

# 4. البنية المعمارية (Clean Architecture)

## 4.1 هيكل المجلدات

```
lib/
├── main.dart
├── injection_container.dart
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── route_names.dart
│   │
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   └── network_info.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_dimensions.dart
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   ├── date_formatter.dart
│   │   ├── price_formatter.dart
│   │   └── validators.dart
│   │
│   └── widgets/
│       ├── app_bar/
│       ├── bottom_nav/
│       ├── buttons/
│       ├── cards/
│       ├── inputs/
│       ├── badges/
│       ├── loading/
│       └── empty_state/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── parcels/
│   ├── routes/
│   ├── authorizations/
│   └── branches/
```

## 4.2 بنية كل Feature

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_local_datasource.dart
│   │   └── feature_remote_datasource.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       └── get_feature_usecase.dart
│
└── presentation/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

---

<a name="api-endpoints"></a>

# 5. API Endpoints

```dart
class ApiConstants {
  static const String baseUrl = 'https://api.shippingapp.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Dashboard
  static const String dashboardStats = '/dashboard/stats';
  static const String recentParcels = '/dashboard/recent-parcels';

  // Parcels
  static const String parcels = '/parcels';
  static String parcelDetails(String id) => '/parcels/$id';
  static String trackParcel(String id) => '/parcels/$id/track';
  static const String createParcel = '/parcels';

  // Routes
  static const String routes = '/routes';
  static String routesByDay(String day) => '/routes?day=$day';

  // Authorizations
  static const String authorizations = '/authorizations';
  static String authorizationDetails(String id) => '/authorizations/$id';
  static String useAuthorization(String id) => '/authorizations/$id/use';
  static String cancelAuthorization(String id) => '/authorizations/$id/cancel';

  // Branches
  static const String branches = '/branches';
  static String branchDetails(int id) => '/branches/$id';
}
```

---

<a name="dependencies"></a>

# 6. الحزم المطلوبة (Dependencies)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2

  # Networking
  dio: ^5.4.0
  retrofit: ^4.0.3

  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

  # Navigation
  go_router: ^13.0.1

  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0

  # Maps
  flutter_map: ^6.1.0
  latlong2: ^0.9.0

  # Forms
  reactive_forms: ^16.1.1

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

  # Icons
  lucide_icons: ^0.257.0

  # Utilities
  dartz: ^0.10.1
  internet_connection_checker: ^1.0.0+1

dev_dependencies:
  build_runner: ^2.4.7
  injectable_generator: ^2.4.1
  retrofit_generator: ^8.0.6
  json_serializable: ^6.7.1
  bloc_test: ^9.1.5
  mockito: ^5.4.4
  flutter_lints: ^3.0.1
```

---

<a name="shared-code"></a>

# 7. الكود المشترك (Shared Code)

## 7.1 Widget مشتركة

### GradientButton

```dart
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> gradient;
  final IconData? icon;

  // Default gradient: blue-600 to indigo-600
  // Height: 48-56px
  // Border radius: 12px
  // Shadow: shadow-lg shadow-blue-500/30
  // Active: scale-95
}
```

### StatusBadge

```dart
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  // Padding: 8h x 4v
  // Border radius: 8px (rounded-lg)
  // Text size: 12px
}
```

### CustomTextField

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool required;
  final String? Function(String?)? validator;

  // Background: slate-50
  // Border: slate-200
  // Border radius: 12px
  // Focus: ring-2 blue-500
  // Padding: 12px vertical, icon + 12px horizontal
}
```

### InfoCard

```dart
class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;

  // Background: white
  // Border: slate-100 (or custom)
  // Shadow: shadow-sm
  // Border radius: 16px
  // Padding: 16px default
}
```

### StatsCard

```dart
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  // Card: white, shadow-sm, border slate-100, radius-2xl
  // Icon container: 40x40, center
  // Change badge: green for positive, red for negative
}
```

## 7.2 ملف التنسيق الرئيسي

```dart
// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    scaffoldBackgroundColor: AppColors.slate50,

    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryIndigo,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.slate100),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.slate50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slate200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slate200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
    ),
  );
}
```

## 7.3 إعداد RTL

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شحن سريع',
      theme: AppTheme.lightTheme,

      // RTL Support
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Force RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      home: const MainScreen(),
    );
  }
}
```

---

<a name="auth-screens"></a>

# 8. شاشات المصادقة (Authentication Screens)

## 8.1 شاشة تسجيل الدخول (Login Screen)

### التخطيط

```
┌─────────────────────────────────────┐
│                                     │
│ [App Logo Container - Gradient]     │
│        📦                           │
│    شحن سريع                         │
│    خدمة شحن سريعة وموثوقة            │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ [Login Form Card]                   │
│ ┌───────────────────────────────┐   │
│ │ 🔐 تسجيل الدخول                │   │
│ │                               │   │
│ │ 📧 [البريد الإلكتروني - Input] │   │
│ │                               │   │
│ │ 🔒 [كلمة المرور - Input]       │   │
│ │    [👁 إظهار/إخفاء]           │   │
│ │                               │   │
│ │ ☑️ تذكرني   [نسيت كلمة المرور؟]│   │
│ │                               │   │
│ │ [🔐 تسجيل الدخول] Button      │   │
│ │                               │   │
│ │ ──────── أو ────────         │   │
│ │                               │   │
│ │ [G Google] [f Facebook]      │   │
│ │                               │   │
│ │ ليس لديك حساب؟ [إنشاء حساب]   │   │
│ └───────────────────────────────┘   │
│                                     │
│ [الدخول كضيف] Link                  │
│                                     │
└─────────────────────────────────────┘
```

### المكونات

1. **Header Section**

   - Background: `LinearGradient(blue-600, indigo-600)`
   - Height: ~200px
   - Logo: 80x80, white icon container
   - App Name: white, text-2xl, font-bold
   - Tagline: white/80, text-sm

2. **Login Form Card**

   - Background: white
   - Border Radius: 24px (top corners)
   - Shadow: shadow-xl
   - Padding: 24px
   - Position: overlapping header by ~20px

3. **Input Fields**

   - Email Input:
     - Prefix Icon: Mail (slate-400)
     - Hint: "example@email.com"
     - Keyboard Type: emailAddress
     - Validation: email format
   - Password Input:
     - Prefix Icon: Lock (slate-400)
     - Suffix Icon: Eye/EyeOff toggle
     - Obscure Text: true (toggleable)
     - Validation: min 6 characters

4. **Remember Me & Forgot Password Row**

   - Checkbox + Label: "تذكرني"
   - TextButton: "نسيت كلمة المرور؟" (blue-600)

5. **Login Button**

   - Type: GradientButton
   - Gradient: blue-600 → indigo-600
   - Height: 56px
   - Border Radius: 16px
   - Shadow: shadow-lg shadow-blue-500/30
   - Loading State: CircularProgressIndicator

6. **Social Login Section**

   - Divider with "أو" text
   - Google Button: white bg, border, Google icon
   - Facebook Button: blue-600 bg, Facebook icon
   - Width: equal split or 48px icons

7. **Create Account Link**

   - Text: "ليس لديك حساب؟"
   - TextButton: "إنشاء حساب" (blue-600, underlined)

8. **Guest Mode Link**
   - TextButton: "الدخول كضيف" (slate-500)
   - Icon: UserX or User with arrow

### البيانات والنماذج

```dart
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;
}

// Form Validation
class LoginFormValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }
}
```

### حالات الشاشة (States)

```dart
abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final UserEntity user;
}
class LoginFailure extends LoginState {
  final String message;
}
```

---

## 8.2 شاشة إنشاء حساب (Registration Screen)

### التخطيط

```
┌─────────────────────────────────────┐
│ [← رجوع]                            │
│                                     │
│ [App Logo - Small]                  │
│    إنشاء حساب جديد                  │
│    انضم إلى شحن سريع                 │
│                                     │
├─────────────────────────────────────┤
│ [Registration Form - Scrollable]    │
│                                     │
│ [Step Indicator: ●──○──○]           │
│                                     │
│ ═══ الخطوة 1: المعلومات الشخصية ═══ │
│                                     │
│ 👤 [الاسم الكامل - Input]            │
│                                     │
│ 📱 [رقم الهاتف - Input]             │
│    [🇸🇾 +963] Prefix               │
│                                     │
│ 📧 [البريد الإلكتروني - Input]       │
│                                     │
│ ═══ الخطوة 2: كلمة المرور ═══════   │
│                                     │
│ 🔒 [كلمة المرور - Input]            │
│                                     │
│ 🔒 [تأكيد كلمة المرور - Input]       │
│                                     │
│ [Password Strength Indicator]       │
│ ████░░░░ قوية                       │
│                                     │
│ ═══ الخطوة 3: العنوان ═══════════   │
│                                     │
│ 📍 [المدينة - Dropdown]             │
│                                     │
│ 📍 [العنوان التفصيلي - TextArea]    │
│                                     │
│ ☑️ أوافق على [الشروط والأحكام]       │
│                                     │
│ [📝 إنشاء الحساب] Button            │
│                                     │
│ لديك حساب؟ [تسجيل الدخول]            │
│                                     │
└─────────────────────────────────────┘
```

### المكونات

1. **Back Button**

   - Position: top-left (RTL: top-right)
   - Icon: ArrowRight (for RTL)
   - Color: slate-600

2. **Step Indicator**

   - 3 steps: معلومات شخصية، كلمة المرور، العنوان
   - Active: gradient circle
   - Completed: check mark
   - Inactive: gray circle
   - Connecting lines between steps

3. **Form Sections**

   - Section Header: slate-500, text-sm, with divider lines
   - Grouped logically for better UX

4. **Phone Input**

   - Country Code Picker: +963 (Syria)
   - Flag Emoji or Country Icon
   - Number Only Keyboard
   - Format: XXX XXX XXXX

5. **Password Strength Indicator**

   ```dart
   enum PasswordStrength {
     weak('ضعيفة', Colors.red, 0.25),
     fair('متوسطة', Colors.orange, 0.5),
     good('جيدة', Colors.lightGreen, 0.75),
     strong('قوية', Colors.green, 1.0);
   }
   ```

6. **City Dropdown**

   - Options: دمشق، حلب، اللاذقية، حمص، طرطوس، حماة، دير الزور...
   - With search functionality

7. **Terms Checkbox**
   - Link to terms page
   - Required validation

### البيانات والنماذج

```dart
class RegisterRequest {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String city;
  final String address;
}

class RegisterResponse {
  final String message;
  final bool requiresVerification;
  final String? verificationToken;
}

// Validation
class RegisterFormValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الاسم مطلوب';
    }
    if (value.length < 3) {
      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!RegExp(r'^(09|9)\d{8}$').hasMatch(value)) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  static String? validatePasswordConfirmation(String? password, String? confirmation) {
    if (password != confirmation) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }
}
```

---

## 8.3 شاشة نسيت كلمة المرور (Forgot Password)

### التخطيط

```
┌─────────────────────────────────────┐
│ [← رجوع]                            │
│                                     │
│ [🔐 Icon - Large, Gradient BG]      │
│                                     │
│ نسيت كلمة المرور؟                    │
│ لا تقلق! أدخل بريدك الإلكتروني      │
│ وسنرسل لك رابط إعادة التعيين        │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ 📧 [البريد الإلكتروني - Input]       │
│                                     │
│ [📧 إرسال رابط التعيين] Button      │
│                                     │
│ ──────────────────────────          │
│                                     │
│ تذكرت كلمة المرور؟                   │
│ [تسجيل الدخول] Link                 │
│                                     │
└─────────────────────────────────────┘
```

### شاشة التحقق من OTP

```
┌─────────────────────────────────────┐
│ [← رجوع]                            │
│                                     │
│ [✉️ Icon - Animated]                │
│                                     │
│ تحقق من بريدك الإلكتروني            │
│ أرسلنا رمز التحقق إلى               │
│ user@example.com                    │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ [OTP Input - 6 boxes]               │
│ ┌───┬───┬───┬───┬───┬───┐          │
│ │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │          │
│ └───┴───┴───┴───┴───┴───┘          │
│                                     │
│ ⏱️ إعادة الإرسال خلال 0:45          │
│                                     │
│ [✓ تأكيد] Button                   │
│                                     │
│ [إعادة إرسال الرمز] TextButton      │
│                                     │
└─────────────────────────────────────┘
```

---

<a name="profile-screen"></a>

# 9. شاشة الملف الشخصي (Profile Screen)

## 9.1 التخطيط الرئيسي

```
┌─────────────────────────────────────┐
│ [Profile Header - Gradient]         │
│ ┌─────────────────────────────────┐ │
│ │  [Avatar - 80x80]    [⚙️ Edit]  │ │
│ │     👤                          │ │
│ │   أحمد محمد                     │ │
│ │   ahmad@email.com               │ │
│ │   📱 0991234567                 │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│                                     │
│ [Account Stats Card]                │
│ ┌─────────┬─────────┬─────────┐    │
│ │الطرود   │التخويلات│التقييم  │    │
│ │   12    │   5     │  4.8⭐  │    │
│ └─────────┴─────────┴─────────┘    │
│                                     │
│ [Menu Items List]                   │
│ ┌───────────────────────────────┐   │
│ │ 👤 معلومات الحساب         →   │   │
│ ├───────────────────────────────┤   │
│ │ 📍 عناويني المحفوظة       →   │   │
│ ├───────────────────────────────┤   │
│ │ 🔔 الإشعارات              →   │   │
│ ├───────────────────────────────┤   │
│ │ 🌙 الوضع الليلي           🔘  │   │
│ ├───────────────────────────────┤   │
│ │ 🌐 اللغة                  →   │   │
│ ├───────────────────────────────┤   │
│ │ 📞 تواصل معنا             →   │   │
│ ├───────────────────────────────┤   │
│ │ 📄 الشروط والأحكام        →   │   │
│ ├───────────────────────────────┤   │
│ │ ℹ️ حول التطبيق            →   │   │
│ └───────────────────────────────┘   │
│                                     │
│ [🚪 تسجيل الخروج] Button           │
│                                     │
│ الإصدار 1.0.0                        │
│                                     │
└─────────────────────────────────────┘
```

### المكونات

1. **Profile Header**

   - Background: `LinearGradient(blue-600, indigo-600)`
   - Height: ~180px
   - Avatar Container: 80x80, white border (4px)
   - Edit Button: top-right, bg-white/20, rounded-full
   - Camera Icon for changing photo

2. **Avatar**

   - Default: Gradient background with User icon
   - With Photo: CachedNetworkImage, circular
   - Edit Overlay: Camera icon on tap

3. **Account Stats Card**

   - 3 columns
   - Each with value + label
   - Dividers between columns
   - Background: white
   - Shadow: shadow-md
   - Position: overlapping header

4. **Menu Items**

   - ListTile style
   - Leading Icon: colored background circle
   - Title: slate-900
   - Trailing: ChevronLeft (RTL) or Switch
   - Separator: slate-100 divider

5. **Logout Button**
   - Background: red-50
   - Text: red-600
   - Icon: LogOut
   - Full width
   - Border: red-200

### البيانات

```dart
class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String city;
  final String address;
  final DateTime createdAt;
  final int totalParcels;
  final int totalAuthorizations;
  final double rating;
}

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
}

final List<ProfileMenuItem> menuItems = [
  ProfileMenuItem(
    title: 'معلومات الحساب',
    icon: Icons.person_outline,
    iconBgColor: Colors.blue.shade50,
    iconColor: Colors.blue.shade600,
    onTap: () => navigateToAccountInfo(),
  ),
  ProfileMenuItem(
    title: 'عناويني المحفوظة',
    icon: Icons.location_on_outlined,
    iconBgColor: Colors.green.shade50,
    iconColor: Colors.green.shade600,
    onTap: () => navigateToSavedAddresses(),
  ),
  ProfileMenuItem(
    title: 'الإشعارات',
    icon: Icons.notifications_outlined,
    iconBgColor: Colors.orange.shade50,
    iconColor: Colors.orange.shade600,
    trailing: Switch(value: true),
  ),
  ProfileMenuItem(
    title: 'الوضع الليلي',
    icon: Icons.dark_mode_outlined,
    iconBgColor: Colors.purple.shade50,
    iconColor: Colors.purple.shade600,
    trailing: Switch(value: false),
  ),
  // ... more items
];
```

---

## 9.2 شاشة تعديل الملف الشخصي (Edit Profile)

### التخطيط

```
┌─────────────────────────────────────┐
│ [← حفظ]            تعديل الملف الشخصي│
├─────────────────────────────────────┤
│                                     │
│ [Avatar with Edit Overlay]          │
│         👤                          │
│        📷                           │
│   تغيير الصورة                       │
│                                     │
│ [Form Fields]                       │
│                                     │
│ 👤 [الاسم الكامل]                    │
│    أحمد محمد                        │
│                                     │
│ 📧 [البريد الإلكتروني] (غير قابل للتعديل) │
│    ahmad@email.com ✓                │
│                                     │
│ 📱 [رقم الهاتف]                     │
│    0991234567                       │
│                                     │
│ 📍 [المدينة]                        │
│    دمشق ▼                           │
│                                     │
│ 📍 [العنوان التفصيلي]                │
│    ساحة المحافظة - شارع بغداد        │
│                                     │
│ [🔑 تغيير كلمة المرور] Button       │
│                                     │
│ [💾 حفظ التغييرات] Button           │
│                                     │
└─────────────────────────────────────┘
```

---

<a name="guest-mode"></a>

# 10. وضع الضيف (Guest Mode)

## 10.1 نظرة عامة

وضع الضيف يسمح للمستخدمين باستكشاف التطبيق بدون إنشاء حساب.

### الميزات المتاحة للضيف

| الميزة                 | متاح؟ | ملاحظات         |
| ---------------------- | ----- | --------------- |
| عرض الشاشة الرئيسية    | ✅    | بيانات عامة فقط |
| عرض المسارات           | ✅    | جميع المسارات   |
| عرض الفروع على الخريطة | ✅    | كامل            |
| تتبع طرد برقمه         | ✅    | إدخال رقم يدوي  |
| إرسال طرد جديد         | ❌    | يتطلب تسجيل     |
| عرض طرودي              | ❌    | يتطلب تسجيل     |
| إنشاء تخويل            | ❌    | يتطلب تسجيل     |
| الملف الشخصي           | ❌    | يتطلب تسجيل     |

### التخطيط - الشاشة الرئيسية للضيف

```
┌─────────────────────────────────────┐
│ [AppBar - Same Design]              │
│  شحن سريع         [تسجيل الدخول]    │
├─────────────────────────────────────┤
│                                     │
│ [Welcome Banner - Guest]            │
│ ┌───────────────────────────────┐   │
│ │ 👋 مرحباً بك!                  │   │
│ │ سجّل دخولك للاستفادة من       │   │
│ │ جميع مميزات التطبيق           │   │
│ │                               │   │
│ │ [إنشاء حساب] [تسجيل الدخول]   │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Track Parcel Card]                 │
│ ┌───────────────────────────────┐   │
│ │ 🔍 تتبع طرد                   │   │
│ │ [أدخل رقم الطرد للتتبع]        │   │
│ │ [تتبع الآن] Button            │   │
│ └───────────────────────────────┘   │
│                                     │
│ [Quick Links]                       │
│ ┌──────────┬──────────┐            │
│ │ 📍 الفروع │ 🛣️ المسارات│          │
│ └──────────┴──────────┘            │
│                                     │
│ [Features Showcase]                 │
│ ┌───────────────────────────────┐   │
│ │ 🚀 لماذا شحن سريع؟            │   │
│ │                               │   │
│ │ ✓ توصيل سريع وآمن             │   │
│ │ ✓ تغطية واسعة                 │   │
│ │ ✓ أسعار منافسة                │   │
│ │ ✓ تتبع مباشر                  │   │
│ └───────────────────────────────┘   │
│                                     │
├─────────────────────────────────────┤
│ [Bottom Nav - Limited]              │
│ [الرئيسية][الخريطة][المسارات][دخول] │
└─────────────────────────────────────┘
```

### البنية البرمجية

```dart
// Auth State Management
enum AuthStatus {
  authenticated,
  guest,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final bool isGuest;

  bool get canAccess => status == AuthStatus.authenticated;
}

// Navigation Guard
class AuthGuard {
  static bool canAccess(String route, AuthStatus status) {
    final guestAllowedRoutes = [
      '/home',
      '/map',
      '/routes',
      '/track-parcel',
      '/branches',
    ];

    final authRequiredRoutes = [
      '/parcels',
      '/new-parcel',
      '/authorizations',
      '/profile',
    ];

    if (status == AuthStatus.guest) {
      return guestAllowedRoutes.contains(route);
    }
    return true;
  }
}

// Guest Prompt Widget
class GuestPromptBottomSheet extends StatelessWidget {
  final String feature; // "إرسال الطرود" / "التخويلات"

  // Shows when guest tries to access restricted feature
  // UI:
  // - Icon with lock
  // - Title: "سجّل دخولك للمتابعة"
  // - Description: "يجب تسجيل الدخول لـ {feature}"
  // - Buttons: [إنشاء حساب] [تسجيل الدخول]
}
```

### تخزين حالة الضيف

```dart
class GuestSessionManager {
  // Store guest preferences locally
  Future<void> saveGuestPreference(String key, dynamic value);

  // Track last viewed parcels (by tracking number)
  Future<void> addTrackedParcel(String trackingNumber);
  Future<List<String>> getTrackedParcels();

  // Clear on logout or account creation
  Future<void> clearGuestData();
}
```

---

<a name="maps-integration"></a>

# 11. دليل تكامل الخرائط (Maps Integration Guide)

## 11.1 نظرة عامة

يستخدم التطبيق الخرائط لعرض مواقع الفروع والمسارات.

### الحزم المطلوبة

```yaml
dependencies:
  # Flutter Map (OpenStreetMap - مجاني)
  flutter_map: ^6.1.0
  latlong2: ^0.9.0

  # OR Google Maps (يتطلب API Key)
  google_maps_flutter: ^2.5.0

  # Geocoding & Location
  geolocator: ^11.0.0
  geocoding: ^2.1.1

  # Map Utilities
  flutter_map_marker_cluster: ^1.2.0
  flutter_map_line_editor: ^5.0.0
```

## 11.2 إعداد Flutter Map (OpenStreetMap)

### ملاحظة هامة حول المكتبات (Important Note)

عند استخدام `flutter_map` مع `latlong2` في الإصدارات الحديثة، يجب الانتباه لمسار الاستيراد:
```dart
// الاستيراد الصحيح
import 'package:latlong2/latlong.dart'; 

// بدلاً من الاستيراد القديم الذي قد يسبب أخطاء في التعرف على LatLng
import 'package:latlong2/latlong2.dart'; 
```

### الإعداد الأساسي

```dart
// lib/core/config/map_config.dart

class MapConfig {
  // Default center: Syria
  static const defaultCenter = LatLng(35.0, 38.0);
  static const defaultZoom = 6.5;

  // Bounds for Syria
  static const syriaBounds = LatLngBounds(
    LatLng(32.3, 35.7), // SW
    LatLng(37.3, 42.4), // NE
  );

  // Tile providers
  static const String osmTileUrl =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Custom styled tiles (optional)
  static const String cartoDarkUrl =
    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
  static const String cartoLightUrl =
    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png';
}
```

### Widget الخريطة

```dart
// lib/features/branches/presentation/widgets/branches_map_widget.dart

class BranchesMapWidget extends StatefulWidget {
  final List<Branch> branches;
  final Branch? selectedBranch;
  final Function(Branch)? onBranchTap;

  @override
  State<BranchesMapWidget> createState() => _BranchesMapWidgetState();
}

class _BranchesMapWidgetState extends State<BranchesMapWidget> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: MapConfig.defaultCenter,
        zoom: MapConfig.defaultZoom,
        maxZoom: 18,
        minZoom: 5,
        bounds: MapConfig.syriaBounds,
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        onTap: (tapPosition, point) {
          // Deselect branch on map tap
        },
      ),
      children: [
        // Tile Layer
        TileLayer(
          urlTemplate: MapConfig.osmTileUrl,
          userAgentPackageName: 'com.shippingapp.app',
        ),

        // Branch Markers
        MarkerLayer(
          markers: _buildBranchMarkers(),
        ),

        // Route Lines (if applicable)
        if (widget.showRoutes)
          PolylineLayer(
            polylines: _buildRouteLines(),
          ),
      ],
    );
  }

  List<Marker> _buildBranchMarkers() {
    return widget.branches.map((branch) {
      final isSelected = widget.selectedBranch?.id == branch.id;

      return Marker(
        point: LatLng(branch.lat, branch.lng),
        width: isSelected ? 60 : 48,
        height: isSelected ? 60 : 48,
        builder: (context) => GestureDetector(
          onTap: () => widget.onBranchTap?.call(branch),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                  ? [Colors.blue.shade700, Colors.indigo.shade700]
                  : [Colors.blue.shade600, Colors.indigo.shade600],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: isSelected ? 12 : 8,
                  spreadRadius: isSelected ? 2 : 0,
                ),
              ],
            ),
            child: Icon(
              Icons.business,
              color: Colors.white,
              size: isSelected ? 28 : 24,
            ),
          ),
        ),
      );
    }).toList();
  }
}
```

## 11.3 رسم المسارات

```dart
class RouteLineBuilder {
  static Polyline buildRouteLine({
    required Branch from,
    required Branch to,
    bool isSelected = false,
  }) {
    return Polyline(
      points: [
        LatLng(from.lat, from.lng),
        LatLng(to.lat, to.lng),
      ],
      color: isSelected
        ? Colors.emerald.shade600
        : Colors.emerald.shade400,
      strokeWidth: isSelected ? 4 : 3,
      isDotted: !isSelected,
      borderColor: Colors.white,
      borderStrokeWidth: 1,
    );
  }

  // For curved routes (more realistic)
  static List<LatLng> buildCurvedRoute(LatLng from, LatLng to) {
    final midLat = (from.latitude + to.latitude) / 2;
    final midLng = (from.longitude + to.longitude) / 2;

    // Add slight curve
    final offset = (to.latitude - from.latitude).abs() * 0.1;
    final midPoint = LatLng(midLat + offset, midLng);

    return [from, midPoint, to];
  }
}
```

## 11.4 موقع المستخدم

```dart
class UserLocationService {
  final Geolocator _geolocator = Geolocator();

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Find nearest branch
  Branch? findNearestBranch(Position userLocation, List<Branch> branches) {
    if (branches.isEmpty) return null;

    return branches.reduce((a, b) {
      final distA = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        a.lat,
        a.lng,
      );
      final distB = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        b.lat,
        b.lng,
      );
      return distA < distB ? a : b;
    });
  }
}
```

## 11.5 فتح الخرائط الخارجية

```dart
class ExternalMapsLauncher {
  static Future<void> openInGoogleMaps(Branch branch) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${branch.lat},${branch.lng}'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openDirections(Branch from, Branch to) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=${from.lat},${from.lng}'
      '&destination=${to.lat},${to.lng}'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
```

---

<a name="routes-detail"></a>

# 12. شرح تفصيلي لشاشة المسارات (Routes Detail)

## 12.1 التخطيط الكامل

```
┌─────────────────────────────────────┐
│ [Header - Gradient Emerald-Teal]     │
│ ┌─────────────────────────────────┐ │
│ │ 📍 المسارات المتاحة             │ │
│ │    تصفح المسارات والأوقات      │ │
│ │                                 │ │
│ │ 🚚 {عدد المسارات} مسار         │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│                                     │
│ [Search Bar - Optional]             │
│ 🔍 ابحث عن مسار...                  │
│                                     │
│ [Days Filter - Horizontal Scroll]   │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│ ┌────┐┌─────┐┌──────┐┌───────┐     │
│ │الكل││الأحد││الاثنين││الثلاثاء│...   │
│ └────┘└─────┘└──────┘└───────┘     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│                                     │
│ [Routes Count Badge]                │
│ 📊 عرض {X} مسار                     │
│                                     │
│ [Routes List - Scrollable]          │
│ ┌───────────────────────────────┐   │
│ │ [Route Card 1]                 │   │
│ │ 🚚 دمشق → حلب            [متاح]│   │
│ │ 📅 الأحد                       │   │
│ │                                │   │
│ │ ┌─────────┬─────────┐          │   │
│ │ │ ⏰ المغادرة│ ⏰ الوصول │        │   │
│ │ │ 08:00   │ 12:00   │          │   │
│ │ └─────────┴─────────┘          │   │
│ │                                │   │
│ │ ┌─────────┬─────────┐          │   │
│ │ │ 📏 المسافة│ 💰 السعر/كغ│       │   │
│ │ │ 350 كم  │ 2,000   │          │   │
│ │ └─────────┴─────────┘          │   │
│ │                                │   │
│ │ [اختر هذا المسار] Button       │   │
│ └───────────────────────────────┘   │
│                                     │
│ [More Route Cards...]               │
│                                     │
│ [Empty State - If No Routes]        │
│        📍                           │
│   لا توجد مسارات متاحة              │
│   في هذا اليوم                      │
│                                     │
└─────────────────────────────────────┘
```

## 12.2 المكونات بالتفصيل

### Header Component

```dart
class RoutesHeader extends StatelessWidget {
  final int totalRoutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF059669), // emerald-600
            Color(0xFF0F766E), // teal-700
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF059669).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(LucideIcons.mapPin, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المسارات المتاحة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'تصفح المسارات والأوقات',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.truck, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  '$totalRoutes مسار',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Days Filter Component

```dart
class DaysFilter extends StatelessWidget {
  final String selectedDay;
  final Function(String) onDaySelected;

  final List<String> days = [
    'all',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 16, color: AppColors.slate600),
              SizedBox(width: 8),
              Text(
                'تصفية حسب اليوم',
                style: TextStyle(
                  color: AppColors.slate900,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: days.map((day) {
                final isSelected = selectedDay == day;
                return Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () => onDaySelected(day),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                Color(0xFF059669),
                                Color(0xFF0D9488),
                              ],
                            )
                          : null,
                        color: isSelected ? null : AppColors.slate100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                      ),
                      child: Text(
                        day == 'all' ? 'الكل' : day,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.slate600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Route Card Component

```dart
class RouteCard extends StatelessWidget {
  final Route route;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF10B981).withOpacity(0.1),
                      Color(0xFF0D9488).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.truck,
                  color: Color(0xFF059669),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              // Route Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(route.from, style: TextStyle(
                          color: AppColors.slate900,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                        SizedBox(width: 4),
                        Icon(LucideIcons.arrowLeft, size: 12, color: AppColors.slate400),
                        SizedBox(width: 4),
                        Text(route.to, style: TextStyle(
                          color: AppColors.slate900,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar, size: 12, color: AppColors.slate500),
                        SizedBox(width: 4),
                        Text(route.day, style: TextStyle(
                          color: AppColors.slate500,
                          fontSize: 12,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              // Availability Badge
              if (route.available)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'متاح',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          // Details Grid
          Row(
            children: [
              _buildInfoBox('المغادرة', route.departureTime, LucideIcons.clock),
              SizedBox(width: 8),
              _buildInfoBox('الوصول', route.arrivalTime, LucideIcons.clock),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              _buildInfoBox('المسافة', '${route.distance} كم', null),
              SizedBox(width: 8),
              _buildPriceBox('السعر/كغ', '${route.pricePerKg.toLocaleString()} ل.س'),
            ],
          ),
          SizedBox(height: 12),
          // Action Button
          GradientButton(
            text: 'اختر هذا المسار',
            gradient: [Color(0xFF059669), Color(0xFF0D9488)],
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData? icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 12, color: AppColors.slate500),
                  SizedBox(width: 4),
                ],
                Text(label, style: TextStyle(
                  color: AppColors.slate500,
                  fontSize: 11,
                )),
              ],
            ),
            SizedBox(height: 2),
            Text(value, style: TextStyle(
              color: AppColors.slate900,
              fontSize: 14,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF10B981).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(
              color: Color(0xFF059669),
              fontSize: 11,
            )),
            SizedBox(height: 2),
            Text(value, style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
          ],
        ),
      ),
    );
  }
}
```

## 12.3 البيانات الكاملة

```dart
class Route {
  final int id;
  final String from;
  final int fromBranchId;
  final String to;
  final int toBranchId;
  final String day;
  final String departureTime;
  final String arrivalTime;
  final int distance;          // بالكيلومتر
  final int pricePerKg;        // بالليرة السورية
  final bool available;
  final int? availableCapacity; // السعة المتبقية بالكيلو
  final String? notes;         // ملاحظات إضافية

  // Computed properties
  Duration get travelDuration {
    // Calculate from departure and arrival times
  }

  String get formattedPrice => '${pricePerKg.toLocaleString()} ل.س';
  String get formattedDistance => '$distance كم';
}

// Routes BLoC
abstract class RoutesEvent {}
class LoadRoutes extends RoutesEvent {}
class FilterByDay extends RoutesEvent {
  final String day;
}
class SelectRoute extends RoutesEvent {
  final Route route;
}

abstract class RoutesState {}
class RoutesInitial extends RoutesState {}
class RoutesLoading extends RoutesState {}
class RoutesLoaded extends RoutesState {
  final List<Route> routes;
  final String selectedDay;
  final List<Route> filteredRoutes;
}
class RoutesError extends RoutesState {
  final String message;
}
```

---

---

<a name="di"></a>

# 13. حقن التبعيات (Dependency Injection)

نستخدم مكتبة `get_it` بالتعاون مع `injectable` لإدارة التبعيات في التطبيق.

## 13.1 إعداد حاوية الحقن (Injection Container)

يتم تعريف جميع التبعيات في ملف `injection_container.dart`.

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Features - Map
  sl.registerFactory(() => MapBloc(getParcelLocationUseCase: sl()));
  sl.registerLazySingleton(() => GetParcelLocationUseCase(sl()));
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}
```

---

<a name="bloc"></a>

# 14. إدارة الحالة (BLoC Pattern)

نعتمد نمط BLoC لفصل منطق الأعمال عن واجهة المستخدم.

## 14.1 الهيكل العام للـ BLoC
- **Event**: يمثل الأحداث التي يقوم بها المستخدم.
- **State**: يمثل الحالة التي يجب أن تعكسها الواجهة.
- **Bloc**: المحرك الذي يحول الأحداث إلى حالات.

## 14.2 مثال عملي (MapBloc)
```dart
class MapBloc extends Bloc<MapEvent, MapState> {
  final GetParcelLocationUseCase getParcelLocationUseCase;

  MapBloc({required this.getParcelLocationUseCase}) : super(MapInitial()) {
    on<GetParcelLocationEvent>(_onGetParcelLocation);
  }

  Future<void> _onGetParcelLocation(...) async {
    emit(MapLoading());
    final result = await getParcelLocationUseCase(event.parcelId);
    result.fold(
      (failure) => emit(MapError(failure.message)),
      (location) => emit(MapLoaded(location)),
    );
  }
}
```

---

<a name="network-errors"></a>

# 15. التعامل مع الأخطاء والشبكة

## 15.1 أصناف الفشل (Failures)
نستخدم صنف `Failure` الموحد لتمثيل الأخطاء:
- `ServerFailure`: أخطاء الخادم.
- `NetworkFailure`: انقطاع الاتصال.
- `ValidationFailure`: أخطاء التحقق من البيانات.

## 15.2 معالجة استجابات API
نستخدم `Either<Failure, T>` من مكتبة `dartz` لضمان معالجة الحالات الناجحة والفاشلة بشكل صريح.

---

<a name="localization"></a>

# 16. التعريب ودعم RTL

التطبيق مصمم ليكون عربياً بالكامل منذ البداية:
- **Directionality**: نستخدم `Directionality(textDirection: TextDirection.rtl, ...)` أو نعتمد على إعدادات `MaterialApp`.
- **Fonts**: الخط الأساسي هو **Cairo** لدعمه الممتاز للعربية.
- **Spacing**: تم مراعاة انعكاس الأيقونات والمسافات لتناسب القراءة من اليمين لليسار.

---

<a name="testing"></a>

# 17. التحقق والاختبار

## 17.1 تحليل الكود
نستخدم `flutter analyze` دورياً للتأكد من:
- عدم وجود متغيرات غير مستخدمة.
- الالتزام بقواعد التسمية.
- تجنب استخدام الوظائف المهملة (Deprecated).

---

# 📝 ملاحظات ختامية

1. **RTL Support**: التطبيق يعمل بالاتجاه من اليمين لليسار
2. **Arabic Font**: استخدم خط Cairo أو Tajawal للدعم العربي
3. **Gradients**: معظم العناصر تستخدم Gradients لإضافة العمق
4. **Shadows**: استخدم shadows متدرجة (shadow-sm, shadow-lg)
5. **Border Radius**: معظم البطاقات تستخدم radius-2xl (16px)
6. **Spacing**: نظام spacing قائم على 4px grid
7. **Guest Mode**: دعم وضع الضيف مع تحديد الميزات المتاحة
8. **Maps**: استخدام flutter_map مع OpenStreetMap للخرائط المجانية
9. **Authentication**: تصميم شاشات تسجيل دخول وإنشاء حساب متكاملة
10. **Profile**: صفحة ملف شخصي شاملة مع جميع الإعدادات

---

**تم إنشاء هذا الملف في:** 2024-12-26

**آخر تحديث:** 2025-12-26 (بواسطة AI Assistant)

**الإضافات الأخيرة:** تم تحديث الدليل ليشمل ميزة الخريطة (Map Feature)، حقن التبعيات (DI)، وإدارة الحالة (BLoC).

**الغرض:** استخدامه كمرجع شامل عند بناء تطبيق Flutter وتوثيق مسار الهجرة من التصميم الأصلي.
