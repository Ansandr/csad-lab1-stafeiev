@echo off
setlocal

echo [ci] building and testing
call mvn -B -ntp clean test package
if errorlevel 1 exit /b %errorlevel%

if not exist dist mkdir dist
copy /Y target\hello.jar dist\hello.jar >nul
if errorlevel 1 exit /b %errorlevel%
>dist\hello.cmd (
  echo @echo off
  echo java -jar "%%~dp0hello.jar" %%*
)
if errorlevel 1 exit /b %errorlevel%
echo [ci] artifact: dist\hello.jar

for /f "delims=" %%O in ('java -jar dist\hello.jar') do set "output=%%O"
if not "%output%"=="Hello, World!" (
  echo [ci] smoke test output mismatch
  exit /b 1
)
echo %output%
echo [ci] SUCCESS
exit /b 0
