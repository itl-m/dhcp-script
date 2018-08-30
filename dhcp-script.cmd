@echo off

netsh interface show interface
set /p adapter=Schnittstellenname angeben:


SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`netsh interface ip show addresses %adapter%`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)

echo %var2% | findstr "Ja" && goto Statisch || goto DHCP

:DHCP
echo DHCP aktiviert
netsh interface ip set address %adapter% dhcp
netsh interface ip set dns %adapter% dhcp
goto ENDE

:Statisch
set /p ipadresse=neue ip-Adresse:
set /p subnetzmaske=neue Subnetzmaske:
set /p standardgateway=neuer Standardgateway:
set /p dnsserver=neuer DNS-Server:
netsh interface ip set address name=%adapter% static %ipadresse% %subnetzmaske% %standardgateway%
netsh interface ip set dns %adapter% static %dnsserver%
netsh interface ip add dns %adapter% 9.9.9.9
echo DHCP deaktiviert
goto ENDE

:ENDE
