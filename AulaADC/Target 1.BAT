SET PATH=C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin;C:\Program Files\Common Files\Oracle\Java\javapath;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Git\cmd;C:\Program Files\TortoiseGit\bin;C:\Program Files\CMake\bin;C:\Program Files\dotnet\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\ProgramData\chocolatey\bin;C:\Program Files\PuTTY\;C:\Users\rafae\AppData\Local\Microsoft\WindowsApps;C:\Users\rafae\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\rafae\.dotnet\tools;C:\Program Files\JetBrains\IntelliJ IDEA 2025.2.3\bin;C:\Users\rafae\AppData\Local\JetBrains\Toolbox\scripts;C:\Users\rafae\AppData\Local\Programs\Zed\bin
SET CPU_TYPE=TM4C1294NCPDT
SET CPU_VENDOR=Texas Instruments
SET UV2_TARGET=Target 1
SET CPU_CLOCK=0x00B71B00
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmAsm" --Via ".\objects\startup._ia"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmAsm" --Via ".\objects\utils._ia"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\main.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\teclado.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\gpio.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\lcd.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\motor.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\led.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\uart.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\adc.__i"
"C:\Users\rafae\AppData\Local\Keil_v5\ARM\ARMCLANG\Bin\ArmLink" --Via ".\Objects\exemplo.lnp"
