# نظام التقييم والمتابعة الأسبوعية

موقع ويب عربي (RTL) لمتابعة وتقييم التصرفات اليومية والأسبوعية من خلال ثلاثة مُقيّمين: الأب، الأخ، الدكتورة، مع حساب مشاهد (أنا).

## التقنيات
- HTML / CSS / JavaScript (Vanilla)
- Supabase (Auth + Postgres + RLS)
- Chart.js للرسوم البيانية

## التشغيل
1. افتح `index.html` في المتصفح (أو استخدم any static server).
2. وضع تجريبي: يعمل تلقائيًا (localStorage) مع بيانات تجريبية (father/father123 ...).

## النشر على Vercel
### خيار 1: نشر مؤقت (تم إنشاؤه)
- رابط مؤقت: https://prompt-cyclone-5no60by.tmp.now (ينتهي خلال 60 دقيقة)
- للحفاظ عليه: https://vercel.com/claim-deployment?code=b44985c3-df48-492e-ac03-c401afd0936f

### خيار 2: نشر دائم
```bash
vercel login
cd weekly-eval
vercel --prod
```
أو ارفع المجلد عبر Vercel Dashboard (New Project → Import).
1. أنشئ مشروعًا في Supabase.
2. في SQL Editor شغّل `sql/schema.sql`.
3. Authentication -> Providers -> Email: عطّل "Confirm email" (لتسجيل instant).
4. انسخ Project URL و anon key إلى `assets/js/config.js` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).
5. أنشئ الحسابات (via Register page في التطبيق أو Supabase Dashboard) بأسماء: father, brother, doctor, me.
6. أعد تحميل الصفحة — سي switched to Supabase mode.

## الأمان
- سياسات RLS تمنع الوصول غير المصرح: كل مُقيّم يرى/يعدّل تقييماته فقط؛ المشاهد (viewer) يرى الكل.
- لا توجد سياسة DELETE → حفظ السجل.

## الميزات
- تسجيل دخول/إنشاء حساب
- تقييم يومي (إيجابيات، سلبيات، درجة 0-10)
- تعديل التقييم
- تقرير أسبوعي لكل شخص + متوسط عام (تجاهل الأيام المفقودة)
- سجل الأسابيع السابقة + تفاصيل
- لوحة تحكم + رسوم بيانية + تصميم Responsive RTL
