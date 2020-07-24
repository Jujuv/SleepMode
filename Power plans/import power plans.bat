mkdir %SYSTEMDRIVE%\TMP_Import_POW
copy *.pow %SYSTEMDRIVE%\TMP_Import_POW


powercfg -import "%SYSTEMDRIVE%\TMP_Import_POW\DL.pow"
powercfg -import "%SYSTEMDRIVE%\TMP_Import_POW\Film + DL.pow"
powercfg -import "%SYSTEMDRIVE%\TMP_Import_POW\MINING.pow"
powercfg -import "%SYSTEMDRIVE%\TMP_Import_POW\MINING+FILM.pow"

rmdir /S /Q %SYSTEMDRIVE%\TMP_Import_POW
pause