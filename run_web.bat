@echo off
echo Starting CORS Proxy...
start "CORS Proxy" node proxy.js
timeout /t 2 /nobreak > nul

echo Starting Flutter Web on port 5000...
flutter run -d edge --web-port 5000
