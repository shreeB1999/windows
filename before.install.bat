::powershell -Command iisreset /stop

powershell -Command "Remove-Item 'C:\inetpub\wwwroot\*' -Recurse -Force"

powershell -Command iisreset /restart