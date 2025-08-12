# Kolourpaint Vulnerability Detection & Research for Kylin OS

## Description

Kolourpaint vulnerability detection script for Kylin OS, with planned research on comparing vulnerable and patched packages.

---

## Overview

This repository currently provides a shell script to detect whether a Kylin OS system is affected by specific kolourpaint vulnerabilities (as described in KYSA security advisories). In the future, it will include comparative research between vulnerable and patched versions to better understand the nature of these vulnerabilities.

---

## Features

- Detects Kylin OS version and build information
- Checks kolourpaint package version against known vulnerable versions
- Provides upgrade and patching instructions
- Handles missing `kylin-sysinfo` dependency by prompting installation

---

## Usage

1. Clone the repository:

```bash
git clone https://github.com/he0xwhale/kylin-kolourpaint-vuln-lab.git
cd kylin-kolourpaint-vuln-lab
```

2. Make the script executable:

```bash
chmod +x kolourpaint_vuln_check.sh
```

3. Run the script:

```bash
./kolourpaint_vuln_check.sh
```

---

## Example Output

```
Current OS: Kylin V10 SP1
System version: v10 (minor version: 2107)
Detected kolourpaint version: 4:19.12.3-0kylin8
[WARNING] Current kolourpaint version is vulnerable.
Recommendation:
1. Upgrade kolourpaint to a secure version:
   sudo apt update && sudo apt install --only-upgrade kolourpaint
2. Or manually download and install the patched package:
   https://www.kylinos.cn/support/loophole/patch/7947.html
```

---

## Future Work

- Perform binary diff analysis between vulnerable and patched kolourpaint packages
- Document vulnerability exploitation scenarios (if PoC is available)
- Provide additional automated patch management tools

---

## References

- [KylinOS Security Advisory KYSA-202504-0023](https://www.kylinos.cn/support/loophole/patch/7947.html)
- [KylinOS Security Advisory KYSA-202504-0022](https://www.kylinos.cn/support/loophole/patch/7946.html)

---

## License

This project is licensed under the Apache 2.0 License - see the LICENSE file for details.
