@echo off
chcp 65001 > nul
echo.
echo =============================================
echo    اعداد مشروع getx_flutter
echo =============================================
echo.

echo [1/3] التحقق من Flutter...
flutter --version > nul 2>&1
if errorlevel 1 (
    echo  خطا: Flutter غير مثبت على هذا الجهاز
    echo  حمله من: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo  Flutter موجود
echo.

echo [2/3] تثبيت الحزم (flutter pub get)...
flutter pub get
if errorlevel 1 (
    echo  فشل تثبيت الحزم
    pause
    exit /b 1
)
echo.

echo [3/3] استخراج SHA-1 لـ Google Sign-In على Android...
echo.
echo --- DEBUG SHA-1 (للتطوير) ---
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android 2>nul | findstr /i "SHA1"
if errorlevel 1 (
    echo  لم يتم العثور على debug.keystore
    echo  شغل مرة واحدة: flutter build apk
    echo  ثم اعد تشغيل هذا الملف
)
echo.
echo =============================================
echo  انتهى الاعداد بنجاح
echo.
echo  الخطوة التالية:
echo  انسخ SHA-1 من فوق وسجله في Google Cloud Console
echo  console.cloud.google.com
echo =============================================
echo.
pause


