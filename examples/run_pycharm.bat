@echo off
SET OSGEO4W_ROOT="C:\OSGeo4W"
call %OSGEO4W_ROOT%\bin\o4w_env.bat

@echo off

if not exist "%OSGEO4W_ROOT%\apps\qgis\bin\qgisgrass7.dll" goto nograss
set savedpath=%PATH%
call %OSGEO4W_ROOT%\apps\grass\grass78\etc\env.bat
path %OSGEO4W_ROOT%\apps\grass\grass78\lib;%OSGEO4W_ROOT%\apps\grass\grass78\bin;%savedpath%

:nograss
@echo off
path %PATH%;%OSGEO4W_ROOT%\apps\qgis\bin
path %PATH%;%OSGEO4W_ROOT%\apps\qt5\bin
path %PATH%;%OSGEO4W_ROOT%\apps\Python39\Scripts
path %PATH%;%OSGEO4W_ROOT%\apps\qgis\python\plugins

set PYTHONPATH=%OSGEO4W_ROOT%\apps\qgis\python\plugins
set PYTHONPATH=%PYTHONPATH%;%OSGEO4W_ROOT%\apps\qgis\python

rem setado por "%OSGEO4W_ROOT%\etc\ini\python3.bat"
rem set PYTHONHOME=%OSGEO4W_ROOT%\apps\Python39

set QGIS_PREFIX_PATH=%OSGEO4W_ROOT:\=/%/apps/qgis
set GDAL_FILENAME_IS_UTF8=YES

rem Set VSI cache to be used as buffer, see #6448
set VSI_CACHE=TRUE
set VSI_CACHE_SIZE=1000000
set QT_PLUGIN_PATH=%OSGEO4W_ROOT%\apps\qgis\qtplugins;%OSGEO4W_ROOT%\apps\qt5\plugins


set PYCHARM="C:\Program Files\JetBrains\PyCharm 2023.2.1\bin\pycharm64.exe"
@echo on
start "PyCharm with QGIS knowledge!" /B %PYCHARM% %*