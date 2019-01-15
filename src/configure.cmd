@echo off
echo Configure...
if (%1)==(--help) (
  echo HELP.
  echo This configure make for compiling this project.
  echo .
  echo COMAND LINE:
  echo .
  echo configure
  echo /default configure, options setproject/
  echo .
  echo configure --help
  echo /this help/
  echo .
  echo configure --CC POCC
  echo /compiling of PellesC/
  echo .
  echo configure --CC LCC
  echo /compiling of LCC-WIN32/
  echo .
  echo configure --CC Not
  echo /not compiling, only tranclator to C/
  echo .
  goto END
)

:SETHELP
echo @echo off> make.cmd
echo if (%%1)==(--help) (>> make.cmd
echo   echo HELP.>> make.cmd
echo   echo Make this project.>> make.cmd
echo   echo .>> make.cmd
echo   echo COMAND LINE:>> make.cmd
echo   echo .>> make.cmd
echo   echo make --help>> make.cmd
echo   echo /this help/>> make.cmd
echo   echo .>> make.cmd
echo   echo make>> make.cmd
echo   echo /compiling this project/>> make.cmd
echo   echo .>> make.cmd
echo   echo make -d>> make.cmd
echo   echo /detalise make/>> make.cmd
echo   echo .>> make.cmd
echo   echo make upx>> make.cmd
echo   echo /UPX compress prjname.exe/>> make.cmd
echo   echo .>> make.cmd
echo   echo make install>> make.cmd
echo   echo /copy prjname.exe in INSTALLDIR />> make.cmd
echo   echo .>> make.cmd
echo   echo make install "VARINSTALLDIR">> make.cmd
echo   echo /copy prjname.exe in VARINSTALLDIR />> make.cmd
echo   echo .>> make.cmd
echo   echo make uninstall>> make.cmd
echo   echo /delete prjname.exe in INSTALLDIR />> make.cmd
echo   echo .>> make.cmd
echo   echo make uninstall "VARINSTALLDIR">> make.cmd
echo   echo /delete prjname.exe in VARINSTALLDIR />> make.cmd
echo   echo .>> make.cmd
echo   echo make clean>> make.cmd
echo   echo /clean *.obj,*.res/>> make.cmd
echo   echo .>> make.cmd
echo   echo make clean all>> make.cmd
echo   echo /clean all: *.c,*.obj,*.res,*.exe/>> make.cmd
echo   echo .>> make.cmd
echo   goto END>> make.cmd
echo )>> make.cmd

:SETPATH
if not (%1)==() (
  if not /%1/==/--CC/ goto UNKNOW
)
echo set BAKPATH=%%PATH%%>>make.cmd
call setpath.cmd
if errorlevel 1 goto CNFGERROR
call setproject.cmd
if errorlevel 1 goto CNFGERROR
echo .
echo Project %PRJNAME%:
echo .
set WORKPATH=%CD%
echo WORKPATH = %WORKPATH%
if not exist %WORKPATH%\%PRJNAME%.bas goto CNFGERROR
echo set PRJNAME=%PRJNAME%>> make.cmd
echo set WORKPATH=%WORKPATH%>> make.cmd
echo set INSTALLPATH=%INSTALLPATH%>> make.cmd
if not (%RC%)==(TRUE) (
  set RC=FALSE
)
set RESPFN=%RESNAME%
if not (%RESPATH%)==() (
  set RESPFN=%RESPATH%\%RESNAME%
)
echo if not exist %%WORKPATH%%\BUILD (>> make.cmd
echo   mkdir %%WORKPATH%%\BUILD>> make.cmd
echo )>> make.cmd

echo if (%%1)==(upx) goto UPX>> make.cmd
echo if (%%1)==(clean) goto CLEAN>> make.cmd
echo if (%%1)==(install) goto INSTALL>> make.cmd
echo if (%%1)==(uninstall) goto UNINSTALL>> make.cmd
echo if (%%1)==(-d) goto BCX>> make.cmd
echo if not (%%1)==() goto UNKNOW>> make.cmd
echo .

:TESTBC
echo Test Basic to C/C++ Translator...
if not exist %BCXPATH%\BIN\BC.EXE goto CNFGERROR
echo :BCX>> make.cmd
echo set BCXPATH=%BCXPATH%>> make.cmd
echo cd %%WORKPATH%%>> make.cmd
echo echo Bacic to C translation...>> make.cmd
echo if (%%1)==(-d) (@echo on)>> make.cmd
echo %%BCXPATH%%\BIN\BC.EXE %%PRJNAME%%.bas -f:%%WORKPATH%%\BUILD\%%PRJNAME%%.c>> make.cmd
echo if errorlevel 1 goto MAKEERRROR>> make.cmd
echo if (%%1)==(-d) (@echo off)>> make.cmd
echo echo %%PRJNAME%%.c>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
echo copy %PRJNAME%.h %%WORKPATH%%\BUILD\>> make.cmd

if (%1)==(--CC) (
  set CC=%2
)
echo CC = %CC%
echo .
if (%CC%)==(POCC) goto TESTPOCC
if (%CC%)==(LCC) goto TESTLCC
goto ENDCFG

:TESTPOCC
echo :POCC>> make.cmd
echo Test Path PellesC Compiler...
if not exist %POCCPATH%\BIN\povars32.bat goto CNFGERROR
echo set POCCPATH=%POCCPATH%>> make.cmd
echo call %%POCCPATH%%\BIN\povars32.bat>> make.cmd
echo if errorlevel 1 goto MAKERRROR>> make.cmd
echo echo Path PellesC = %%PellesCDir%%>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
if (%RC%)==(TRUE) (
  echo Test PellesC Resource Compiler...
  echo set RESPATH=%RESPATH%>> make.cmd
  echo set RESNAME=%RESNAME%>> make.cmd
  if not exist %POCCPATH%\BIN\porc.exe goto CNFGERROR
  if not exist %RESPFN%.rc goto CNFGERROR
  echo cd %%RESPATH%%>>make.cmd
  echo echo PellesC resource compile...>> make.cmd
  echo if /%%1/==/-d/ @echo on>> make.cmd
  echo %%POCCPATH%%\BIN\porc.exe /Fo%%WORKPATH%%\BUILD\%%PRJNAME%%.res %%RESNAME%%.rc>> make.cmd
  echo if errorlevel 1 goto MAKEERROR>> make.cmd
  echo if /%%1/==/-d/ @echo off>> make.cmd
  echo echo %RESPFN%%.res>> make.cmd
  echo cd %%WORKPATH%%>> make.cmd
  echo echo OK>> make.cmd
  echo echo .>> make.cmd
  echo OK
  echo .
)
echo Test Pelles C compiler...
if not exist %POCCPATH%\BIN\POCC.EXE goto CNFGERROR
echo echo PellesC compile...>> make.cmd
echo if (%%1)==(-d) (@echo on)>> make.cmd
echo %%POCCPATH%%\bin\pocc.exe /D_WIN32_IE=0x0501 /W1 /Os /Gd /Go /Zd /Ze /Zx /Tx86-coff %%WORKPATH%%\BUILD\%%PRJNAME%%.c /Fo%%WORKPATH%%\BUILD\%%PRJNAME%%.obj>> make.cmd
echo if errorlevel 1 goto MAKEERROR>> make.cmd
echo if (%%1)==(-d) (@echo off)>> make.cmd
echo echo %%PRJNAME%%.obj>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
echo Test Pelles C linker...
if not exist %POCCPATH%\BIN\POLINK.EXE goto CNFGERROR
echo echo PellesC linker...>> make.cmd
echo if (%%1)==(-d) (@echo on)>> make.cmd
if (%RC%)==(TRUE) (
  echo %%POCCPATH%%\bin\polink.exe /release /delay:nobind /machine:ix86 /subsystem:windows kernel32.lib user32.lib gdi32.lib comctl32.lib comdlg32.lib advapi32.lib delayimp.lib /out:%%WORKPATH%%\BUILD\%%PRJNAME%%.exe %%WORKPATH%%\BUILD\%%PRJNAME%%.obj %%WORKPATH%%\BUILD\%%PRJNAME%%.res>> make.cmd
)
if (%RC%)==(FALSE) (
  echo %%POCCPATH%%\bin\polink.exe /release /delay:nobind /machine:ix86 /subsystem:windows kernel32.lib user32.lib gdi32.lib comctl32.lib comdlg32.lib advapi32.lib delayimp.lib /out:%%WORKPATH%%\BUILD\%%PRJNAME%%.exe %%WORKPATH%%\BUILD\%%PRJNAME%%.obj>> make.cmd
)
echo if errorlevel 1 goto MAKEERROR>> make.cmd
echo if (%%1)==(-d) (@echo off)>> make.cmd
echo echo %%PRJNAME%%.exe>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
goto ENDCFG

:TESTLCC
echo :LCC>> make.cmd
echo Test Lcc-Win32 Compiler...
if not exist %LCCPATH%\BIN\lcc.exe goto CNFGERROR
echo set LCCPATH=%LCCPATH%>> make.cmd
echo echo Path Lcc-Win32 = %%LCCPATH%%>> make.cmd
echo OK
echo .
if (%RC%)==(TRUE) (
  echo Test Lcc-Win32 Resource Compiler...
  echo set RESPATH=%RESPATH%>> make.cmd
  echo set RESNAME=%RESNAME%>> make.cmd
  if not exist %LCCPATH%\BIN\lrc.exe goto CNFGERROR
  if not exist %RESPFN%.rc goto CNFGERROR
  echo cd %%RESPATH%%>>make.cmd
  echo echo Lcc-Win32 resource compile...>> make.cmd
  echo if /%%1/==/-d/ @echo on>> make.cmd
  echo %%LCCPATH%%\BIN\lrc.exe /fo%%WORKPATH%%\BUILD\%%PRJNAME%%.res %%PRJNAME%%.rc>> make.cmd
  echo if errorlevel 1 goto MAKEERROR>> make.cmd
  echo if /%%1/==/-d/ @echo off>> make.cmd
  echo echo %RESPFN%%.res>> make.cmd
  echo cd %%WORKPATH%%>> make.cmd
  echo echo OK>> make.cmd
  echo echo .>> make.cmd
  echo OK
  echo .
)
echo Test Lcc-Win32 compiler...
if not exist %LCCPATH%\BIN\LCC.EXE goto CNFGERROR
echo echo Lcc-Win32 compile...>> make.cmd
echo if (%%1)==(-d) (@echo on)>> make.cmd
echo %%LCCPATH%%\bin\lcc.exe -Zp1 -v -o %%WORKPATH%%\BUILD\%%PRJNAME%%.obj %%WORKPATH%%\BUILD\%%PRJNAME%%.c>> make.cmd
echo if errorlevel 1 goto MAKEERROR>> make.cmd
echo if (%%1)==(-d) (@echo off)>> make.cmd
echo echo %%PRJNAME%%.obj>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
echo Test Lcc-Win32 linker...
if not exist %POCCPATH%\BIN\POLINK.EXE goto CNFGERROR
echo echo Lcc-Win32 linker...>> make.cmd
echo if (%%1)==(-d) (@echo on)>> make.cmd
if (%RC%)==(TRUE) (
  echo %%LCCPATH%%\bin\lcclnk.exe -subsystem windows -v -s -o %%WORKPATH%%\BUILD\%%PRJNAME%%.exe %%WORKPATH%%\BUILD\%%PRJNAME%%.obj %%WORKPATH%%\BUILD\%%PRJNAME%%.res>> make.cmd
)
if (%RC%)==(FALSE) (
  echo %%LCCPATH%%\bin\lcclnk.exe -subsystem windows -v -s -o %%WORKPATH%%\BUILD\%%PRJNAME%%.exe %%WORKPATH%%\BUILD\%%PRJNAME%%.obj>> make.cmd
)
echo if errorlevel 1 goto MAKEERROR>> make.cmd
echo if (%%1)==(-d) (@echo off)>> make.cmd
echo echo %%PRJNAME%%.exe>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo OK
echo .
goto ENDCFG

:ENDCFG
echo goto END>> make.cmd

:UPXCFG
echo :UPX>> make.cmd
echo echo UPX compress>> make.cmd
if not exist %UPXPATH%\upx.exe (
  SET UPX=FALSE
  echo UPX compressor not fund
)
if not (%UPX%)==(TRUE) (
  set UPX=FALSE
)
if (%UPX%)==(TRUE) (
  echo UPX compressor...
  echo SET UPXPATH=%UPXPATH%>> make.cmd
  echo cd %%WORKPATH%%>> make.cmd
  echo %%UPXPATH%%\upx.exe BUILD\%%PRJNAME%%.exe>> make.cmd
  echo if errorlevel 1 goto MAKEERROR>> make.cmd
  echo echo OK>> make.cmd
  echo echo .>> make.cmd
  echo OK
  echo .
)
if (%UPX%)==(FALSE) (
  echo echo Not this element!>> make.cmd
)
echo goto END>> make.cmd

:CLEANCFG
echo :CLEAN>> make.cmd
echo echo Clean project>> make.cmd
echo cd %%WORKPATH%%>> make.cmd
echo del /Q BUILD\*.res>> make.cmd
echo del /Q BUILD\*.obj>> make.cmd
echo if (%%2)==(all) (>> make.cmd
echo   del /Q BUILD\*.*>> make.cmd
echo )>> make.cmd
echo echo OK>> make.cmd
echo echo .>> make.cmd
echo goto END>> make.cmd

:INSTALLCFG
echo :INSTALL>> make.cmd
echo if not (%%2)==() (>> make.cmd
echo   set INSTALLPATH=%%2>> make.cmd
echo )>> make.cmd
echo if not exist %%WORKPATH%%\BUILD\%%PRJNAME%%.exe goto MAKEERROR>> make.cmd
echo if not exist %%INSTALLPATH%% (>> make.cmd
echo   mkdir %%INSTALLPATH%%>> make.cmd
echo )>> make.cmd
echo if not exist %%INSTALLPATH%%\DOC (>> make.cmd
echo   mkdir %%INSTALLPATH%%\DOC>> make.cmd
echo )>> make.cmd
echo copy %%WORKPATH%%\BUILD\%%PRJNAME%%.exe %%INSTALLPATH%%>> make.cmd
echo copy %%WORKPATH%%\News.txt %%INSTALLPATH%%\DOC\markedit-news.txt>> make.cmd
echo copy %%WORKPATH%%\Authors.txt %%INSTALLPATH%%\DOC\markedit-authors.txt>> make.cmd
echo copy %%WORKPATH%%\DOC\markprogs.pdf %%INSTALLPATH%%\DOC>> make.cmd
echo copy %%WORKPATH%%\DOC\markedit.pdf %%INSTALLPATH%%\DOC>> make.cmd
echo echo Installation %%PRJNAME%% in %%INSTALLPATH%%>> make.cmd
echo goto END>> make.cmd

:UNINSTALLCFG
echo :UNINSTALL>> make.cmd
echo if not (%%2)==() (>> make.cmd
echo   set INSTALLPATH=%%2>> make.cmd
echo )>> make.cmd
echo del /Q %%INSTALLPATH%%\%%PRJNAME%%.exe>> make.cmd
echo del /Q %%INSTALLPATH%%\DOC\markedit*.*>> make.cmd
echo echo Uninstall %%PRJNAME%% of %%INSTALLPATH%%>> make.cmd
echo goto END>> make.cmd

:UNKNOWCFG
echo :UNKNOW>> make.cmd
echo echo Option "%%1" unknow.>> make.cmd
echo echo Type 'make --help' for show options.>> make.cmd
echo echo .>> make.cmd
echo goto END>> make.cmd

echo :MAKEERROR>> make.cmd
echo echo !!! Make error.>> make.cmd
echo :END>> make.cmd
echo set PATH=%%BAKPATH%%>>make.cmd
echo pause>> make.cmd
echo .

echo For build and clean:
echo make
echo make upx
echo make install
echo make uninstall
echo make clean
echo make clean all
echo .
echo For help:
echo make --help
echo .
goto END

:UNKNOW
echo Option "%1" unknow.
echo Type 'configure --help' for show options.
echo .

:CNFGERROR
del /Q make.cmd > nul
echo !!! Configure error.
goto END

:END
echo .
pause
