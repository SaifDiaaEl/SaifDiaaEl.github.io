// ===== إعدادات Supabase =====
// استبدل القيم أدناه ببيانات مشروعك في Supabase.
// للحصول عليها: Supabase Dashboard -> Project Settings -> API
window.APP_CONFIG = {
  SUPABASE_URL: "https://YOUR-PROJECT.supabase.co",
  SUPABASE_ANON_KEY: "YOUR-ANON-KEY",
  // اسم التطبيق
  APP_NAME: "نظام التقييم والمتابعة الأسبوعية",
  // إذا كانت القيم أعلاه غير مُعدّلة، يعمل التطبيق في "وضع تجريبي" (localStorage)
  DEMO_USERS: [
    { username: "father",  password: "father123",  displayName: "الأب",       role: "evaluator", evaluatorKey: "father",  avatar: "👨" },
    { username: "brother", password: "brother123", displayName: "الأخ",       role: "evaluator", evaluatorKey: "brother", avatar: "👦" },
    { username: "doctor",  password: "doctor123",  displayName: "الدكتورة",   role: "evaluator", evaluatorKey: "doctor",  avatar: "👩‍⚕️" },
    { username: "me",      password: "me123",      displayName: "أنا (المشاهد)", role: "viewer",    evaluatorKey: null,      avatar: "🙋" }
  ]
};
