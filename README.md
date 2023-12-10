# Synology enable M2 volume

<a href="https://github.com/007revad/Synology_enable_M2_volume/releases"><img src="https://img.shields.io/github/release/007revad/Synology_enable_M2_volume.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_enable_M2_volumeh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views&edge_flat=false"/></a>
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

### Description

Enable creating volumes with non-Synology M.2 drives

This script will:
- Enable creating M.2 storage pools and volumes all from within Storage Manager.
- Enable Health Info for non-Synology NVMe drives (not in DSM 7.2.1 or later).

It will work for DSM 7.2 and some models running DSM 7.1.1. As for a full list of which models it will work with, I don't know yet. I do know it does work on models listed by Synology as supported for creating M.2 volumes, and some '21 and newer enterprise models.

**Confirmed working on:**

| Model        | CPU Arch | DSM version              | Works | Note |
| ------------ |----------|--------------------------|-------|------|
| **E10M20-T1** | | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
| **M2D20**    | | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
| **M2D18**    | | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
||
| DS923+       | R1000 | DSM 7.2-64570 Update 3         | yes |
| DS923+       | R1000 | DSM 7.2-64561                  | yes |
| DS923+       | R1000 | DSM 7.1.1-42962 Update 4       | yes |
| DS723+       | R1000 | DSM 7.2-64570 Update 3         | yes |
| DS423+       | Geminilake | DSM 7.1.1-42962 Update 5  | yes |
| DS3622xs+    | Broadwellnk | DSM 7.2-64570 Update 3   | **No** | M.2 panel missing in storage manager |
| DS3622xs+    | Broadwellnk | DSM 7.2-64561            | yes |
| DS3622xs+    | Broadwellnk | DSM 7.1.1-42962 Update 4 | yes |
| DS3622xs+    | Broadwellnk | DSM 7.1.1-42962 Update 1 | **No** | Use newer DSM version |
| RS4021xs+    | Broadwellnk | DSM 7.2-64570 Update 3   | **No** | M.2 panel missing in storage manager |
| RS4021xs+    | Broadwellnk | DSM 7.2-64561            | yes |
| RS4021xs+    | Broadwellnk | DSM 7.1.1-42962 Update 2 | yes |
| DS1821+      | V1000 | DSM 7.2-64570 Update 3         | yes |
| DS1821+      | V1000 | DSM 7.2-64570 Update 2         | yes |
| DS1821+      | V1000 | DSM 7.2-64570 Update 1         | yes |
| DS1821+      | V1000 | DSM 7.2-64570                  | yes |
| DS1821+      | V1000 | DSM 7.2-64561                  | yes |
| DS1621xs+    | Broadwellnk | DSM 7.2-64570 Update 3   | yes |
| DS1621xs+    | Broadwellnk | DSM 7.2-64570 Update 1   | yes |
| DS1522+      | R1000 | DSM 7.2-64561                  | yes |
| DS1522+      | R1000 | DSM 7.1.1-42962 Update 4       | **No** | Use newer DSM version |
| DS1520+      | Geminilake | DSM 7.2.1-69057           | yes |
| DS1019+      | Apollolake | DSM 7.2-64570 Update 3    | yes |
| DS1019+      | Apollolake | DSM 7.2-64570 Update 1    | yes |
| DS1019+      | Apollolake | DSM 7.2-64561             | yes |
| DS920+       | Geminilake | DSM 7.2.1-69057 Update 2  | yes |
| DS920+       | Geminilake | DSM 7.2.1-69057 Update 1  | yes |
| DS920+       | Geminilake | DSM 7.2.1-69057           | yes |
| DS920+       | Geminilake | DSM 7.2-64570 Update 3    | yes |
| DS920+       | Geminilake | DSM 7.2-64570 Update 1    | yes |
| DS920+       | Geminilake | DSM 7.2-64561             | yes |
| DS920+       | Geminilake | DSM 7.1.1-42962 Update 5  | yes |
| DS920+       | Geminilake | DSM 7.1.1-42962 Update 4  | **No** | Use newer DSM version |
| DS720+       | Geminilake | DSM 7.2.1-69057           | yes |
| DS720+       | Geminilake | DSM 7.2-64570 Update 3    | yes |
| DS720+       | Geminilake | DSM 7.2-64561             | yes |
| DS420+       | Geminilake | DSM 7.2-64561             | yes |
| DS918+       | Apollolake | DSM 7.2-64570 Update 3    | yes |
| DS918+       | Apollolake | DSM 7.2-64561             | yes |
| DS918+       | Apollolake | DSM 7.1.1-42962 Update 5  | **No** | Use newer DSM version |
| DS3617xs     | Broadwell | DSM 7.x                    | **No** | Not working with any DSM version |

### How is this different to the Synology_M2_volume script?

- **Synology_enable_M2_volume:**
    - Allows creating an M.2 storage pool and volume all from within Storage Manager with any brand M.2 drive.
    - Gives you the option of **SHR and JBOD**, as well as RAID 0, RAID 1 and Basic.
    - Enables Health Info for non-Synology NVMe drives.
    - Add drive(s) and change RAID type work from within Storage Manager.
    - RAID repair and expansion work from within Storage Manager.
    - Easy to run as there a no questions to answer.
    - Works with DSM 7.2 beta and 7.1.1 (may work with DSM 7.1 and 7.0).
    - Works with any brand M.2 drives.
    - May only work with models Synology listed as supporting M.2 volumes.
    - Does **NOT** work for M.2 drives in a M2D20, M2D18, M2D17 or E10M20-T1.
    - Does **NOT** allow creating a storage pool/volume spanning internal NVMe drives and NVMe drives in a Synology M.2 PCIe card.

- **<a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a>:**
    - Creates the synology partitions.
    - Creates the storage pool.
    - Requires you to do an Online Assemble in Storage Manager before you can create your volume.
    - A little more complicated as there are questions that you need to answer.
    - Gives you the option of Basic, RAID 0, RAID 1, **RAID 5**, **RAID 6** and **RAID 10**.    
    - Works with any DSM version.
    - Works with any brand M.2 drives.
    - Works with any Synology model that has M.2 slots or can install a Synology PCIe M.2 card.
    - Works for M.2 drives in a M2D20, M2D18, M2D17 or E10M20-T1.
    - Works for creating a storage pool/volume spanning internal NVMe drives and NVMe drives in a Synology M.2 PCIe card.

| Feature                  | Synology_enable_M2_volume                     | Synology_M2_volume                |
|--------------------------|-----------------------------------------------|-----------------------------------|
| Non-Synology M.2 drives  | Yes                                           | Yes                               |
| Ease of use              | Easy                                          | Medium                            |
| Prompts for answers      | No                                            | Yes, multiple times               |
| Online Assemble required | No                                            | DSM 7 Yes - DSM 6 No              |
| RAID levels supported    | Basic, RAID 0, RAID 1, **SHR**, **JBOD**, **RAID F1** (see Note) | Basic, RAID 0, 1, **5, 6 and 10** (see Note 2) |
| Add drive(s) to RAID     | Yes, via Storage Manager                      | No                                |
| Change RAID type         | Yes, via Storage Manager                      | No                                |
| RAID repair              | Yes, via Storage Manager                      | No                                |
| RAID expansion           | Yes, via Storage Manager                      | No                                |
| NVMe Health Info         | Yes                                           | No                                |
| DSM version              | DSM 7.2 (and 7.1.1 for some NAS models)       | Any DSM version                   |
| M.2 drive location       | Internal M.2 slots only                       | Internal M.2 and **Synology M.2 PCie cards** |
| Span internal/PCIe NVMes | No                                            | Yes                               |
| What it does             | Edits 1 file in DSM                           | Creates partitons on M.2 drive(s) |

***Note:*** RAID F1 requires a Synology model that supports RAID F1.

***Note 2:*** RAID 5 requires 3 or more NVMe drives. RAID 6 and 10 require 4 or more NVMe drives.

If you run this script then use Storage Manager to create your M.2 storage pool and volume and then run the script again with the --restore option to restore the original setting your storage pool and volume survive and the annoying notifications and warnings are gone.

Your volume also survives reboots and DSM updates.

### Download the script

See <a href=images/how_to_download_generic.png/>How to download the script</a> for the easiest way to download the script.

Do ***NOT*** save the script to a M.2 volume. The M.2 volume won't be available until after the script has run.

## How to run the script

### Running the script via SSH

**Note:** Replace /volume1/scripts/ with the path to where the script is located.
1. Run the script then reboot the Synology:
    ```YAML
    sudo -i /volume1/scripts/syno_enable_m2_volume.sh
    ```
2. Go to Storage Manager and create your M.2 storage pool and volume(s).

**Options:**
```YAML
  -c, --check           Check value in file and backup file
  -r, --restore         Restore backup to undo changes
  -n, --noreboot        Don't reboot after script has run
  -e, --email           Disable colored text in output scheduler emails
      --autoupdate=AGE  Auto update script (useful when script is scheduled)
                          AGE is how many days old a release must be before
                          auto-updating. AGE must be a number: 0 or greater
  -h, --help            Show this help message
  -v, --version         Show the script version
```

**Extra Steps:**

To get rid of <a href="images/notification.png">drive database outdated</a> notifications and <a href=images/before_running_syno_hdd_db.png>unrecognised firmware</a> warnings run <a href=https://github.com/007revad/Synology_HDD_db>Synology_HDD_db</a> which will add your drives to DSM's compatibile drive databases, and prevent the drive compatability databases being updated between DSM updates.

```YAML
sudo -i /path-to-script/syno_hdd_db.sh --noupdate
```

### What about DSM updates?

After any DSM update you will need to run this script, and the Synology_HDD_db script again. 

### Schedule the script to run at shutdown

Or you can schedule Synology_enable_M2_volume to run when the Synology shuts down and Synology_HDD_db to run when the Synology boots up, to avoid having to remember to run both scripts after a DSM update.

See <a href=how_to_schedule.md/>How to schedule a script in Synology Task Scheduler</a>

## Screenshots

Here's the result after running the script and rebooting. Note that the strorage pool is being created in Storage Manager and there's no Online Assembly needed. SHR and JBOD are also available.

<p align="center">After reboot I got some notifications saying the M.2 drives can be managed</p>
<p align="center"><img src="/images/1b-after-reboot.png"></p>

<p align="center">No M2 Storage Pool or Volume yet</p>
<p align="center"><img src="/images/2-no-m2-volume-yet.png"></p>

<p align="center">Non-Synology M.2 drives</p>
<p align="center"><img src="/images/3-non-synology-m2-drives-2.png"></p>

<p align="center">Create Storage Pool 2</p>
<p align="center"><img src="/images/4-create-storage-pool-3.png"></p>

<p align="center">I wonder if RAID 5 and SHR-2 would be available if I had four M.2 drives.</p>

<p align="center">RAID choices including SHR and JBOD</p>
<p align="center"><img src="/images/5-raid-choices-2.png"></p>

<p align="center">Select my non-Synology M.2 drives</p>
<p align="center"><img src="/images/7-select-non-synology-drives-2.png"></p>

<p align="center">We have an SHR M.2 storage pool</p>
<p align="center"><img src="/images/10-we-have-a-m2.storage-pool-2.png"></p>

<p align="center">Create Volume 2</p>
<p align="center"><img src="/images/11-create-volume-3.png"></p>

<p align="center">Finished Creating Volume 2</p>
<p align="center"><img src="/images/13-finished-3.png"></p>

**Credits**
- K4LO from the XPenology forum.
- prt1999 for pointing me to K4LO.
- capull0 for replacing bc with xargs.

