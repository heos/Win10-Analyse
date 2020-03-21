@echo off
set "source=%~dp0"
if "%source%x"=="x" (
set source=.\
)
NET SESSION >nul 2>&1
IF not %ERRORLEVEL%==0 (
goto noadmin
)
cd /d "%source%"
REM set name=Win10_WMF_20191113_R02
echo.
echo ++++++++++++++++++++++++++++++++++++++++++++++
echo +                                            +
echo +  Kontron Analyse\Doku  runtime images      +
echo +  copyright Kontron 2020   v0.3            +
echo +                                            +
echo ++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
echo "Please Input a filename "
set /p name=
echo.
if not "%1x"=="x" (
set name=%1
) else (
echo.
echo Usage: 00Doku_win10 [filename] to save the output using a different filename,
echo please wait ...........
)
echo.
del "%name%.old" /q >NUL 2>&1
ren "%name%.txt" "%name%.old" >NUL 2>&1
echo.
echo ============================================== >"%name%.txt"
echo Detecting  Driver List Information  >>"%name%.txt"
echo ============================================= >>"%name%.txt"
dism /online /Get-Drivers /format:table >>"%name%.txt"
echo.
echo Complete.
echo.
echo ============================================== >"%name%.txt"
echo Detecting  Windows Updates Information  >>"%name%.txt"
echo ============================================= >>"%name%.txt"
wmic qfe >>"%name%.txt"
echo.
echo Complete.
echo.
echo ============================================== >>"%name%.txt"
echo Detecting International\Language Information >>"%name%.txt"
echo ============================================== >>"%name%.txt"
dism /online /Get-Intl >>"%name%.txt"
echo.
echo Complete.
echo.
echo ============================================== >>"%name%.txt"
echo Detecting Windows Features Information  >>"%name%.txt"
echo ============================================== >>"%name%.txt"
dism /online /Get-Features /format:table >>"%name%.txt"
echo.
echo Complete.
echo.
echo ============================================== >>"%name%.txt"
echo Detecting Windows Packages Information >>"%name%.txt"
echo ============================================== >>"%name%.txt"
dism /online /Get-Packages /format:table >>"%name%.txt"
echo.
echo Complete.
echo.
echo ============================================== >>"%name%.txt"
echo Detecting BCD Content Information >>"%name%.txt"
echo ============================================== >>"%name%.txt"
bcdedit.exe /enum ALL /v >>"%name%.txt"
echo.
echo Complete.
echo.
wmic service Get name,DisplayName,StartMode,State /format:htable > %name%_service_List.html
wmic service Get name,DisplayName,StartMode,State /format:csv > %name%_service_List.csv
wmic product Get name,version,vendor /format:htable > %name%_InstalledPrg_List.html
wmic product Get name,version,vendor /format:csv > %name%_InstalledPrg_List.csv
wmic bios Get Manufacturer,Name,ReleaseDate,SerialNumber,Version /format:csv > %name%_BIOS_Info.csv
wmic baseboard get Description,Manufacturer,Product,SerialNumber,Version /format:csv > %name%_Baseboard_Info.csv
wmic csproduct get IdentifyingNumber,Name,SKUNumber,Vendor,Version /format:csv > %name%_Product_Info.csv
wmic cpu get name,revision,caption,LoadPercentage,CurrentClockSpeed /format:csv >> %name%_CPU_Info.csv 
systeminfo > %name%_System_Info.txt
type c:\version.txt >> %name%_System_Info.txt
echo Please send  the *.txt, *.csv, *.html files to Kontron Support
echo.
goto end
:noadmin
echo Please run this program with Administrative Rights
echo ==================================================
echo.
:end
pause