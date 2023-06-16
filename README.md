# Synology enable M2 volume

<a href="https://github.com/007revad/Synology_enable_M2_volume/releases"><img src="https://img.shields.io/github/release/007revad/Synology_enable_M2_volume.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_enable_M2_volumeh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)

### Description

Enable creating volumes with non-Synology M.2 drives

This script will:
- Enable creating M.2 storage pools and volumes all from within Storage Manager.
- Enable Health Info for non-Synology NVMe drives.

It will work for DSM 7.2 and some models running DSM 7.1.1. As for a full list of which models it will work with, I don't know yet. I do know it does work on models listed by Synology as supported for creating M.2 volumes, and some '21 and newer enterprise models.

**Confirmed working on:**

| Model        | DSM version              | Works | Note |
| ------------ |--------------------------|-------|------|
| E10M20-T1    | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
| M2D20        | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
| M2D18        | ALL | **No** | Use <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> |
| DS923+       | DSM 7.2-64561            | yes |
| DS923+       | DSM 7.1.1-42962 Update 4 | yes |
| DS423+       | DSM 7.1.1-42962 Update 5 | yes |
| DS3622xs+    | DSM 7.2-64561            | yes |
| DS3622xs+    | DSM 7.1.1-42962 Update 4 | yes |
| RS4021xs+    | DSM 7.2-64561            | yes |
| RS4021xs+    | DSM 7.1.1-42962 Update 2 | yes |
| DS1821+      | DSM 7.2-64561            | yes |
| DS1821+      | DSM 7.1.1-42962 Update 4 | ? |
| DS1522+      | DSM 7.2-64561            | yes |
| DS1522+      | DSM 7.1.1-42962 Update 4 | **No** | Use newer DSM version |
| DS1019+      | DSM 7.2-64561            | yes |
| DS920+       | DSM 7.2-64561            | yes |
| DS920+       | DSM 7.1.1-42962 Update 5 | yes |
| DS920+       | DSM 7.1.1-42962 Update 4 | **No** | Use newer DSM version |
| DS918+       | DSM 7.2-64561            | yes |
| DS918+       | DSM 7.1.1-42962 Update 5 | **No** | Use newer DSM version |
| DS720+       | DSM 7.2-64561            | yes |

### How is this different to the <a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a> script?

- **Synology_enable_M2_volume:**
    - Allows creating an M.2 storage pool and volume all from within Storage Manager with any brand M.2 drive.
    - Gives you the option of **SHR and JBOD**, as well as RAID 0, RAID 1 and Basic. And **maybe RAID 5 and SHR-2 if you have 4 M.2 drives**.
    - Enables Health Info for non-Synology NVMe drives.
    - Add drive(s) and change RAID type work from within Storage Manager.
    - RAID repair and expansion work from within Storage Manager.
    - Easy to run as there a no questions to answer.
    - Works with DSM 7.2 beta and 7.1.1 (may work with DSM 7.1 and 7.0).
    - Works with any brand M.2 drives.
    - May only work with models Synology listed as supporting M.2 volumes.
    - Does **NOT** work for M.2 drives in a M2D20, M2D18 or E10M20-T1.

- **<a href="https://github.com/007revad/Synology_M2_volume">Synology_M2_volume</a>:**
    - Creates the synology partitions.
    - Creates the storage pool.
    - Requires you to do an Online Assemble in Storage Manager before you can create your volume.
    - A little more complicated as there are questions that you need to answer.
    - Gives you the option of Basic, RAID 0, RAID 1 and **RAID 5**.
    - Works with any DSM version.
    - Works with any brand M.2 drives.
    - Works with any Synology model that has M.2 slots or can install a PCIe M.2 card.
    - Works for M.2 drives in a M2D20, M2D18 or E10M20-T1.

| Feature                  | Synology_enable_M2_volume                     | Synology_M2_volume                |
|--------------------------|-----------------------------------------------|-----------------------------------|
| Non-Synology M.2 drives  | Yes                                           | Yes                               |
| Ease of use              | Easy                                          | Medium                            |
| Prompts for answers      | No                                            | Yes, multiple times               |
| Online Assemble required | No                                            | DSM 7 Yes - DSM 6 No              |
| RAID levels supported    | Basic, RAID 0, RAID 1, **SHR**, **JBOD**, **RAID F1** (see Note) | Basic, RAID 0, RAID 1, **RAID 5** |
| Add drive(s) to RAID     | Yes, via Storage Manager                      | No                                |
| Change RAID type         | Yes, via Storage Manager                      | No                                |
| RAID repair              | Yes, via Storage Manager                      | No                                |
| RAID expansion           | Yes, via Storage Manager                      | No                                |
| NVMe Health Info         | Yes                                           | No                                |
| DSM version              | DSM 7.2 beta and 7.1.1, and maybe DSM 7.1 and 7.0 | Any DSM version                 |
| Synology Models          | Maybe only models listed as supported by Synology | Any with M.2 slots or M.2 cards |
| What it does             | Temporarily changes 1 file in DSM             | Creates partitons on M.2 drive(s) |

***Note:*** RAID F1 requires that RAID F1 is enabled on your Synology model. See <a href="https://github.com/007revad/Synology_RAID-F1_SHR_switch">Synology_RAID-F1_SHR_switch</a>

If you run this script then use Storage Manager to create your M.2 storage pool and volume and then run the script again with the --restore option to restore the original setting your storage pool and volume survive and the annoying notifications and warnings are gone.

Your volume also survives reboots and DSM updates.

## Requirements

Because the bc command is not included in DSM you need to install **SynoCli misc. Tools** from SynoCommunity for this script to work.

1. Package Center > Settings > Package Sources > Add
2. Name: SynoCommunity
3. Location: `https://packages.synocommunity.com/`
4. Click OK and OK again.
5. Click Community on the left.
6. Install **SynoCli misc. Tools**

### Download the script

See <a href=images/how_to_download_generic.png/>How to download the script</a> for the easiest way to download the script.

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
  -c, --check      Check value in file and backup file
  -r, --restore    Restore backup to undo changes
  -h, --help       Show this help message
  -v, --version    Show the script version
```

**Extra Steps:**

To get rid of <a href="images/notification.png">drive database outdated</a> notifications and <a href=images/before_running_syno_hdd_db.png>unrecognised firmware</a> warnings run <a href=https://github.com/007revad/Synology_HDD_db>Synology_HDD_db</a> which will add your drives to DSM's compatibile drive databases, and prevent the drive compatability databases being updated between DSM updates.

```YAML
sudo -i /path-to-script/syno_hdd_db.sh --noupdate
```

### What about DSM updates?

After any DSM update you will need to run this script, and the Synology_HDD_db script again. 

### Schedule the script to run at shutdown

Or you can schedule both Synology_enable_M2_volume and Synology_HDD_db to run when the Synology shuts down, to avoid having to remember to run both scripts after a DSM update.

See <a href=how_to_schedule.md/>How to schedule a script in Synology Task Manager</a>

## Screenshots

Here's the result after running the script and rebooting. Note that the stroage pool is being created in Storage Manager and there's no Online Assembly needed. SHR and JBOD are also available.

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
- @prt1999 for pointing me to K4LO

