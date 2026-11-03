@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Iniciar-MarSeguro.ps1"
if errorlevel 1 (
  echo.
  echo O MarSeguro nao iniciou. Confira a mensagem acima.
  pause
)
