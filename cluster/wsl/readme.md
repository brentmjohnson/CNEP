1. only safe vhdx image compression:

Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\

wsl --export Ubuntu-22.04 C:\WSLImages\Backups\Ubuntu-22.04_20220829

wsl --import Ubuntu-22.04 C:\WSLImages\Ubuntu-22.04 C:\WSLImages\Backups\Ubuntu-22.04_20220829 --version 2
