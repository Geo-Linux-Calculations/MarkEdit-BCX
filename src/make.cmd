@echo off
if (%1)==(--help) (
  echo HELP.
  echo Make this project.
  echo .
  echo COMAND LINE:
  echo .
  echo make --help
  echo /this help/
  echo .
  echo make
  echo /compiling this project/
  echo .
  echo make -d
  echo /detalise make/
  echo .
  echo make upx
  echo /UPX compress prjname.exe/
  echo .
  echo make install
  echo /copy prjname.exe in INSTALLDIR /
  echo .
  echo make install "VARINSTALLDIR"
  echo /copy prjname.exe in VARINSTALLDIR /
  echo .
  echo make uninstall
  echo /delete prjname.exe in INSTALLDIR /
  echo .
  echo make uninstall "VARINSTALLDIR"
  echo /delete prjname.exe in VARINSTALLDIR /
  echo .
  echo make clean
  echo /clean *.obj,*.res/
  echo .
  echo make clean all
  echo /clean all: *.c,*.obj,*.res,*.exe/
  echo .
  goto END
)
set BAKPATH=%PATH%
set PRJNAME=markedit
set WORKPATH=D:\Ide\BCX\work\MarkEdit.v.1.0.0.3\src
set INSTALLPATH=C:\MARKSOFT\MarkEdit
if not exist %WORKPATH%\BUILD (
  mkdir %WORKPATH%\BUILD
)
if (%1)==(upx) goto UPX
if (%1)==(clean) goto CLEAN
if (%1)==(install) goto INSTALL
if (%1)==(uninstall) goto UNINSTALL
if (%1)==(-d) goto BCX
if not (%1)==() goto UNKNOW
:BCX
set BCXPATH=D:\IDE\BCX
cd %WORKPATH%
echo Bacic to C translation...
if (%1)==(-d) (@echo on)
%BCXPATH%\BIN\BC.EXE %PRJNAME%.bas -f:%WORKPATH%\BUILD\%PRJNAME%.c
if errorlevel 1 goto MAKEERRROR
if (%1)==(-d) (@echo off)
echo %PRJNAME%.c
echo OK
echo .
copy markedit.h %WORKPATH%\BUILD\
:POCC
set POCCPATH=D:\IDE\PellesC
call %POCCPATH%\BIN\povars32.bat
if errorlevel 1 goto MAKERRROR
echo Path PellesC = %PellesCDir%
echo OK
echo .
set RESPATH=RES
set RESNAME=markedit
cd %RESPATH%
echo PellesC resource compile...
if /%1/==/-d/ @echo on
%POCCPATH%\BIN\porc.exe /Fo%WORKPATH%\BUILD\%PRJNAME%.res %RESNAME%.rc
if errorlevel 1 goto MAKEERROR
if /%1/==/-d/ @echo off
echo RES\markedit.res
cd %WORKPATH%
echo OK
echo .
echo PellesC compile...
if (%1)==(-d) (@echo on)
%POCCPATH%\bin\pocc.exe /D_WIN32_IE=0x0501 /W1 /Os /Gd /Go /Zd /Ze /Zx /Tx86-coff %WORKPATH%\BUILD\%PRJNAME%.c /Fo%WORKPATH%\BUILD\%PRJNAME%.obj
if errorlevel 1 goto MAKEERROR
if (%1)==(-d) (@echo off)
echo %PRJNAME%.obj
echo OK
echo .
echo PellesC linker...
if (%1)==(-d) (@echo on)
%POCCPATH%\bin\polink.exe /release /delay:nobind /machine:ix86 /subsystem:windows kernel32.lib user32.lib gdi32.lib comctl32.lib comdlg32.lib advapi32.lib delayimp.lib /out:%WORKPATH%\BUILD\%PRJNAME%.exe %WORKPATH%\BUILD\%PRJNAME%.obj %WORKPATH%\BUILD\%PRJNAME%.res
if errorlevel 1 goto MAKEERROR
if (%1)==(-d) (@echo off)
echo %PRJNAME%.exe
echo OK
echo .
goto END
:UPX
echo UPX compress
SET UPXPATH=D:\IDE\FREEUPX
cd %WORKPATH%
%UPXPATH%\upx.exe BUILD\%PRJNAME%.exe
if errorlevel 1 goto MAKEERROR
echo OK
echo .
goto END
:CLEAN
echo Clean project
cd %WORKPATH%
del /Q BUILD\*.res
del /Q BUILD\*.obj
if (%2)==(all) (
  del /Q BUILD\*.*
)
echo OK
echo .
goto END
:INSTALL
if not (%2)==() (
  set INSTALLPATH=%2
)
if not exist %WORKPATH%\BUILD\%PRJNAME%.exe goto MAKEERROR
if not exist %INSTALLPATH% (
  mkdir %INSTALLPATH%
)
if not exist %INSTALLPATH%\DOC (
  mkdir %INSTALLPATH%\DOC
)
copy %WORKPATH%\BUILD\%PRJNAME%.exe %INSTALLPATH%
copy %WORKPATH%\News.txt %INSTALLPATH%\DOC\markedit-news.txt
copy %WORKPATH%\Authors.txt %INSTALLPATH%\DOC\markedit-authors.txt
copy %WORKPATH%\DOC\markprogs.pdf %INSTALLPATH%\DOC
copy %WORKPATH%\DOC\markedit.pdf %INSTALLPATH%\DOC
echo Installation %PRJNAME% in %INSTALLPATH%
goto END
:UNINSTALL
if not (%2)==() (
  set INSTALLPATH=%2
)
del /Q %INSTALLPATH%\%PRJNAME%.exe
del /Q %INSTALLPATH%\DOC\markedit*.*
echo Uninstall %PRJNAME% of %INSTALLPATH%
goto END
:UNKNOW
echo Option "%1" unknow.
echo Type 'make --help' for show options.
echo .
goto END
:MAKEERROR
echo !!! Make error.
:END
set PATH=%BAKPATH%
pause
