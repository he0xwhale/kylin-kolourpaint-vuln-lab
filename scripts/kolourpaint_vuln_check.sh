#!/bin/bash
# kolourpaint Vulnerability Detection and Patch Script
# Applicable for KYSA-202504-0022 and KYSA-202504-0023

SAFE_VER="4:19.12.3-0kylin11k1.19update1"
PATCH_URL="https://www.kylinos.cn/support/loophole/patch/7947.html"
PATCH_PKG1="kolourpaint4_19.12.3-0kylin11k1.24_all.deb"
PATCH_PKG2="kolourpaint_19.12.3-0kylin11k1.24_amd64.deb"

color_red="\033[1;31m"
color_yellow="\033[1;33m"
color_green="\033[1;32m"
color_reset="\033[0m"

# Get OS info
os_name=$(grep -oP '^PRETTY_NAME="\K.*(?=")' /etc/os-release)
os_version=$(grep -oP '^VERSION_ID="\K.*(?=")' /etc/os-release)

# Get minor version
if command -v kylin-sysinfo >/dev/null 2>&1; then
    os_minor_version=$(kylin-sysinfo version --all | awk -F ':' '/minor version/ {gsub(/ /,"",$2);print $2}')
else
    echo -e "${color_yellow}[Notice] kylin-sysinfo tool not detected, unable to retrieve system minor version.${color_reset}"
    echo "Please install kylin-sysinfo as follows:"
    echo "1. Download the package from Kylin official site:"
    echo "   https://security-oss.kylinos.cn/Desktop/libkysdk-sysinfo.zip"
    echo "2. Choose the appropriate deb package for your architecture, e.g.:"
    echo "   kylin-sysinfo_xxx_amd64.deb"
    echo "3. Install it with:"
    echo "   sudo dpkg -i kylin-sysinfo_xxx_amd64.deb"
    echo "   sudo apt -f install  # fix dependencies"
    echo
    os_minor_version="unknown"
fi


# Get kolourpaint version
pkg_ver=$(dpkg-query -W -f='${Version}\n' kolourpaint 2>/dev/null)
if [ -z "$pkg_ver" ]; then
    echo -e "${color_yellow}[Warning] kolourpaint package is not installed.${color_reset}"
    exit 1
fi

# Output system info
echo -e "${color_green}Current OS: $os_name${color_reset}"
echo -e "System version: $os_version (minor version: $os_minor_version)"
echo -e "Current kolourpaint version: $pkg_ver"

# Vulnerability check
dpkg --compare-versions "$pkg_ver" lt "$SAFE_VER" && vulnerable="yes" || vulnerable="no"

# System affected check
if [[ "$os_minor_version" =~ ^[0-9]+$ ]]; then
    if [ "$os_minor_version" -eq 2503 ]; then
        os_vulnerable="yes"
    else
        os_vulnerable="no"
    fi
else
    os_vulnerable="unknown"
fi

# Output result
if [ "$vulnerable" == "yes" ] && [ "$os_vulnerable" == "yes" ]; then
    echo -e "${color_red}[CRITICAL] Both system and kolourpaint are vulnerable. Please patch immediately!${color_reset}"
elif [ "$vulnerable" == "yes" ]; then
    echo -e "${color_yellow}[Warning] Current kolourpaint version is vulnerable.${color_reset}"
else
    echo -e "${color_green}[Safe] System and kolourpaint versions are not vulnerable.${color_reset}"
fi

# Patch instructions
if [ "$vulnerable" == "yes" ]; then
    echo -e "${color_yellow}Patch instructions:${color_reset}"
    echo "1. Download the patch from Kylin official site: $PATCH_URL"
    echo "2. Download the kolourpaint packages for your architecture:"
    echo "   - $PATCH_PKG1"
    echo "   - $PATCH_PKG2"
    echo "3. Install the patch:"
    echo "   sudo dpkg -i $PATCH_PKG1 $PATCH_PKG2"
    echo "   sudo apt -f install  # fix dependencies"
    echo "Or upgrade using system package manager:"
    echo "   sudo apt update && sudo apt install --only-upgrade kolourpaint kolourpaint4"
fi

# kylin-sysinfo missing notice
if [ "$os_minor_version" == "unknown" ]; then
    echo -e "${color_yellow}[Notice] Minor version could not be detected. Please install kylin-sysinfo to enable system version detection.${color_reset}"
    echo "Download URL: https://www.kylinos.cn/support/technology.html"
fi
