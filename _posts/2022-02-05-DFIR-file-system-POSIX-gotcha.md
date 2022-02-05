---
layout: single
title: "DFIR file-system POSIX gotcha - process from archives directly"
permalink: /:year/:month/:title
date: '2022-02-05T13:17:06-06:00'
tags:
  - infosec
  - dfir
header:
  image: /assets/images/posts/headers/windows.jpg
  caption: "Photo by [Tadas Sar](https://unsplash.com/@stadsa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/fast?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)"
modified_time: ""
---
 
I was working on the converter [UFDR2DIR](https://github.com/DFIRScience/UFDR2DIR), and ran into some weird bugs.
I develop on Linux, and had no trouble reconstructing paths from Android and iOS device dumps. But Windows users
had errors with full paths more than the difference between "/" and "\".

From [StackOverflow](https://stackoverflow.com/questions/1976007/what-characters-are-forbidden-in-windows-and-linux-directory-names)
there are quite a few file path illegal characters. Let's focus on ":".

In Linux, we have a file ```valid:file.txt```. It works as expected.

```shell
$ cat valid:file.txt 
This is a valid file.
```

In Windows, can't even list directory:

```powershell
PS X:\test> cd test
PS X:\test> ls
ls : The given path's format is not supported.
At line:1 char:1
+ ls
+ ~~
    + CategoryInfo          : NotSpecified: (:) [Get-ChildItem], NotSup
   portedException
    + FullyQualifiedErrorId : System.NotSupportedException,Microsoft.Po
   werShell.Commands.GetChildItemCommand
```

We create a zip file containing the file with an illegal character. Trying to extract the file:

Linux

```shell
$ unzip dirtest.zip 
Archive:  dirtest.zip
 extracting: valid:file.txt  
```

Windows

```powershell
> Expand-Archive .\dirtest.zip
New-Object : Exception calling ".ctor" with "1" argument(s): "The given
path's format is not supported."
At C:\Windows\system32\WindowsPowerShell\v1.0\Modules\Microsoft.PowerShe
ll.Archive\Microsoft.PowerShell.Archive.psm1:1001 char:52
+ ... yFileInfo = New-Object -TypeName System.IO.FileInfo -ArgumentList
$cu ...
+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [New-Object], Metho
   dInvocationException
    + FullyQualifiedErrorId : ConstructorInvokedThrowException,Microsof
   t.PowerShell.Commands.NewObjectCommand
```

When extracting the archive in Windows, we get an error message then a directory and file is created but the file name is ```valid_file.txt```.

I checked [ALEAPP and iLEAPP](https://github.com/abrignoni/iLEAPP/blob/master/scripts/ilap_artifacts.py) to see if any illegal characters where included in artifact patterns. I didn't see any, but is this because contributors extracted test data directories in Windows first? If so, then direct parsing of an original archive, or extractions on other operating systems, may fail. Not saying it is happening, but it is something for developers to keep in mind.

## Conclusions

If you use Linux/MacOS then you're probably fine with extracting mobile device dumps to the local FS. The theoretical challenge is that parsers may have been written with Windows illegal character substituions in mind, meaning that data that exists in it's original path format may be missed during processing.

If you use Windows, you have the worst of both worlds. A dump of a POSIX-compliant path structure might automatically rename, fail, or fail silently. In the case of auto-rename, it might not be easy to find that a rename happened. If the parsers were developed on a POSIX-compliant system, they may fail to match Windows-renamed files and paths. Maybe time to switch to [Tsurugi Linux](https://tsurugi-linux.org/)?

* There is no consistency in how illegal path characters are handled. This means different programs many result in different file names, and some programs may *fail silently* when encountering these issues.
  * This could mean that data in an archive/dump is not extracted during an analysis with no indication given to the investigator.
* Path naming has an affect on many DFIR tools that use path matching. If the development environment is Windows, illegal characters may have already been stripped or converted. Patterns that include this conversion may not match on other OS/versions.
  * Don't explicitly include Windows illegal characters in a match... use a general match at position to support all replacements.

It would be interesting to see how Windows forenisc tools deal with illegal path characters when extracting from an image. That's probably something that needs to be documented somewhere...

If you're reading data directly out of an original archive or image, then unsupported chars in Windows don't seem to matter. It's only for extractions. This means that if you are using tools like ALEAPP and iLEAPP on Windows, feed it an acquisition archive instead of extracting to a directory.


