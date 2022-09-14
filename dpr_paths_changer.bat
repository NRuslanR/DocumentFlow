@echo off
 
set old_str=%~2
set new_str=%~3

for /f "delims=" %%v in ('dir "%~1\*.dpr" /s /b') do (
    set /A num=%num%+1
    set intermediate="%%~dpv%num%"
	
	rem echo %intermediate%

    (
	for /f "delims=" %%b in ('findstr /R .* "%%~v"') do (
		if "%%b"=="" (
		 	echo %%b
		) else (
			setlocal enabledelayedexpansion
			set "line=%%b"
			set "line=!line:%old_str%=%new_str%!"
			echo !line!
			endlocal
		)
		
	)
    ) > intermediate
	copy intermediate "%%~v"
	del intermediate
	rem "%%~dpv\%%~nv_test%%~xv"

)