---
layout: single
title: "Introduction to Memory Forensics with Volatility 3"
permalink: /:year/:month/:title
date: '2022-02-22T09:31:40-06:00'
tags:
  - infosec
  - dfir
header:
  image: /assets/images/posts/headers/volatility3.jpg
  caption: "Volatility logo by the [Volatility Foundation](https://www.volatilityfoundation.org/)"
modified_time: ""
---

Volatility is a very powerful memory forensics tool. It is used to extract information from memory images (memory dumps) of Windows, macOS, and Linux systems. There is also a *huge* community writing third-party plugins for volatility. You definitely want to include memory acquisition and analysis in your investigations, and volatility should be in your forensic toolkit.

Today we show how to use Volatility 3 from installation to basic commands. When analyzing memory, basic tasks include listing processes, checking network connections, extracting files, and conducting a basic Windows Registry analysis. We cover each of these tasks. After you understand the Volatility 3 command structure and extract some basic information, advanced memory analysis just builds on those concepts.

Memory analysis - with the help of volatility 3 - is becoming easier. It is an excellent source of action-related evidence. If you are not already routinely including memory acquisitions in your investigations, I strongly recommend you do. The amount of information available that will never be written to disk is well worth the extra effort.

{% include video id="Uk3DEgY5Ue8" provider="youtube" %}

## Volatility 3 Commands

Running Volatility 3 in Windows PowerShell.

Check version.

```python vol.py -v```

Get image information.

```python vol.py -f  [ImageName] windows.info```

See process list.

```python vol.py -f  [ImageName] windows.pslist | more```

Filter process list searching for keyword "chrome"

```python vol.py -f  [ImageName] windows.pslist | Select-String chrome```

Find all handles oepn by process 1328.

```python vol.py -f  [ImageName]windows.handles --pid 1328```

Find file handles and filter by type.

```powershell
python vol.py -f  [ImageName] windows.handles --pid 1328 | Select-String File | more
python vol.py -f  [ImageName] windows.handles --pid 1328 | Select-String File | Select-String history | more
```

Dump a file from process 1328 at virtual address.

```python vol.py -f  [ImageName] -o "dump" windows.dumpfile --pid 1328  --virtaddr 0xbf0f6abe9740```

Dump all files associated with PID 2520.

```python vol.py -f  [ImageName]windows.dumpfiles.DumpFiles --pid 2520```

See executed programs with command option history.

```python vol.py -f  [ImageName] windows.cmdline.CmdLine```

See active network connections and listening programs.

```python vol.py -f  [ImageName] windows.netstat```

Dump the Windows user password hashes.

```python vol.py -f  [ImageName] windows.hashdump.Hashdump```

Print out the Windows Registry UserAssist.

```python vol.py -f  [ImageName] windows.registry.userassist.UserAssist```

List all available Windows Registry hives in memory.

```python vol.py -f  [ImageName] windows.registay.hivelist.HiveList```

Dump the ntuser hive based on a keyword filter.

```python vol.py -f  [ImageName] -o "dump" windows.registry.hivelist --filter Doe\ntuser.dat --dump```

Print a specific Windows Registry key.

```python vol.py -f  [ImageName] windows.registry.printkey --key "Software\Microsoft\Windows\CurrentVersion" --recurse```

Print a specific Windows Registry key, subkeys and values.

```python vol.py -f  [ImageName] windows.registry.printkey --key "Software\Microsoft\Windows\CurrentVersion" --recurse```

### Links

* [Pyhon](https://python.org) (get version 3)
* [Git for Windows](https://gitforwindows.org/)
* [Microsoft C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
* [Python Snappy](https://www.lfd.uci.edu/~gohlke/pythonlibs/#python-snappy)
* [Volatility 3](https://github.com/volatilityfoundation/volatility3)
* [Practice memory image](https://archive.org/details/Africa-DFIRCTF-2021-WK02)

[Volatility Community](https://www.volatilityfoundation.org/)

### Related books

* [The Art of Memory Forensics](https://amzn.to/33DTt9b)
