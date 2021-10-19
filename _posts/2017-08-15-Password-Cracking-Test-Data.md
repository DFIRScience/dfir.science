---
layout: single
title: "Password Cracking Test Data"
date: '2017-08-15T08:27:16+09:00'

tags:
- infosec
- dfir
modified_time: '2017-08-15T08:27:16+09:00'
---

Here are some files to test your password cracking skills. All of them can be done in less than a few hours with CPU-based cracking. You can download the file and practice hash extraction + cracking, or just download the hashes directly.

### Cracking Software
* [John the Ripper](http://www.openwall.com/john/)
* [hashcat](https://hashcat.net/hashcat)
* [AccessData Password Recovery Toolkit (Not Free)](http://accessdata.com/product-download)
* Check [dfir.training](http://www.dfir.training/index.php/tools/encryption-and-data-hiding/password-cracking) for more

### Files and Hashes

| Class | File                 | Hash     |
|:-----:|----------------------|----------|
| **ZIP** | [Super Easy](https://DFIR.Science/assets/data/cracking/super_easy.zip) (JtR <1s) | [SE.PKZIP](https://DFIR.Science/assets/data/cracking/super_easy.zip.hash) |
|  | [Easy](https://DFIR.Science/assets/data/cracking/easy.zip) | [E.PKZIP](https://DFIR.Science/assets/data/cracking/easy.zip.hash) |
|  | [Medium](https://DFIR.Science/assets/data/cracking/medium.zip) | [M.PKZIP](https://DFIR.Science/assets/data/cracking/medium.zip.hash)   |
|  | [Hard](https://DFIR.Science/assets/data/cracking/hard.zip) | [H.PKZIP](https://DFIR.Science/assets/data/cracking/hard.zip.hash) |
| **PDF** | [Easy](https://DFIR.Science/assets/data/cracking/easy.pdf) | [E.PDF](https://DFIR.Science/assets/data/cracking/easy.pdf.hash) |
|  | [Medium](https://DFIR.Science/assets/data/cracking/medium.pdf) | [M.PDF](https://DFIR.Science/assets/data/cracking/medium.pdf.hash) |
|  | [Hard](https://DFIR.Science/assets/data/cracking/hard.pdf) | [H.PDF](https://DFIR.Science/assets/data/cracking/hard.pdf.hash) |
| **ODT** | [Easy](https://DFIR.Science/assets/data/cracking/easy.odt) | [E.ODF](https://DFIR.Science/assets/data/cracking/easy.odt.hash) |
|  | [Medium](https://DFIR.Science/assets/data/cracking/medium.odt) | [M.ODF](https://DFIR.Science/assets/data/cracking/medium.odt.hash) |
|  | [Hard](https://DFIR.Science/assets/data/cracking/hard.odt) | [H.ODF](https://DFIR.Science/assets/data/cracking/hard.odt.hash) |

### Related Posts
* [How-to - Cracking ZIP and RAR protected files with John the Ripper](https://DFIR.Science/2014/07/how-to-cracking-zip-and-rar-protected.html)
* [Attacking Zip File Passwords from the Command Line](https://DFIR.Science/2015/01/attacking-zip-file-passwords-from.html)
