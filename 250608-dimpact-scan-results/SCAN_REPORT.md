# Container Image Security Scan Report

Generated on: Sun Jun  8 16:39:36 UTC 2025

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| nginx-latest | 3 | 15 | 27 | 0 | 2 | - |
| ghcr-io-brp-api-personen-mock-2-6-0-202502261446 | 2 | 6 | 34 | 0 | 1 | - |
| docker-io-clamav-clamav-latest | 0 | 0 | 0 | 0 | 0 | - |
| docker-elastic-co-eck-eck-operator-latest | 0 | 0 | 1 | 0 | 0 | - |
| docker-io-bitnami-kibana-8-6-1-debian-11-r0 | - | - | - | - | - | ❌ |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **5** | **21** | **62** | **0** | **3** | **1** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 5
- 🟠 **High:** 21
- 🟡 **Medium:** 62
- 🔵 **Low:** 0
- 🛡️ **Suppressed:** 3
- ❌ **Failed Scans:** 1

## 📝 Image Summary

### nginx-latest
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 15
- **Medium:** 27
- **Low:** 0
- **Suppressed:** 2

### ghcr-io-brp-api-personen-mock-2-6-0-202502261446
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 6
- **Medium:** 34
- **Low:** 0
- **Suppressed:** 1

### docker-io-clamav-clamav-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-elastic-co-eck-eck-operator-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 1
- **Low:** 0
- **Suppressed:** 0

### docker-io-bitnami-kibana-8-6-1-debian-11-r0
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan

## 🔍 Detailed CVE Analysis

The following section lists all vulnerabilities found in each image, sorted by severity.

### 🖼️ nginx-latest
**Helm Chart:** nginx

#### 🔴 CRITICAL Vulnerabilities (2)

**CVE:** CVE-2023-6879
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** aom: heap-buffer-overflow on frame size change
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2023-6879
**Description:** Increasing the resolution of video frames, while performing a multi-threaded encode, can result in a heap overflow in av1_loop_restoration_dealloc()....

**CVE:** CVE-2025-48174
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** In libavif before 1.3.0, makeRoom in stream.c has an integer overflow  ...
**Fix:** 0.11.1-1+deb12u1
**Reference:** https://github.com/AOMediaCodec/libavif/commit/50a743062938a3828581d725facc9c2b92a1d109
**Description:** In libavif before 1.3.0, makeRoom in stream.c has an integer overflow and resultant buffer overflow in stream->offset+size....

---

#### 🟠 HIGH Vulnerabilities (14)

**CVE:** CVE-2023-2953
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** openldap: null pointer dereference in  ber_memalloc_x  function
**Fix:** No fix available
**Reference:** http://seclists.org/fulldisclosure/2023/Jul/47
**Description:** A vulnerability was found in openldap. This security flaw causes a null pointer dereference in ber_memalloc_x() function....

**CVE:** CVE-2023-39616
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** AOMedia v3.0.0 to v3.5.0 was discovered to contain an invalid read mem ...
**Fix:** No fix available
**Reference:** https://bugs.chromium.org/p/aomedia/issues/detail?id=3372#c3
**Description:** AOMedia v3.0.0 to v3.5.0 was discovered to contain an invalid read memory access via the component assign_frame_buffer_p in av1/common/av1_common_int.h....

**CVE:** CVE-2023-52355
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libtiff: TIFFRasterScanlineSize64 produce too-big size and could cause OOM
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2023-52355
**Description:** An out-of-memory flaw was found in libtiff that could be triggered by passing a crafted tiff file to the TIFFRasterScanlineSize64() API. This flaw allows a remote attacker to cause a denial of service...

**CVE:** CVE-2023-52425
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** expat: parsing large tokens can trigger a denial of service
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2024/03/20/5
**Description:** libexpat through 2.5.0 allows a denial of service (resource consumption) because many full reparsings are required in the case of a large token for which multiple buffer fills are needed....

**CVE:** CVE-2024-25062
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: use-after-free in XMLReader
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2024:2679
**Description:** An issue was discovered in libxml2 before 2.11.7 and 2.12.x before 2.12.5. When using the XML Reader interface with DTD validation and XInclude expansion enabled, processing crafted XML documents can ...

**CVE:** CVE-2024-56171
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: Use-After-Free in libxml2
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2025:2679
**Description:** libxml2 before 2.12.10 and 2.13.x before 2.13.6 has a use-after-free in xmlSchemaIDCFillNodeTables and xmlSchemaBubbleIDCNodeTables in xmlschemas.c. To exploit this, a crafted XML document must be val...

**CVE:** CVE-2024-8176
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libexpat: expat: Improper Restriction of XML Entity Expansion Depth in libexpat
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2025/03/15/1
**Description:** A stack overflow vulnerability exists in the libexpat library due to the way it handles recursive entity expansion in XML documents. When parsing an XML document with deeply nested entity references, ...

**CVE:** CVE-2025-24928
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: Stack-based buffer overflow in xmlSnprintfElements of libxml2
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2025:2679
**Description:** libxml2 before 2.12.10 and 2.13.x before 2.13.6 has a stack-based buffer overflow in xmlSnprintfElements in valid.c. To exploit this, DTD validation must occur for an untrusted document or untrusted D...

**CVE:** CVE-2025-27113
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: NULL Pointer Dereference in libxml2 xmlPatMatch
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2025-27113
**Description:** libxml2 before 2.12.10 and 2.13.x before 2.13.6 has a NULL pointer dereference in xmlPatMatch in pattern.c....

**CVE:** CVE-2025-32414
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: Out-of-Bounds Read in libxml2
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2025-32414
**Description:** In libxml2 before 2.13.8 and 2.14.x before 2.14.2, out-of-bounds memory access can occur in the Python API (Python bindings) because of an incorrect return value. This occurs in xmlPythonFileRead and ...

**CVE:** CVE-2025-32415
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: Out-of-bounds Read in xmlSchemaIDCFillNodeTables
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2025-32415
**Description:** In libxml2 before 2.13.8 and 2.14.x before 2.14.2, xmlSchemaIDCFillNodeTables in xmlschemas.c has a heap-based buffer under-read. To exploit this, a crafted XML document must be validated against an X...

**CVE:** CVE-2025-4802
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** glibc: static setuid binary dlopen may incorrectly search LD_LIBRARY_PATH
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2025/05/16/7
**Description:** Untrusted LD_LIBRARY_PATH environment variable vulnerability in the GNU C Library version 2.27 to 2.38 allows attacker controlled loading of dynamically shared library in statically compiled setuid bi...

**CVE:** CVE-2025-5222
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** icu: Stack buffer overflow in the SRBRoot::addTag function
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2025-5222
**Description:** A stack buffer overflow was found in Internationl components for unicode (ICU ). While running the genrb binary, the 'subtag' struct overflowed at the SRBRoot::addTag function. This issue may lead to ...

---

#### 🟡 MEDIUM Vulnerabilities (27)

**CVE:** 
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** A SUID binary or process has a special type of permission, which allows the process to run with the file owner's permissions, regardless of the user executing the binary. This allows the process to access more restricted data than unprivileged users or processes would be able to. An attacker can leverage this flaw by forcing a SUID process to crash and force the Linux kernel to recycle the process PID before systemd-coredump can analyze the /proc/pid/auxv file. If the attacker wins the race condition, they gain access to the original's SUID process coredump file. They can read sensitive content loaded into memory by the original binary, affecting data confidentiality.
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** CVE-2022-49043
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml: use-after-free in xmlXIncludeAddNode
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2025:1350
**Description:** xmlXIncludeAddNode in xinclude.c in libxml2 before 2.11.0 has a use-after-free....

**CVE:** CVE-2023-32570
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** VideoLAN dav1d before 1.2.0 has a thread_task.c race condition that ca ...
**Fix:** No fix available
**Reference:** https://code.videolan.org/videolan/dav1d/-/commit/cf617fdae0b9bfabd27282854c8e81450d955efa
**Description:** VideoLAN dav1d before 1.2.0 has a thread_task.c race condition that can lead to an application crash, related to dav1d_decode_frame_exit....

**CVE:** CVE-2023-39615
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: crafted xml can cause global buffer overflow
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2023:7747
**Description:** Xmlsoft Libxml2 v2.11.0 was discovered to contain an out-of-bounds read via the xmlSAX2StartElement() function at /libxml2/SAX2.c. This vulnerability allows attackers to cause a Denial of Service (DoS...

**CVE:** CVE-2023-45322
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libxml2: use-after-free in xmlUnlinkNode() in tree.c
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2023/10/06/5
**Description:** libxml2 through 2.11.5 has a use-after-free that can only occur after a certain memory allocation fails. This occurs in xmlUnlinkNode in tree.c. NOTE: the vendor's position is "I don't think these iss...

**CVE:** CVE-2023-50495
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** ncurses: segmentation fault via _nc_wrap_entry()
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2023-50495
**Description:** NCurse v6.4-20230418 was discovered to contain a segmentation fault via the component _nc_wrap_entry()....

**CVE:** CVE-2023-51792
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** Buffer Overflow vulnerability in libde265 v1.0.12 allows a local attac ...
**Fix:** No fix available
**Reference:** https://github.com/strukturag/libde265
**Description:** Buffer Overflow vulnerability in libde265 v1.0.12 allows a local attacker to cause a denial of service via the allocation size exceeding the maximum supported size of 0x10000000000....

**CVE:** CVE-2023-6277
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libtiff: Out-of-memory in TIFFOpen via a craft file
**Fix:** No fix available
**Reference:** http://seclists.org/fulldisclosure/2024/Jul/16
**Description:** An out-of-memory flaw was found in libtiff. Passing a crafted tiff file to TIFFOpen() API may allow a remote attacker to cause a denial of service via a craft input with size smaller than 379 KB....

**CVE:** CVE-2024-10041
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** pam: libpam: Libpam vulnerable to read hashed password
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2024:10379
**Description:** A vulnerability was found in PAM. The secret information is stored in memory, where the attacker can trigger the victim program to execute by sending characters to its standard input (stdin). As this ...

**CVE:** CVE-2024-22365
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** pam: allowing unprivileged user to block another user namespace
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2024/01/18/3
**Description:** linux-pam (aka Linux PAM) before 1.6.0 allows attackers to cause a denial of service (blocked login process) via mkfifo because the openat call (for protect_dir) lacks O_DIRECTORY....

**CVE:** CVE-2024-38949
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** Heap Buffer Overflow vulnerability in Libde265 v1.0.15 allows attacker ...
**Fix:** No fix available
**Reference:** https://github.com/strukturag/libde265/issues/460
**Description:** Heap Buffer Overflow vulnerability in Libde265 v1.0.15 allows attackers to crash the application via crafted payload to display444as420 function at sdl.cc...

**CVE:** CVE-2024-38950
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** Heap Buffer Overflow vulnerability in Libde265 v1.0.15 allows attacker ...
**Fix:** No fix available
**Reference:** https://github.com/strukturag/libde265/issues/460
**Description:** Heap Buffer Overflow vulnerability in Libde265 v1.0.15 allows attackers to crash the application via crafted payload to __interceptor_memcpy function....

**CVE:** CVE-2024-50602
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** libexpat: expat: DoS via XML_ResumeParser
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2024:9541
**Description:** An issue was discovered in libexpat before 2.6.4. There is a crash within the XML_ResumeParser function because XML_StopParser can stop/suspend an unstarted parser....

**CVE:** CVE-2025-3576
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** krb5: Kerberos RC4-HMAC-MD5 Checksum Vulnerability Enabling Message Spoofing via MD5 Collisions
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2025:8411
**Description:** A vulnerability in the MIT Kerberos implementation allows GSSAPI-protected messages using RC4-HMAC-MD5 to be spoofed due to weaknesses in the MD5 checksum design. If RC4 is preferred over stronger enc...

**CVE:** CVE-2025-40909
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** perl: Perl threads have a working directory race condition where file operations may target unintended paths
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2025/05/23/1
**Description:** Perl threads have a working directory race condition where file operations may target unintended paths....

**CVE:** CVE-2025-4598
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** systemd-coredump: race condition that allows a local attacker to crash a SUID program and gain read access to the resulting core dump
**Fix:** 252.38-1~deb12u1
**Reference:** http://www.openwall.com/lists/oss-security/2025/06/05/1
**Description:** A vulnerability was found in systemd-coredump. This flaw allows an attacker to force a SUID process to crash and replace it with a non-SUID binary to access the original's privileged process coredump,...

**CVE:** If a directory handle is open at thread creation, the process-wide current working directory is temporarily changed in order to clone that handle for the new thread, which is visible from any third (or more) thread already running. 
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** The bug was introduced in commit 11a11ecf4bea72b17d250cfb43c897be1341861e and released in Perl version 5.13.6
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** This may lead to unintended operations such as loading code or accessing files from unexpected locations, which a local attacker may be able to exploit.
**Image:** nginx-latest
**Helm Chart:** nginx
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (HIGH) - perl: CPAN.pm does not verify TLS certificates when downloading distributions over HTTPS
- **CVE-2023-45853** (CRITICAL) - zlib: integer overflow and resultant heap-based buffer overflow in zipOpenNewFileInZip4_6


### 🖼️ ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0

#### 🔴 CRITICAL Vulnerabilities (1)

**CVE:** CVE-2019-8457
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** sqlite: heap out-of-bound read in function rtreenode()
**Fix:** No fix available
**Reference:** http://lists.opensuse.org/opensuse-security-announce/2019-06/msg00074.html
**Description:** SQLite3 from 3.6.0 to and including 3.27.2 is vulnerable to heap out-of-bound read in the rtreenode() function when handling invalid rtree tables....

---

#### 🟠 HIGH Vulnerabilities (6)

**CVE:** CVE-2021-33560
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** libgcrypt: mishandles ElGamal encryption because it lacks exponent blinding to address a side-channel attack against mpi_powm
**Fix:** No fix available
**Reference:** https://access.redhat.com/hydra/rest/securitydata/cve/CVE-2021-33560.json
**Description:** Libgcrypt before 1.8.8 and 1.9.x before 1.9.3 mishandles ElGamal encryption because it lacks exponent blinding to address a side-channel attack against mpi_powm, and the window size is not chosen appr...

**CVE:** CVE-2022-3715
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** bash: a heap-buffer-overflow in valid_parameter_transform
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2023:0340
**Description:** A flaw was found in the bash package, where a heap-buffer overflow can occur in valid parameter_transform. This issue may lead to memory problems....

**CVE:** CVE-2022-4899
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** zstd: mysql: buffer overrun in util.c
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2024:1141
**Description:** A vulnerability was found in zstd v1.4.10, where an attacker can supply empty string as an argument to the command line tool to cause buffer overrun....

**CVE:** CVE-2025-4802
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** glibc: static setuid binary dlopen may incorrectly search LD_LIBRARY_PATH
**Fix:** 2.31-13+deb11u13
**Reference:** http://www.openwall.com/lists/oss-security/2025/05/16/7
**Description:** Untrusted LD_LIBRARY_PATH environment variable vulnerability in the GNU C Library version 2.27 to 2.38 allows attacker controlled loading of dynamically shared library in statically compiled setuid bi...

**CVE:** CVE-2025-5222
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** icu: Stack buffer overflow in the SRBRoot::addTag function
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2025-5222
**Description:** A stack buffer overflow was found in Internationl components for unicode (ICU ). While running the genrb binary, the 'subtag' struct overflowed at the SRBRoot::addTag function. This issue may lead to ...

---

#### 🟡 MEDIUM Vulnerabilities (34)

**CVE:** 
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** A SUID binary or process has a special type of permission, which allows the process to run with the file owner's permissions, regardless of the user executing the binary. This allows the process to access more restricted data than unprivileged users or processes would be able to. An attacker can leverage this flaw by forcing a SUID process to crash and force the Linux kernel to recycle the process PID before systemd-coredump can analyze the /proc/pid/auxv file. If the attacker wins the race condition, they gain access to the original's SUID process coredump file. They can read sensitive content loaded into memory by the original binary, affecting data confidentiality.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** CVE-2023-4641
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** shadow-utils: possible password leak during passwd(1) change
**Fix:** 1:4.8.1-1+deb11u1
**Reference:** https://access.redhat.com/errata/RHSA-2023:6632
**Description:** A flaw was found in shadow-utils. When asking for a new password, shadow-utils asks the password twice. If the password fails on the second attempt, shadow-utils fails in cleaning the buffer used to s...

**CVE:** CVE-2023-4806
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** glibc: potential use-after-free in getaddrinfo()
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2023/10/03/4
**Description:** A flaw was found in glibc. In an extremely rare situation, the getaddrinfo function may access memory that has been freed, resulting in an application crash. This issue is only exploitable when a NSS ...

**CVE:** CVE-2023-4813
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** glibc: potential use-after-free in gaih_inet()
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2023/10/03/8
**Description:** A flaw was found in glibc. In an uncommon situation, the gaih_inet function may use memory that has been freed, resulting in an application crash. This issue is only exploitable when the getaddrinfo f...

**CVE:** CVE-2023-50495
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** ncurses: segmentation fault via _nc_wrap_entry()
**Fix:** No fix available
**Reference:** https://access.redhat.com/security/cve/CVE-2023-50495
**Description:** NCurse v6.4-20230418 was discovered to contain a segmentation fault via the component _nc_wrap_entry()....

**CVE:** CVE-2024-10041
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** pam: libpam: Libpam vulnerable to read hashed password
**Fix:** No fix available
**Reference:** https://access.redhat.com/errata/RHSA-2024:10379
**Description:** A vulnerability was found in PAM. The secret information is stored in memory, where the attacker can trigger the victim program to execute by sending characters to its standard input (stdin). As this ...

**CVE:** CVE-2024-12133
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** libtasn1: Inefficient DER Decoding in libtasn1 Leading to Potential Remote DoS
**Fix:** 4.16.0-2+deb11u2
**Reference:** http://www.openwall.com/lists/oss-security/2025/02/06/6
**Description:** A flaw in libtasn1 causes inefficient handling of specific certificate data. When processing a large number of elements in a certificate, libtasn1 takes much longer than expected, which can slow down ...

**CVE:** CVE-2024-12243
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** gnutls: GnuTLS Impacted by Inefficient DER Decoding in libtasn1 Leading to Remote DoS
**Fix:** 3.7.1-5+deb11u7
**Reference:** https://access.redhat.com/errata/RHSA-2025:4051
**Description:** A flaw was found in GnuTLS, which relies on libtasn1 for ASN.1 data processing. Due to an inefficient algorithm in libtasn1, decoding certain DER-encoded certificate data can take excessive time, lead...

**CVE:** CVE-2024-13176
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** openssl: Timing side-channel in ECDSA signature computation
**Fix:** 1.1.1w-0+deb11u3
**Reference:** http://www.openwall.com/lists/oss-security/2025/01/20/2
**Description:** Issue summary: A timing side-channel which could potentially allow recovering...

**CVE:** CVE-2024-22365
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** pam: allowing unprivileged user to block another user namespace
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2024/01/18/3
**Description:** linux-pam (aka Linux PAM) before 1.6.0 allows attackers to cause a denial of service (blocked login process) via mkfifo because the openat call (for protect_dir) lacks O_DIRECTORY....

**CVE:** CVE-2025-0395
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** glibc: buffer overflow in the GNU C Library's assert()
**Fix:** 2.31-13+deb11u12
**Reference:** http://www.openwall.com/lists/oss-security/2025/01/22/4
**Description:** When the assert() function in the GNU C Library versions 2.13 to 2.40 fails, it does not allocate enough space for the assertion failure message string and size information, which may lead to a buffer...

**CVE:** CVE-2025-24528
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** krb5: overflow when calculating ulog block size
**Fix:** 1.18.3-6+deb11u6
**Reference:** https://access.redhat.com/errata/RHSA-2025:2722
**Description:** A flaw was found in krb5. With incremental propagation enabled, an authenticated attacker can cause kadmind to write beyond the end of the mapped region for the iprop log file. This issue can trigger ...

**CVE:** CVE-2025-3576
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** krb5: Kerberos RC4-HMAC-MD5 Checksum Vulnerability Enabling Message Spoofing via MD5 Collisions
**Fix:** 1.18.3-6+deb11u7
**Reference:** https://access.redhat.com/errata/RHSA-2025:8411
**Description:** A vulnerability in the MIT Kerberos implementation allows GSSAPI-protected messages using RC4-HMAC-MD5 to be spoofed due to weaknesses in the MD5 checksum design. If RC4 is preferred over stronger enc...

**CVE:** CVE-2025-40909
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** perl: Perl threads have a working directory race condition where file operations may target unintended paths
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2025/05/23/1
**Description:** Perl threads have a working directory race condition where file operations may target unintended paths....

**CVE:** CVE-2025-4598
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** systemd-coredump: race condition that allows a local attacker to crash a SUID program and gain read access to the resulting core dump
**Fix:** No fix available
**Reference:** http://www.openwall.com/lists/oss-security/2025/06/05/1
**Description:** A vulnerability was found in systemd-coredump. This flaw allows an attacker to force a SUID process to crash and replace it with a non-SUID binary to access the original's privileged process coredump,...

**CVE:** If a directory handle is open at thread creation, the process-wide current working directory is temporarily changed in order to clone that handle for the new thread, which is visible from any third (or more) thread already running. 
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** Impact summary: A timing side-channel in ECDSA signature computations
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** The FIPS modules in 3.4, 3.3, 3.2, 3.1 and 3.0 are affected by this issue.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** The bug was introduced in commit 11a11ecf4bea72b17d250cfb43c897be1341861e and released in Perl version 5.13.6
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** There is a timing signal of around 300 nanoseconds when the top word of
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** This may lead to unintended operations such as loading code or accessing files from unexpected locations, which a local attacker may be able to exploit.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** a very fast network connection with low latency.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** could allow recovering the private key by an attacker. However, measuring
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** have a very fast network connection with low latency. For that reason
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** probability only for some of the supported elliptic curves. In particular
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** process must either be located in the same physical computer or must
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** the NIST P-521 curve is affected. To be able to measure this leak, the attacker
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** the inverted ECDSA nonce value is zero. This can happen with significant
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** the private key exists in the ECDSA signature computation.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** the severity of this vulnerability is Low.
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

**CVE:** the timing would require either local access to the signing application or
**Image:** ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0
**Title:** 
**Fix:** 
**Reference:** 
**Description:** ...

---

#### 🛡️ Suppressed Vulnerabilities (1)

- **CVE-2023-45853** (CRITICAL) - zlib: integer overflow and resultant heap-based buffer overflow in zipOpenNewFileInZip4_6


### 🖼️ docker-io-clamav-clamav-latest
**Helm Chart:** docker-io-clamav-clamav


### 🖼️ docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator

#### 🟡 MEDIUM Vulnerabilities (1)

**CVE:** CVE-2025-22871
**Image:** docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator
**Title:** net/http: Request smuggling due to acceptance of invalid chunked data in net/http
**Fix:** 1.23.8, 1.24.2
**Reference:** http://www.openwall.com/lists/oss-security/2025/04/04/4
**Description:** The net/http package improperly accepts a bare LF as a line terminator in chunked data chunk-size lines. This can permit request smuggling if a net/http server is used in conjunction with a server tha...

---


## 🎯 Recommendations
❌ **FAILED SCANS**: 1 images could not be scanned. Please check image accessibility and try again.
⚠️ **CRITICAL**: Immediate action required! 5 critical vulnerabilities found.
🔴 **HIGH**: High priority action required! 21 high vulnerabilities found.
🟡 **MEDIUM**: Plan to address 62 medium vulnerabilities.
ℹ️ **SUPPRESSED**: 3 vulnerabilities have been suppressed based on CVE suppressions list.

## 📁 Files Generated
For each scanned image, the following files are generated in its directory:

- `trivy-results.json`: Trivy vulnerability scan results (JSON format)
- `trivy-results.txt`: Trivy vulnerability scan results (text format)
- `grype-results.json`: Grype vulnerability scan results (JSON format)
- `grype-results.txt`: Grype vulnerability scan results (text format)
- `sbom.spdx.json`: Software Bill of Materials (SPDX JSON format)
- `sbom.txt`: Software Bill of Materials (text format)
- `summary.md`: Per-image vulnerability summary
- `vulnerabilities.md`: Detailed vulnerability report
