# دليل استخدام نسخ التطبيق (Flavors Guide)

هذا الملف يشرح كيفية التعامل مع النسختين المختلفتين من التطبيق (المستخدم والمسؤول) بعد إعداد نظام الـ Flavors.

## 1. بناء نسخ الـ Release (APK)
لإنشاء ملفات APK جاهزة للتثبيت على الهواتف، استخدم الأوامر التالية:

### نسخة المستخدم (Customer App)
```bash
flutter build apk --flavor customer --release
```
*   **اسم التطبيق:** RMA Customer
*   **المعرف:** `com.example.rma_customer`

### نسخة المسؤول (Admin App)
```bash
flutter build apk --flavor admin --release
```
*   **اسم التطبيق:** RMA Admin
*   **المعرف:** `com.example.rma_customer.admin`

---

## 2. تشغيل نسخة الـ Debug (للمطوّر)
أثناء التطوير، تحتاج لتشغيل التطبيق مباشرة من المحرر. يجب عليك تحديد الـ flavor الذي تريد تشغيله:

### عبر الـ Terminal
*   **تشغيل نسخة المستخدم:**
    ```bash
    flutter run --flavor customer
    ```
*   **تشغيل نسخة المسؤول:**
    ```bash
    flutter run --flavor admin
    ```

### عبر VS Code (اختياري)
يمكنك إضافة إعدادات التشغيل في ملف `.vscode/launch.json` لتسهيل الاختيار من قائمة Run & Debug:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "RMA Customer (Debug)",
      "request": "launch",
      "type": "dart",
      "args": ["--flavor", "customer"]
    },
    {
      "name": "RMA Admin (Debug)",
      "request": "launch",
      "type": "dart",
      "args": ["--flavor", "admin"]
    }
  ]
}
```

---

## 3. ملاحظات هامة
*   **التثبيت المتوازي:** يمكنك الآن تثبيت النسختين معاً على نفس الجهاز دون أن تحذف إحداهما الأخرى.
*   **Firebase:** إذا أضفت Firebase مستقبلاً، يجب إضافة تطبيقين في Firebase Console (واحد لكل معرف حزمة) وتحديث ملفات الإعداد.
*   **التنظيف:** يفضل تشغيل `flutter clean` قبل تبديل البناء بين flavor وآخر لضمان عدم وجود ملفات مؤقتة قديمة.
