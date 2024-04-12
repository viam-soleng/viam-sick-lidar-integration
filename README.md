# Viam Sick Lidar Integration

Viam integration for Sick Lidar scanners

This module makes use of the drivers provided by Sick for their family of 
LIDARS. The current driver we are using can be found [here](https://github.com/SICKAG/sick_scan_xd)

The list of currently supported Lidars can be found [here](https://github.com/SICKAG/sick_scan_xd/blob/develop/REQUIREMENTS.md)

The viam module will package the driver and all necessary libraries local, removing the 
need to build any software prior to use.

## Building

To develop the module locally, first fork the module:

```
$ git clone https://github.com/<USERNAME>/viam-sick-lidar-integration
$ cd viam-sick-lidar-integration
$ make buildso
```

This will create the shared libraries and config files in the ./sickag directory

## TODO

1. Integrate SICK submodule build process
