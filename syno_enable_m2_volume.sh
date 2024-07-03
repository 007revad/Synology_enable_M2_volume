#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Enables using non-Synology NVMe drives so you can create a storage pool
# and volume on any M.2 drive(s) entirely in DSM Storage Manager.
#
# Github: https://github.com/007revad/Synology_enable_M2_volume
# Script verified at https://www.shellcheck.net/
# Tested on DSM 7.2 and 7.2.1
#
# To run in a shell (replace /volume1/scripts/ with path to script):
# sudo /volume1/scripts/syno_enable_m2_volume.sh
#------------------------------------------------------------------------------

scriptver="v1.1.22"
script=Synology_enable_M2_volume
repo="007revad/Synology_enable_M2_volume"
scriptname=syno_enable_m2_volume

# Check BASH variable is bash
if [ ! "$(basename "$BASH")" = bash ]; then
    echo "This is a bash script. Do not run it with $(basename "$BASH")"
    printf \\a
    exit 1
fi

# Check script is running on a Synology NAS
if ! /usr/bin/uname -a | grep -i synology >/dev/null; then
    echo "This script is NOT running on a Synology NAS!"
    echo "Copy the script to a folder on the Synology"
    echo "and run it from there."
    exit 1
fi

ding(){ 
    printf \\a
}

usage(){ 
    cat <<EOF
$script $scriptver - by 007revad

Usage: $(basename "$0") [options]

Options:
  -c, --check           Check value in file and backup file
  -r, --restore         Restore backup to undo changes
  -n, --noreboot        Don't reboot after script has run
  -e, --email           Disable colored text in output scheduler emails
      --autoupdate=AGE  Auto update script (useful when script is scheduled)
                          AGE is how many days old a release must be before
                          auto-updating. AGE must be a number: 0 or greater
  -h, --help            Show this help message
  -v, --version         Show the script version

EOF
    exit 0
}


scriptversion(){ 
    cat <<EOF
$script $scriptver - by 007revad

See https://github.com/$repo
EOF
    exit 0
}


# Save options used
args=("$@")


# Check for flags with getopt
if options="$(getopt -o abcdefghijklmnopqrstuvwxyz0123456789 -l \
    check,restore,noreboot,email,autoupdate:,help,version,log,debug -- "$@")"; then
    eval set -- "$options"
    while true; do
        case "${1,,}" in
            -c|--check)         # Check value in file and backup file
                check=yes
                ;;
            -r|--restore)       # Restore backup to undo changes
                restore=yes
                ;;
            -e|--email)         # Disable colour text in task scheduler emails
                color=no
                ;;
            -n|--noreboot)      # Don't reboot after script has run
                noreboot=yes
                ;;
            --autoupdate)       # Auto update script
                autoupdate=yes
                if [[ $2 =~ ^[0-9]+$ ]]; then
                    delay="$2"
                    shift
                else
                    delay="0"
                fi
                ;;
            -h|--help)          # Show usage options
                usage
                ;;
            -v|--version)       # Show script version
                scriptversion
                ;;
            -l|--log)           # Log
                #log=yes
                ;;
            -d|--debug)         # Show and log debug info
                debug=yes
                ;;
            --)
                shift
                break
                ;;
            *)                  # Show usage options
                echo -e "Invalid option '$1'\n"
                usage "$1"
                ;;
        esac
        shift
    done
else
    echo
    usage
fi


if [[ $debug == "yes" ]]; then
    set -x
    export PS4='`[[ $? == 0 ]] || echo "\e[1;31;40m($?)\e[m\n "`:.$LINENO:'
fi


# Shell Colors
if [[ $color != "no" ]]; then
    #Black='\e[0;30m'   # ${Black}
    Red='\e[0;31m'      # ${Red}
    #Green='\e[0;32m'   # ${Green}
    Yellow='\e[0;33m'   # ${Yellow}
    #Blue='\e[0;34m'    # ${Blue}
    #Purple='\e[0;35m'  # ${Purple}
    Cyan='\e[0;36m'     # ${Cyan}
    #White='\e[0;37m'   # ${White}
    Error='\e[41m'      # ${Error}
    Off='\e[0m'         # ${Off}
else
    echo ""  # For task scheduler email readability
fi


# Check script is running as root
if [[ $( whoami ) != "root" ]]; then
    ding
    echo -e "${Error}ERROR${Off} This script must be run as sudo or root!"
    exit 1
fi

# Get DSM major version
dsm=$(/usr/syno/bin/synogetkeyvalue /etc.defaults/VERSION majorversion)
if [[ $dsm -lt "7" ]]; then
    ding
    echo "This script only works for DSM 7."
    exit 1
fi


# Show script version
#echo -e "$script $scriptver\ngithub.com/$repo\n"
echo "$script $scriptver"

# Get NAS model
model=$(cat /proc/sys/kernel/syno_hw_version)

# Get DSM full version
productversion=$(/usr/syno/bin/synogetkeyvalue /etc.defaults/VERSION productversion)
buildphase=$(/usr/syno/bin/synogetkeyvalue /etc.defaults/VERSION buildphase)
buildnumber=$(/usr/syno/bin/synogetkeyvalue /etc.defaults/VERSION buildnumber)
smallfixnumber=$(/usr/syno/bin/synogetkeyvalue /etc.defaults/VERSION smallfixnumber)

# Show DSM full version and model
if [[ $buildphase == GM ]]; then buildphase=""; fi
if [[ $smallfixnumber -gt "0" ]]; then smallfix="-$smallfixnumber"; fi
echo -e "$model DSM $productversion-$buildnumber$smallfix $buildphase\n"


# Get StorageManager version
storagemgrver=$(/usr/syno/bin/synopkg version StorageManager)
# Show StorageManager version
if [[ $storagemgrver ]]; then echo -e "StorageManager $storagemgrver\n"; fi


# Show options used
echo "Using options: ${args[*]}"



#------------------------------------------------------------------------------
# Check latest release with GitHub API

syslog_set(){ 
    if [[ ${1,,} == "info" ]] || [[ ${1,,} == "warn" ]] || [[ ${1,,} == "err" ]]; then
        if [[ $autoupdate == "yes" ]]; then
            # Add entry to Synology system log
            /usr/syno/bin/synologset1 sys "$1" 0x11100000 "$2"
        fi
    fi
}


# Get latest release info
# Curl timeout options:
# https://unix.stackexchange.com/questions/94604/does-curl-have-a-timeout
release=$(curl --silent -m 10 --connect-timeout 5 \
    "https://api.github.com/repos/$repo/releases/latest")

# Release version
tag=$(echo "$release" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
shorttag="${tag:1}"

# Release published date
published=$(echo "$release" | grep '"published_at":' | sed -E 's/.*"([^"]+)".*/\1/')
published="${published:0:10}"
published=$(date -d "$published" '+%s')

# Today's date
now=$(date '+%s')

# Days since release published
age=$(((now - published)/(60*60*24)))


# Get script location
# https://stackoverflow.com/questions/59895/
source=${BASH_SOURCE[0]}
while [ -L "$source" ]; do # Resolve $source until the file is no longer a symlink
    scriptpath=$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )
    source=$(readlink "$source")
    # If $source was a relative symlink, we need to resolve it
    # relative to the path where the symlink file was located
    [[ $source != /* ]] && source=$scriptpath/$source
done
scriptpath=$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )
scriptfile=$( basename -- "$source" )
echo "Running from: ${scriptpath}/$scriptfile"

# Warn if script located on M.2 drive
scriptvol=$(echo "$scriptpath" | cut -d"/" -f2)
vg=$(lvdisplay | grep /volume_"${scriptvol#volume}" | cut -d"/" -f3)
md=$(pvdisplay | grep -B 1 -E '[ ]'"$vg" | grep /dev/ | cut -d"/" -f3)
if cat /proc/mdstat | grep "$md" | grep nvme >/dev/null; then
    echo -e "${Yellow}WARNING${Off} Don't store this script on an NVMe volume!"
fi


cleanup_tmp(){ 
    cleanup_err=

    # Delete downloaded .tar.gz file
    if [[ -f "/tmp/$script-$shorttag.tar.gz" ]]; then
        if ! rm "/tmp/$script-$shorttag.tar.gz"; then
            echo -e "${Error}ERROR${Off} Failed to delete"\
                "downloaded /tmp/$script-$shorttag.tar.gz!" >&2
            cleanup_err=1
        fi
    fi

    # Delete extracted tmp files
    if [[ -d "/tmp/$script-$shorttag" ]]; then
        if ! rm -r "/tmp/$script-$shorttag"; then
            echo -e "${Error}ERROR${Off} Failed to delete"\
                "downloaded /tmp/$script-$shorttag!" >&2
            cleanup_err=1
        fi
    fi

    # Add warning to DSM log
    if [[ $cleanup_err ]]; then
        syslog_set warn "$script update failed to delete tmp files"
    fi
}


if ! printf "%s\n%s\n" "$tag" "$scriptver" |
        sort --check=quiet --version-sort >/dev/null ; then
    echo -e "\n${Cyan}There is a newer version of this script available.${Off}"
    echo -e "Current version: ${scriptver}\nLatest version:  $tag"
    scriptdl="$scriptpath/$script-$shorttag"
    if [[ -f ${scriptdl}.tar.gz ]] || [[ -f ${scriptdl}.zip ]]; then
        # They have the latest version tar.gz downloaded but are using older version
        echo "You have the latest version downloaded but are using an older version"
        sleep 10
    elif [[ -d $scriptdl ]]; then
        # They have the latest version extracted but are using older version
        echo "You have the latest version extracted but are using an older version"
        sleep 10
    else
        if [[ $autoupdate == "yes" ]]; then
            if [[ $age -gt "$delay" ]] || [[ $age -eq "$delay" ]]; then
                echo "Downloading $tag"
                reply=y
            else
                echo "Skipping as $tag is less than $delay days old."
            fi
        else
            echo -e "${Cyan}Do you want to download $tag now?${Off} [y/n]"
            read -r -t 30 reply
        fi

        if [[ ${reply,,} == "y" ]]; then
            # Delete previously downloaded .tar.gz file and extracted tmp files
            cleanup_tmp

            if cd /tmp; then
                url="https://github.com/$repo/archive/refs/tags/$tag.tar.gz"
                if ! curl -JLO -m 30 --connect-timeout 5 "$url"; then
                    echo -e "${Error}ERROR${Off} Failed to download"\
                        "$script-$shorttag.tar.gz!"
                    syslog_set warn "$script $tag failed to download"
                else
                    if [[ -f /tmp/$script-$shorttag.tar.gz ]]; then
                        # Extract tar file to /tmp/<script-name>
                        if ! tar -xf "/tmp/$script-$shorttag.tar.gz" -C "/tmp"; then
                            echo -e "${Error}ERROR${Off} Failed to"\
                                "extract $script-$shorttag.tar.gz!"
                            syslog_set warn "$script failed to extract $script-$shorttag.tar.gz!"
                        else
                            # Set script sh files as executable
                            if ! chmod a+x "/tmp/$script-$shorttag/"*.sh ; then
                                permerr=1
                                echo -e "${Error}ERROR${Off} Failed to set executable permissions"
                                syslog_set warn "$script failed to set permissions on $tag"
                            fi

                            # Copy new script sh file to script location
                            if ! cp -p "/tmp/$script-$shorttag/${scriptname}.sh" "${scriptpath}/${scriptfile}";
                            then
                                copyerr=1
                                echo -e "${Error}ERROR${Off} Failed to copy"\
                                    "$script-$shorttag sh file(s) to:\n $scriptpath/${scriptfile}"
                                syslog_set warn "$script failed to copy $tag to script location"
                            fi

                            # Copy new CHANGES.txt file to script location (if script on a volume)
                            if [[ $scriptpath =~ /volume* ]]; then
                                # Set permissions on CHANGES.txt
                                if ! chmod 664 "/tmp/$script-$shorttag/CHANGES.txt"; then
                                    permerr=1
                                    echo -e "${Error}ERROR${Off} Failed to set permissions on:"
                                    echo "$scriptpath/CHANGES.txt"
                                fi

                                # Copy new CHANGES.txt file to script location
                                if ! cp -p "/tmp/$script-$shorttag/CHANGES.txt"\
                                    "${scriptpath}/${scriptname}_CHANGES.txt";
                                then
                                    if [[ $autoupdate != "yes" ]]; then copyerr=1; fi
                                    echo -e "${Error}ERROR${Off} Failed to copy"\
                                        "$script-$shorttag/CHANGES.txt to:\n $scriptpath"
                                else
                                    changestxt=" and changes.txt"
                                fi
                            fi

                            # Delete downloaded tmp files
                            cleanup_tmp

                            # Notify of success (if there were no errors)
                            if [[ $copyerr != 1 ]] && [[ $permerr != 1 ]]; then
                                echo -e "\n$tag ${scriptfile}$changestxt downloaded to: ${scriptpath}\n"
                                syslog_set info "$script successfully updated to $tag"

                                # Reload script
                                printf -- '-%.0s' {1..79}; echo  # print 79 -
                                exec "${scriptpath}/$scriptfile" "${args[@]}"
                            else
                                syslog_set warn "$script update to $tag had errors"
                            fi
                        fi
                    else
                        echo -e "${Error}ERROR${Off}"\
                            "/tmp/$script-$shorttag.tar.gz not found!"
                        #ls /tmp | grep "$script"  # debug
                        syslog_set warn "/tmp/$script-$shorttag.tar.gz not found"
                    fi
                fi
                cd "$scriptpath" || echo -e "${Error}ERROR${Off} Failed to cd to script location!"
            else
                echo -e "${Error}ERROR${Off} Failed to cd to /tmp!"
                syslog_set warn "$script update failed to cd to /tmp"
            fi
        fi
    fi
fi

rebootmsg(){ 
    # Reboot prompt
    echo -e "\n${Cyan}The Synology needs to restart.${Off}"
    echo -e "Type ${Cyan}yes${Off} to reboot now."
    echo -e "Type anything else to quit (if you will restart it yourself)."
    read -r -t 10 answer
    if [[ ${answer,,} != "yes" ]]; then exit; fi

#    # Reboot in the background so user can see DSM's "going down" message
#    reboot &
    if [[ -x /usr/syno/sbin/synopoweroff ]]; then
        /usr/syno/sbin/synopoweroff -r || reboot
    else
        reboot
    fi
}


#----------------------------------------------------------
# Check file exists

file="/usr/lib/libhwcontrol.so.1"

if [[ ! -f ${file} ]]; then
    ding
    echo -e "${Error}ERROR${Off} File not found!"
    exit 1
fi


#----------------------------------------------------------
# Restore from backup file

if [[ $restore == "yes" ]]; then
    if [[ -f ${file}.bak ]]; then

        # Check if backup size matches file size
        filesize=$(wc -c "${file}" | awk '{print $1}')
        filebaksize=$(wc -c "${file}.bak" | awk '{print $1}')
        if [[ ! $filesize -eq "$filebaksize" ]]; then
            echo -e "${Yellow}WARNING Backup file size is different to file!${Off}"
            echo "Do you want to restore this backup? [yes/no]:"
            read -r answer
            if [[ $answer != "yes" ]]; then
                exit
            fi
        fi

        # Restore from backup
        if cp "$file".bak "$file" ; then
            echo "Successfully restored from backup."
            rebootmsg
            exit
        else
            ding
            echo -e "${Error}ERROR${Off} Backup failed!"
            exit 1
        fi
    else
        ding
        echo -e "${Error}ERROR${Off} Backup file not found!"
        exit 1
    fi
fi


#----------------------------------------------------------
# Backup file

if [[ ! -f ${file}.bak ]]; then
    if cp "$file" "$file".bak ; then
        echo "Backup successful."
    else
        ding
        echo -e "${Error}ERROR${Off} Backup failed!"
        exit 1
    fi
else
    # Check if backup size matches file size
    filesize=$(wc -c "${file}" | awk '{print $1}')
    filebaksize=$(wc -c "${file}.bak" | awk '{print $1}')
    if [[ ! $filesize -eq "$filebaksize" ]]; then
        echo -e "${Yellow}WARNING Backup file size is different to file!${Off}"
        echo "Maybe you've updated DSM since last running this script?"
        echo "Renaming file.bak to file.bak.old"
        mv "${file}.bak" "$file".bak.old
        if cp "$file" "$file".bak ; then
            echo "Backup successful."
        else
            ding
            echo -e "${Error}ERROR${Off} Backup failed!"
            exit 1
        fi
    else
        echo "File already backed up."
    fi
fi


#----------------------------------------------------------
# Edit file

findbytes(){ 
    # Get decimal position of matching hex string
    match=$(od -v -t x1 "$1" |
    sed 's/[^ ]* *//' |
    tr '\012' ' ' |
    grep -b -i -o "$hexstring" |
    cut -d ':' -f 1 |
    xargs -I % expr % / 3)

    # Convert decimal position of matching hex string to hex
    array=("$match")
    if [[ ${#array[@]} -gt "1" ]]; then
        num="0"
        while [[ $num -lt "${#array[@]}" ]]; do
            poshex=$(printf "%x" "${array[$num]}")
            echo "${array[$num]} = $poshex"  # debug

            seek="${array[$num]}"
            xxd=$(xxd -u -l 12 -s "$seek" "$1")
            #echo "$xxd"  # debug
            printf %s "$xxd" | cut -d" " -f1-7
            bytes=$(printf %s "$xxd" | cut -d" " -f6)
            #echo "$bytes"  # debug

            num=$((num +1))
        done
    elif [[ -n $match ]]; then
        poshex=$(printf "%x" "$match")
        echo "$match = $poshex"  # debug

        seek="$match"
        xxd=$(xxd -u -l 12 -s "$seek" "$1")
        #echo "$xxd"  # debug
        printf %s "$xxd" | cut -d" " -f1-7
        bytes=$(printf %s "$xxd" | cut -d" " -f6)
        #echo "$bytes"  # debug
    else
        bytes=""
    fi
}


# Check value in file and backup file
if [[ $check == "yes" ]]; then
    err=0

    # Check value in file
    echo -e "\nChecking value in file."
    hexstring="80 3E 00 B8 01 00 00 00 90 90 48 8B"
    findbytes "$file"
    if [[ $bytes == "9090" ]]; then
        echo -e "\n${Cyan}File already edited.${Off}"
    else
        hexstring="80 3E 00 B8 01 00 00 00 75 2. 48 8B"
        findbytes "$file"
        if [[ $bytes =~ "752"[0-9] ]]; then
            echo -e "\n${Cyan}File is unedited.${Off}"
        else
            echo -e "\n${Red}hex string not found!${Off}"
            err=1
        fi
    fi

    # Check value in backup file
    if [[ -f ${file}.bak ]]; then
        echo -e "\nChecking value in backup file."
        hexstring="80 3E 00 B8 01 00 00 00 75 2. 48 8B"
        findbytes "${file}.bak"
        if [[ $bytes =~ "752"[0-9] ]]; then
            echo -e "\n${Cyan}Backup file is unedited.${Off}"
        else
            hexstring="80 3E 00 B8 01 00 00 00 90 90 48 8B"
            findbytes "${file}.bak"
            if [[ $bytes == "9090" ]]; then
                echo -e "\n${Red}Backup file has been edited!${Off}"
            else
                echo -e "\n${Red}hex string not found!${Off}"
                err=1
            fi
        fi
    else
        echo "No backup file found."
    fi

    exit "$err"
fi


echo -e "\nChecking file."


# Check if the file is already edited
hexstring="80 3E 00 B8 01 00 00 00 90 90 48 8B"
findbytes "$file"
if [[ $bytes == "9090" ]]; then
    echo -e "\n${Cyan}File already edited.${Off}"
    exit
else
    # Check if the file is okay for editing
    hexstring="80 3E 00 B8 01 00 00 00 75 2. 48 8B"
    findbytes "$file"
    if [[ $bytes =~ "752"[0-9] ]]; then
        echo -e "\nEditing file."
    else
        ding
        echo -e "\n${Red}hex string not found!${Off}"
        exit 1
    fi
fi


# Replace bytes in file
posrep=$(printf "%x\n" $((0x${poshex}+8)))
if ! printf %s "${posrep}: 9090" | xxd -r - "$file"; then
    ding
    echo -e "${Error}ERROR${Off} Failed to edit file!"
    exit 1
fi


#----------------------------------------------------------
# Check if file was successfully edited

echo -e "\nChecking if file was successfully edited."
hexstring="80 3E 00 B8 01 00 00 00 90 90 48 8B"
findbytes "$file"
if [[ $bytes == "9090" ]]; then
    echo -e "File successfully edited."
    echo -e "\n${Cyan}You can now create your M.2 storage"\
        "pool in Storage Manager.${Off}"
    edited=yes
else
    ding
    echo -e "${Error}ERROR${Off} Failed to edit file!"
    exit 1
fi


#--------------------------------------------------------------------
# Enable m2 volume support - DSM 7.1 and later only

# Backup synoinfo.conf if needed
#if [[ $dsm72 == "yes" ]]; then
#if [[ $dsm71 == "yes" ]]; then
    synoinfo="/etc.defaults/synoinfo.conf"
    if [[ ! -f ${synoinfo}.bak ]]; then
        if cp "$synoinfo" "$synoinfo.bak"; then
            echo -e "\nBacked up $(basename -- "$synoinfo")" >&2
        else
            ding
            echo -e "\n${Error}ERROR 5${Off} Failed to backup $(basename -- "$synoinfo")!"
            exit 1
        fi
    fi
#fi


# Check if m2 volume support is enabled
#if [[ $dsm72 == "yes" ]]; then
#if [[ $dsm71 == "yes" ]]; then
    smp=support_m2_pool
    setting="$(/usr/syno/bin/synogetkeyvalue "$synoinfo" "$smp")"
    enabled=""
    if [[ ! $setting ]]; then
        # Add support_m2_pool="yes"
        echo 'support_m2_pool="yes"' >> "$synoinfo"
        enabled="yes"
    elif [[ $setting == "no" ]]; then
        # Change support_m2_pool="no" to "yes"
        #sed -i "s/${smp}=\"no\"/${smp}=\"yes\"/" "$synoinfo"
        /usr/syno/bin/synosetkeyvalue "$synoinfo" "$smp" "yes"
        enabled="yes"
    elif [[ $setting == "yes" ]]; then
        echo -e "\nM.2 volume support already enabled."
    fi

    # Check if we enabled m2 volume support
    setting="$(/usr/syno/bin/synogetkeyvalue "$synoinfo" "$smp")"
    if [[ $enabled == "yes" ]]; then
        if [[ $setting == "yes" ]]; then
            echo -e "\nEnabled M.2 volume support."
        else
            echo -e "\n${Error}ERROR${Off} Failed to enable m2 volume support!"
        fi
    fi
#fi


# Enable creating M.2 storage pool and volume in Storage Manager
# for currently installed NVMe drives
for nvme in /run/synostorage/disks/nvme*; do
    if [[ -f "${nvme}/m2_pool_support" ]]; then
        echo -n 1 > "${nvme}/m2_pool_support"
    fi
done


#----------------------------------------------------------
# Reboot

# Only show reboot message if $noreboot not set and we patched file
if [[ $noreboot != "yes" ]] && [[ $edited == "yes" ]]; then
    rebootmsg
fi

exit

