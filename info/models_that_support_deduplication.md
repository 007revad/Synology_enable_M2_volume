Synology models that officially support deduplication.

https://kb.synology.com/en-br/DSM/tutorial/Which_models_support_data_deduplication

**Which Synology NAS models support data deduplication?**
- FS6400, FS3600, FS3410, FS3400
- SA6400, SA3610, SA3600, SA3410, SA3400
- RS4021xs+, RS3621xs+2, RS3621RPxs2

**Requirements:**

- Data deduplication is only supported on Synology SSDs and Btrfs volumes. You need to create a storage pool consisting entirely of Synology SSDs and then create at least one Btrfs volume.
- Data deduplication can only run when the volume status is Healthy.
- Data deduplication requires you to Enable usage detail analysis for the Btrfs volume.

**Notes:**

- At least 16 GB of memory is required to enable data deduplication.

https://kb.synology.com/en-br/DSM/help/DSM/StorageManager/volume_btrfs_dedup?version=7
