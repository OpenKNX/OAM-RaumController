# Changes


## v5.6.2: 2026-10-17

Firmware **5.6.2**, ETS product **5.6** (`RaumController-Release.knxprod`, application version 0x56, same
parameters and memory layout), dev product **3.7**. The generated application differs from 5.6.1 only in the
version text of the Network module (0.8 -> 0.9) and its version in the configuration-transfer script, so a
device on 5.6.1 needs the firmware alone, no ETS download.

### Update
* A device updated from 5.6.1 keeps address, application and group addresses: knx migrates the stored image to the new format and the device restarts once. The application is unloaded only when no single free block is as large as the growth of the metadata; a power cut during the in-place push or an image that does not fit leaves the device unconfigured. [doc/Firmware-Update-NVM.md](doc/Firmware-Update-NVM.md) describes the three ways the migration can take and the log line each one prints
* Tested in the host tests of OAM-IP-Interface (TP device, mask 07B0); not yet tested on a RaumController, and not for the IP build `REG1_LAN_BASE` (mask 57B0)
* From 5.5.x the application version changes as well: the address stays, the application waits for an ETS download
* Going back to 5.6.1 needs the physical address and an ETS download again: its firmware does not read the new format

### PC tool
* Breaking: the PC tool `ftc` is now `oknx`, without an alias. Run `ftc uninstall` with the old binary before installing the new one; the release carries it under `Tools/oknx/<OS>/<arch>/`
* The console command typed on the device stays `ftc`

### Build
* `Build-Release.ps1` builds oknx from `lib/OFM-FileTransferModule/oknx` and stops when that project is missing, instead of leaving the tool out of the release; `$env:OPENKNX_SKIP_HOSTCLI = "1"` leaves it out on purpose

### Documentation
* Feature: `doc/Firmware-Update-NVM.md` -- the stored image, the table layout read from a RaumController and a NeoPixel, the migration steps, the log lines and the behaviour on a power cut
* Change: both FTC documents name oknx and its paths

### Libraries
Each library carries its own CHANGELOG with the full list.
* knx: stored image migration with the in-place push; Application Program 2 on index 5; run state control (`PID_RUN_STATE_CONTROL`); serial number reads answered after the random wait; frames with an undefined control field ignored
* OGM-Common: RP2040 watchdog fires 16 to 17 s after the last loop pass instead of after about 8.4 s; the time and date objects are encoded from an initialised time block, so an encode no longer fails on stray values and leaves the previous time in the object
* OFM-Network (REG1 LAN Base only): KNX-IP is switched from the main loop only
* OFM-FileTransferModule: the oknx rename, `setpa`, `unload` by object type, `ga ask`, and the scan reads every device by default


## v5.6.1: 2026-09-15

Firmware **5.6.1**, ETS product **5.6** (`RaumController-Release.knxprod`), dev product **3.7**.
FTC (OFM-FileTransferModule) is switched on: remote console and delta firmware update over the KNX bus.
This project doubles as the worked example for other OAMs: [doc/FTC-Integration-TLDR.md](doc/FTC-Integration-TLDR.md) is the checklist, [doc/FTC-Integration.md](doc/FTC-Integration.md) the full write-up.

### ETS product
* Feature: FTC access protection reaches ETS -- `FileTransfer.share.xml` is pulled as `op:define prefix="FTM"`, ModuleType 13, and the share carries no ComObjects, so the KO layout is unchanged
* Change: the BASE channel is rebuilt in place in both product XMLs, so FTM's `ExtendedInject` block folds into the Common "Erweitert" page instead of appearing as its own top-level tab. Rebuilding replaces the producer's per-define loop, so every module's Dynamic is now listed explicitly
* Change: `op:verify` floors raised to their current library versions -- BASE 1.9, NET 0.8, SHC 0.9, BTN 0.7, BI 0.4, MTR 1.0, LOG 4.4; `FTM_VerifyVersion` added at 0.2
* Change: application version 5.5.1 -> 5.6.1 for the added parameters and the changed memory layout. ETS sees 5.5 -> 5.6 (`MAIN_ApplicationVersion` 0x55 -> 0x56), which is what lets it offer the update on a programmed device; the patch level lives in the firmware version only and never reaches ETS
* Verified: the product keeps 2994 ComObjectRef, 22688 ParameterRef, 21215 Parameter and 31219 ParameterRefRef; the channel count drops 17 -> 16, which is exactly the removed "Datei-Transfer" tab

### Device
* Feature: FTC device profile -- access protection, download, directory operations and fast upload (`OPENKNX_FTC_PROFILE_DEVICE`)
* Feature: remote console over object 160 (`OPENKNX_FTC_CONSOLE`)
* Feature: delta firmware update (`OPENKNX_FTC_DELTA_UPDATE`) -- a typical update is 56 KB over the bus in about two minutes instead of 472 KB in 13 to 17
* Feature: the TPUart driver's diagnostics are switched on -- `TPUART_BCU_HEALTH` and `TPUART_BCU_REGISTER_INFO` make `bcu` and `bcu stat` report the NCN rails, chip identity and error counters, which the FTC console now makes reachable over the bus; `TPUART_NCN_TW_AUTORESET` heals an NCN thermal warning with one guarded U_RESET and is robustness, not diagnostics
* Note: without any of these switches the module answers eleven commands with no access protection at all. The ETS stage defaults to "Immer erlaubt" and has to be set during commissioning
* Note: the TPUart diagnostics come from the driver the knx stack pins; on a stack that pins tpuart 1.1.0 none of the three switches exist

### Build
* Fix: `release_DEVICE_UP1_PM_HF`, `release_DEVICE_UP1_SEN_8X` and `release_DEVICE_UP1_TAS_4X` declared `RP2040_EXCHANGE_2MB` while the boards carry a W25Q32. The 2MB declaration left 1.75 MB unused and made the build report delta as not fitting; on 4MB the filesystem grows from 0.75 MB to 2.50 MB and delta fits
* Feature: `Build-Release.ps1` builds the ftc-cli host matrix before the preprocess step, as OAM-IP-Interface and OAM-IP-Router do -- the FTM release hook only copies the binaries, it never built them. Skip with `$env:OPENKNX_SKIP_HOSTCLI = "1"`
* Change: `include/buildtime.h` is ignored; it is rewritten on every build

### Documentation
* Feature: `doc/FTC-Integration.md` -- the full integration path with the module branches it requires, the measured flash and RAM cost per switch, the ETS placement trap that produces no warning, and the approaches that were tried and discarded with the reason
* Feature: `doc/FTC-Integration-TLDR.md` -- the same path as a checklist to copy, with the three steps marked that fail silently when they are forgotten
* Feature: this CHANGELOG; the project had none
* Change: the README points at both documents

### Libraries
* Change: `dependencies.txt` reflects the branches this build was made from, not the previous `v1` pins
* Note: `OPENKNX_FTC_CONSOLE` needs an OGM-Common that carries `_lineSink` in `Console.h`; 4MB and 8MB flash layouts need an OFM-UsbExchange whose `filesystem_size` is sector-aligned


## v5.5.1: 2026-06-21
* Change: SensorModule updated to 4.11.4

## v5.5.0: 2026-06-21
* Feature: Taster for Gira from AB-Tools
* Change: all modules updated
* Change: documentation updated

## v5.4.3: 2026-03-30
* Change: dependencies updated
* Fix: SensorModule fixes

## v5.4: 2026-03-28
* Change: modules and documentation updated
* Change: `dependencies.txt` updated -- needed to restore the matching module versions
* Note: builds against several v1dev versions because of the enum and overlap checks

## v5.1.13: 2025-10-31
* Fix: `LAN_TP_BASE` was always built as a debug build, even for release
* Fix: the TouchRound release was unintended and was removed

## v5.1.5 / 5.1.3: 2025-10-27
* Change: FileTransferModule updated
* Change: documentation updated

## 5.1.0: 2025-10-26
* Change: several v1dev modules moved to v1
* Change: Shutter module updated

## 5.0: 2025-10-26
* Change: release baseline
