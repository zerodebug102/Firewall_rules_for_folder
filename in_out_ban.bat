@echo off

setlocal EnableDelayedExpansion

cd /d "D:\sw"

:: Если хочешь указать конкретную папку — раскомментируй и измени путь
:: set "targetFolder=C:\Downloads\Cracked"
:: cd /d "%targetFolder%"

echo Блокировка ВСЕХ .exe в текущей папке и подпапках...
echo Запуск от имени администратора обязателен!
echo.

set count=0

for /r %%F in (*.exe) do (
    set /a count+=1
    set "ruleOut=Block Out - %%~nxF (%%~dpF)"
    set "ruleIn=Block In  - %%~nxF (%%~dpF)"
    set "prog=%%~fF"
    
    :: Проверяем, существует ли уже правило (чтобы не дублировать)
    netsh advfirewall firewall show rule name="!ruleOut!" >nul 2>&1
    if !errorlevel! neq 0 (
        netsh advfirewall firewall add rule name="!ruleOut!" dir=out action=block program="!prog!" enable=yes profile=any >nul
        echo [+] Out: %%~nxF
    ) else (
        echo [~] Out уже есть: %%~nxF
    )
    
    netsh advfirewall firewall show rule name="!ruleIn!" >nul 2>&1
    if !errorlevel! neq 0 (
        netsh advfirewall firewall add rule name="!ruleIn!" dir=in action=block program="!prog!" enable=yes profile=any >nul
        echo [+] In:  %%~nxF
    ) else (
        echo [~] In уже есть: %%~nxF
    )
)

echo.
echo Обработано файлов: %count%
echo Правила созданы (если не было ошибок).
pause