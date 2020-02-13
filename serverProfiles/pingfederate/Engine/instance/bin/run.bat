@echo off

rem -------------------------------------------------------------------------
rem Bootstrap Script for Windows
rem -------------------------------------------------------------------------
rem $Id: run.bat,v 1.13.4.1 2004/12/15 16:52:20 starksm Exp $
REM @if not "%ECHO%" == ""  echo %ECHO%
if "%OS%" == "Windows_NT"  setlocal

set PF_BIN=.\
set PROGNAME=run.bat

if "%OS%" == "Windows_NT" set PF_BIN=%~dp0
if "%OS%" == "Windows_NT" set PROGNAME=%~nx0

REM Set PF_HOME_ESC - this is PF_HOME but with spaces that are replaced with %20
SetLocal EnableDelayedExpansion
set PF_HOME=%PF_BIN%..
set PF_HOME_ESC=!PF_HOME: =%%20!
SetLocal DisableDelayedExpansion


REM Read an optional running configuration file
if ["%RUN_CONF%"] == [""] (
    set RUN_CONF=%PF_BIN%\conf.bat
)
if exist "%RUN_CONF%" (
    call "%RUN_CONF%"
)


REM Read all command line arguments
REM
REM The %ARGS% env variable commented out in favor of using %* to include
REM all args in java command line. See bug #840239. [jpl]
REM
REM set ARGS=
REM :loop
REM if [%1] == [] goto endloop
REM         set ARGS=%ARGS% %1
REM         shift
REM         goto loop
REM :endloop

REM Find run.jar, or we can't continue
set RUNJAR=%PF_BIN%run.jar
if exist "%RUNJAR%" goto FOUND_RUN_JAR
echo Could not locate %RUNJAR%. Please check that you are in the bin directory when running this script.
goto END

:FOUND_RUN_JAR

REM Find the XML Beans jar, or we can't continue
set XMLBEANS_JAR=%PF_HOME%\server\default\lib\xmlbeans.jar
if exist "%XMLBEANS_JAR%" goto FOUND_XMLBEANS_JAR
echo Could not locate %XMLBEANS_JAR%. Please check that you are in the bin directory when running this script.
goto END
:FOUND_XMLBEANS_JAR

REM Find the PFXML jar, or we can't continue
set PFXML_JAR=%PF_HOME%\server\default\lib\pf-xml.jar
if exist "%PFXML_JAR%" goto FOUND_PFXML_JAR
echo Could not locate %PFXML_JAR%. Please check that you are in the bin directory when running this script.
goto END
:FOUND_PFXML_JAR

REM Find the pf boot jar, or we can't continue
set RUNPFJAR=%PF_BIN%pf-startup.jar
if exist "%RUNPFJAR%" goto FOUND_RUNPF_JAR
echo Could not locate %RUNPFJAR%. Please check that you are in the bin directory when running this script.
goto END
:FOUND_RUNPF_JAR

REM Find Jetty jetty-start.jar, or we can't continue
set STARTJAR=%PF_BIN%jetty-start.jar
if exist "%STARTJAR%" goto FOUND_START_JAR
echo Could not locate %STARTJAR%. Please check that you are in the bin directory when running this script.
goto END
:FOUND_START_JAR

if not "%JAVA_HOME%" == "" goto ADD_JAVA
set JAVA=java
echo JAVA_HOME is not set.  Unexpected results may occur.
echo Set JAVA_HOME to the directory of your local JDK or JRE to avoid this message.
goto SETVARS

:ADD_JAVA

set JAVA=%JAVA_HOME%\bin\java

:TEST_VERSION

set JAVA_VERSION=
"%JAVA_HOME%/bin/java" -version 2>java_version.txt
for /f "tokens=3" %%g in (java_version.txt) do (
	del java_version.txt
	set JAVA_VERSION=%%g
	goto CHECK_JAVA_VERSION
)

rem grab first 3 characters of version number (ex: 1.6) and compare against required version
:CHECK_JAVA_VERSION
set JAVA_VERSION11=%JAVA_VERSION:~1,2%
if %JAVA_VERSION11% == 11 goto SETVARS

:SETVARS

REM If PF_CLASSPATH is empty, don't include it, as this will
REM result in including the local directory, which makes error tracking
REM harder.

set PF_CONSOLE_UTILS=%PF_BIN%pf-consoleutils.jar
set PF_CRYPTO_LUNA=%PF_HOME%\server\default\lib\pf-crypto-luna.jar

set PF_CLASSPATH=%RUNJAR%;%RUNPFJAR%;%STARTJAR%;%PF_CONSOLE_UTILS%;%XMLBEANS_JAR%;%PFXML_JAR%;%PF_CRYPTO_LUNA%

REM JVM Optimizations
REM To configure JVM options please edit jvm-memory.options in
REM <install-dir>\pingfederate\bin
set "JVM_MEMORY_OPTIONS_FILE=%PF_BIN%jvm-memory.options"

if not exist "%JVM_MEMORY_OPTIONS_FILE%" (
  echo Missing %JVM_MEMORY_OPTIONS_FILE%
  EXIT /B 1
)

SetLocal EnableDelayedExpansion
set "JVM_MEMORY_OPTS="
for /f "usebackq tokens=* eol=#" %%o in ("%JVM_MEMORY_OPTIONS_FILE%") do (
    set "JVM_MEMORY_OPTS=!JVM_MEMORY_OPTS! %%o"
)
SetLocal DisableDelayedExpansion

set PF_JAVA_OPTS=%PF_JAVA_OPTS% %JVM_MEMORY_OPTS%

rem uncomment to enable Memory Dumps
rem set HEAP_DUMP=-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="%PA_HOME%\log"

REM JPDA options. Uncomment and modify as appropriate to enable remote debugging.
REM set PF_JAVA_OPTS=-classic -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=y %PF_JAVA_OPTS%
REM set PF_JAVA_OPTS=-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n %PF_JAVA_OPTS%

REM Setup PingFederate specific properties

set PF_JAVA_OPTS=%PF_JAVA_OPTS% -Dprogram.name=%PROGNAME%

REM Workaround for nCipher HSM to support Java 8
REM Remove this when nCipher officially supports Java 8

set PF_JAVA_OPTS=%PF_JAVA_OPTS% -Dcom.ncipher.provider.announcemode=on

REM disable use of preallocated exceptions and always show the full stacktrace
set PF_JAVA_OPTS=%PF_JAVA_OPTS% -XX:-OmitStackTraceInFastThrow

REM Enable using jconsole to configure config stores
REM set PF_JAVA_OPTS=%PF_JAVA_OPTS% -Dcom.sun.management.jmxremote
REM set PF_JAVA_OPTS=%PF_JAVA_OPTS% -Djetty51.encode.cookies=CookieName1,CookieName2

rem comment out to disable java crash logs
set ERROR_FILE=-XX:ErrorFile=%PF_HOME_ESC%\log\java_error%p.log

rem uncomment to enable Memory Dumps
rem set HEAP_DUMP=-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=%PF_HOME_ESC%\log

set PF_JAVA_OPTS=%ERROR_FILE% %HEAP_DUMP% %PF_JAVA_OPTS%

set RANDOM_SOURCE="-Djava.security.egd=file:/dev/./urandom"
REM Setup the java endorsed dirs

set PF_ENDORSED_DIRS=%PF_HOME%\lib\endorsed

set PF_ENDORSED_DIRS_FLAG="-Djava.endorsed.dirs=%PF_ENDORSED_DIRS%"

if %JAVA_VERSION11% == 11 (
	set "PF_ENDORSED_DIRS_FLAG="
)

set RUN_PROPERTIES=""
if exist "%PF_BIN%run.properties" (
	set RUN_PROPERTIES=%PF_BIN%run.properties
) ELSE (
	echo Missing %PF_HOME%\bin\run.properties; using defaults.
)

:RESTART

"%JAVA%" %PF_JAVA_OPTS% %JAVA_OPTS% -Dlog4j2.AsyncQueueFullPolicy=Discard -Dlog4j2.DiscardThreshold=INFO -Dlog4j.configurationFile="file://%PF_HOME%/server/default/conf/log4j2.xml" -Drun.properties="%RUN_PROPERTIES%" %PF_ENDORSED_DIRS_FLAG% -Dpf.home="%PF_HOME%" -Djetty.home="%PF_HOME%" -Djetty.base="%PF_HOME%\bin" -Djetty.server=com.pingidentity.appserver.jetty.PingFederateInit -Dpf.server.default.dir="%PF_HOME%\server\default" -Dpf.java="%JAVA%" -Dpf.java.opts="%PF_JAVA_OPTS% -Drun.properties=%RUN_PROPERTIES%" -Dpf.classpath="%PF_CLASSPATH%" -classpath "%PF_CLASSPATH%" %RANDOM_SOURCE% org.pingidentity.RunPF %*

IF ERRORLEVEL 10 GOTO RESTART
:END

if "%NOPAUSE%" == "" pause