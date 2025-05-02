@echo off
:: Pindah ke folder ADB (platform-tools)
cd /d C:\Users\PF3X7\AppData\Local\Android\Sdk\platform-tools

echo Mencari perangkat yang terhubung...
adb devices > devices.txt

:: Cek apakah HP dengan serial 93fecc78 terdeteksi
findstr /C:"93fecc78" devices.txt > nul
if %errorlevel% neq 0 (
    echo Perangkat dengan serial 93fecc78 tidak ditemukan. Pastikan HP terhubung dengan kabel USB.
    del devices.txt
    pause
    exit /b
)

echo Perangkat ditemukan! Mengaktifkan mode TCP/IP...
adb -s 93fecc78 tcpip 5555

echo Mencari IP Address HP berdasarkan MAC Address...
arp -a > arp_result.txt

:: Cari IP dari MAC Address 20-34-fb-f5-53-46
set "HP_IP="
for /f "tokens=1 delims= " %%A in ('findstr /i "20-34-fb-f5-53-46" arp_result.txt') do (
    set HP_IP=%%A
)

:: Jika IP tidak ditemukan, hentikan skrip
if "%HP_IP%"=="" (
    echo Gagal menemukan IP HP. Pastikan HP sudah terhubung ke hotspot laptop.
    del arp_result.txt
    del devices.txt
    pause
    exit /b
)

echo IP HP ditemukan: %HP_IP%
echo Menghubungkan ke HP melalui ADB...
adb connect %HP_IP%:5555

:: Cek apakah koneksi berhasil
adb devices > devices_after_connect.txt
findstr /C:"%HP_IP%" devices_after_connect.txt > nul
if %errorlevel% neq 0 (
    echo Gagal menghubungkan ke HP melalui WiFi.
    del arp_result.txt
    del devices.txt
    del devices_after_connect.txt
    pause
    exit /b
)

echo Berhasil terhubung ke HP dengan IP %HP_IP%!
echo Sekarang kamu bisa mencabut kabel USB.

:: Hapus file sementara
del arp_result.txt
del devices.txt
del devices_after_connect.txt

pause
exit /b 