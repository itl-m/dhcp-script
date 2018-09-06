@echo off

if exist "C:\test.txt" (goto idxvorhanden) else (goto idxneu)

:idxneu
Echo Verfuegbare NICs:
netsh interface ipv4 show interface
set /p idxlan=Indexnummer fuer LAN angeben:
set /p idxwlan=Indexnummer fuer WLAN angeben:

echo %idxlan% > C:\test.txt
echo %idxwlan% >> C:\test.txt

goto schnittstelle

:idxvorhanden
<C:\test.txt (
	set /p idxlan=
	set /p idxwlan=
)
echo %idxlan%
echo %idxwlan%
goto schnittstelle

:schnittstelle
set /p neu=Wollen sie die Einstellungen von LAN (1) oder WLAN (2) aendern?
echo %neu% | findstr "1" && set idx=%idxlan%
echo %neu% | findstr "2" && set idx=%idxwlan% || goto Fehler
echo %idx%
netsh interface ipv4 show ipaddress interface=%idx%

set /p neu=Wollen sie eine neue statische Ipadresse angeben (1) oder auf DHCP (automatisch) umstellen (2)?
echo %neu% | findstr "1" && goto Statisch
echo %neu% | findstr "2" && goto DHCP || goto Fehler

:DHCP
netsh interface ip set address name=%idx% source=dhcp
netsh interface ip set dns name=%idx% source=dhcp
echo DHCP aktiviert
goto ENDE

:Statisch
set /p ipadr=neue ip-Adresse:
set /p subnetzmaske=neue Subnetzmaske (normalerweise 255.255.255.0):
set /p standardgateway=neuer Standardgateway:
set /p dnsserver=neuer DNS-Server:

netsh interface ipv4 set address name=%idx% source=static
netsh interface ipv4 set address name=%idx% source=static %ipadr% %subnetzmaske% %standardgateway%
netsh interface ipv4 set dns name=%idx% source=static %dnsserver%
netsh interface ipv4 add dns name=%idx% address=9.9.9.9 rem Fehlermelungen?
echo DHCP deaktiviert
goto ENDE

:Fehler
echo Fehler
goto ende

:ENDE
pause
