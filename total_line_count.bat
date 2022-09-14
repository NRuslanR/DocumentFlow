set /a total_line_count = 0
for /f "delims=" %%a in ('dir /b /s /a-d "*.pas"') do (
for /f "delims=" %%c in ('find /c /v "" "%%a"') do (set /a total_line_count+=%%c)
)
echo %total_line_count%
