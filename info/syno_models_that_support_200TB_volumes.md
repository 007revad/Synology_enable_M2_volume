https://kb.synology.com/en-global/DSM/tutorial/Why_does_my_Synology_NAS_have_a_single_volume_size_limitation

https://kb.synology.com/en-global/DSM/tutorial/What_is_Btrfs_Peta_Volume

- 200TB volumes require 32GB or more of memory.
- Btrfs Peta volumes require 64GB ore more of memory.

| NAS requirements       | 108TB volume | 200TB volume | Peta volume |
| -----------------------|--------------|--------------|-------------|
| Required memory        |              | 32GB +       | 64GB +      |
| Required file system   |              | Btrfs        | Btrfs       |
| Required RAID type     |              | RAID 5 or 6  | RAID 6      |

Models that support 200TB volumes
  - RS2423+, RS2423RP+
  - All xs RS and DS models
  - All FS models
  - All HD models
  - All SA models

</br>

There are 2 models that support 200TB volumes and SHR, that have no supportraidgroup
  1. RS2423+
  2. RS2423RP+

| Synoinfo setting       | 108TB volume | 200TB volume | Peta volume | Model     |
| -----------------------|--------------|--------------|-------------|-----------|
| supportraidgroup       |              | "yes         | "yes"       |           |
| supportraidgroup       |              |              |             | RS2423+   |
| supportraidgroup       |              |              |             | RS2423RP+ |
