OAM-RaumController
===

Implementation of an knx application, which combines some [OpenKNX-Projects](https://github.com/OpenKNX) to provide an ETS programmable device. It allows a parametrization via ETS in general, this project requires ETS 5.7 or higher.

It is a PlatformIO project and needs a working ETS 5.7 (or higher) installed on the same PC.

It uses some Modules from the OpenKNX project to implement a device, which can automate a Room in a House.

For more information look into our [OpenKNX-wiki](https://github.com/OpenKNX/OpenKNX/wiki).

Reference for other OAMs
---

This project doubles as the worked example for enabling the FTC file-transfer client (remote console and
delta firmware update over the KNX bus) in an OAM: which build switches, how the ETS parameters are
injected into the Common "Erweitert" page, which module branches are required, and what the release chain
does and does not build.

Checklist to copy: [doc/FTC-Integration-TLDR.md](doc/FTC-Integration-TLDR.md)
Full write-up with the measurements and the discarded approaches: [doc/FTC-Integration.md](doc/FTC-Integration.md)
What happens to the stored programming on a firmware update with the current knx: [doc/Firmware-Update-NVM.md](doc/Firmware-Update-NVM.md)
What changed per release: [CHANGELOG.md](CHANGELOG.md)

Thanks to all, who made this project successful.
