# Synology enable M2 volume

<a href="https://github.com/007revad/Synology_enable_M2_volume/releases"><img src="https://img.shields.io/github/release/007revad/Synology_enable_M2_volume.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_enable_M2_volumeh&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>

### Description

Enable creating volumes with non-Synology M.2 drives

This script will enable creating M.2 storage pools and volumes all from within Storage Manager.

Will work for DSM 7.2 beta and DSM 7.1.1 (and possibly DSM 7.1 and maybe even DSM 7.0). As for which models it will work with, I don't know yet. I do know it does work on models listed by Synology as supported for cteating M.2 volumes.

**Confirmed working on:**

| Model        | DSM version              |
| ------------ |--------------------------|
| DS923+       | DSM 7.1.1-42962 Update 4 |
| DS1821+      | DSM 7.2-64213 Beta       |
| DS1821+      | DSM 7.1.1-42962 Update 4 |

### How to use this script ###

1. Run the script and let it reboot the Synology.
2. Go to Storage Manager and create your M.2 storage pool and volume.
3. Run the script again with the -r or --restore option to undo the changes and let it reboot the Synology:
    ```YAML
    sudo -i /volume1/scripts/syno_enable_m2_volume.sh --restore
    ```
    This prevents the <a href="/images/14-gotta-fix-this.png">drive database outdated</a> notifications and the <a href="/images/15-gotta-fix-this-too.png">unrecognised firmware version</a> warnings in Storage Manager > HDD/SSD.
4. If after the reboot if you want to check that the setting in the file was restored just run the script with -c or --check option:
    ```YAML
    sudo -i /volume1/scripts/syno_enable_m2_volume.sh --check
    ```

### The good news ###

If you run this script then use Storage Manager to create your M.2 storage pool and volume and then run the script again to restore the original setting your storage pool and volume survive and the annoying notifications and warnings are gone.

### Known issues in v.0.0.1 beta ###

1. You **MUST** let the script reboot the NAS. If you don't then you won't be able to restart the NAS from the DSM UI (it just continues showing "Restarting..." and nothing happens.
    - If you exit the shell window without letting the script reboot the NAS you can either press the power button on the Synology or log back in via SSH, type reboot and press enter.
2. If you go into "Control Panel > Shared Folders" before you've rebooted the Synology the Shared Folders window will be blank.


### To run the script ###

```YAML
sudo -i /volume1/scripts/syno_enable_m2_volume.sh
```

**Note:** Replace /volume1/scripts/ with the path to where the script is located.

**Options:**
```YAML
  -c, --check      Check value in file and backup file
  -r, --restore    Restore backup to undo changes
  -h, --help       Show this help message
  -v, --version    Show the script version
```

Here's the result after "flipping the switch" and rebooting. Note that the stroage pool is being created in Storage Manager and there's no Online Assembly needed.

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
