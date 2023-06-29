Synology says Immutable Snapshots are only available on '20 series and newer models. 
https://kb.synology.com/en-br/DSM/tutorial/which_synology_nas_models_support_WriteOnce_and_secure_snapshots

But we can enable them on other models that are using DSM 7.2 by running the following command:

```YAML
sudo synosetkeyvalue /etc.defaults/synoinfo.conf support_worm yes
```
