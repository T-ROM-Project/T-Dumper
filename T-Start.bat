@echo off
set "VER=1.0"
echo TTTTTTT   RRRRRR   OOOOOO   M     M  
echo    T      R     R  O    O   MM   MM  
echo    T      RRRRRR   O    O   M M M M  
echo    T      R   R    O    O   M  M  M  
echo    T      R    R   OOOOOO   M     M  
echo ====================================
echo Autostart Helper for T-Dumper %VER%
echo ====================================
timeout /t 5 >nul
cls
echo Reading Script Path ...
timeout /t 1 >nul
set "ROOT=%USERPROFILE%\Desktop\trom"
set "FILETEMP=%ROOT%\temp"
set tempFile1=%FILETEMP%\path.txt
set /p fileContent=<%tempFile1%
set "T-INSTALLER=%fileContent%"
cls
echo Done 
timeout /t 2 >nul
cls
echo Starting T-Installer ...
timeout /t 1 >nul
cd %T-INSTALLER%
cls
call T-Installer.bat
