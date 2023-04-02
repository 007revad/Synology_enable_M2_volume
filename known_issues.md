**Known issues in DSM 7.2-64213 Beta**

***DSM 7.2-64216 Beta is okay***

1. You **MUST** let the script reboot the NAS. If you don't then you won't be able to restart the NAS from the DSM UI (it just continues showing "Restarting..." and never actually reboots).
    - If you exit the shell window without letting the script reboot the NAS you can either press the power button on the Synology or log back in via SSH, type **reboot** and press enter.
2. If you go into "Control Panel > Shared Folders" before you've rebooted the Synology the Shared Folders window will be blank.
