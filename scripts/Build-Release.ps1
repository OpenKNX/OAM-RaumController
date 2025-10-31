# This script is just a template and has to be copied and modified per project
# This script should be called from .vscode/tasks.json with
#
#   scripts/Build-Release.ps1            - for Beta builds
#   scripts/Build-Release.ps1 Release    - for Release builds
#
# {
#     "label": "Build-Release",
#     "type": "shell",
#     "command": "scripts/Build-Release.ps1 Release",
#     "args": [],
#     "problemMatcher": [],
#     "group": "test"
# },
# {
#     "label": "Build-Beta",
#     "type": "shell",
#     "command": "scripts/Build-Release.ps1 ",
#     "args": [],
#     "problemMatcher": [],
#     "group": "test"
# }

# set product names, allows mapping of (devel) name in Project to a more consistent name in release
$settings = scripts/OpenKNX-Build-Settings.ps1 $args[0]
$releaseIndication = $settings["appRelease"]

# execute generic pre-build steps
lib/OGM-Common/scripts/setup/reusable/Build-Release-Preprocess.ps1 $args[0]
if (!$?) { exit 1 }

if (Test-Path -Path scripts/data -PathType Container) {
    Copy-Item scripts/data/* release/data/
    if (!$?) { exit 1 }
}

if ($releaseIndication -eq "Beta") {
    # build BETA firmware 

    # # build firmware for RP2040 RoomControl breakout board
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_Sensormodul_Breakout_RP2040 firmware-RaumController-Breakout-RP2040 rp2040-tp RaumController-OpenKNX-Breakout-Board-Just-for-testers
    # if (!$?) { exit 1 }

    # build firmware productive RP2040 RoomControl
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_SMARTMF_SENSORMODUL firmware-SmartMF-Sensormodul-RP2040 rp2040-tp
    if (!$?) { exit 1 }

    # Dominiks HF-PM
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_UP1_PM_HF firmware-OpenKNX-UP1-PM-HF rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for OpenKNX-REG1-Base-V1
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_REG1_BASE firmware-OpenKNX-REG1-BASE rp2040-tp
    # if (!$?) { exit 1 }
    
    # # build firmware for 1TE-RP2040-SmartMF
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_SMARTMF_1TE_REG firmware-SmartMF_1TE_REG rp2040-tp
    # if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_PresenceMultiSensor_ABSmartHouse firmware-AB-SmartHouse-PresenceMultiSensor rp2040-tp
    if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_DEVICE_PIPICO_BCU_CONNECTOR firmware-OpenKNX-PiPico-BCU-Connector rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for RP2350
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_AB_TouchRound_RP2350 firmware-AB-TouchRound-RP2350 rp2350-tp
    # if (!$?) { exit 1 }
}

# if ($releaseIndication -eq "Release") {
#     # build firmware for PiPico-BCU-Connector
#     lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_PIPICO_BCU_CONNECTOR firmware-OpenKNX-PiPico-BCU-Connector rp2040-tp
#     if (!$?) { exit 1 }
# } else
if ($releaseIndication -eq "Release") {
    # # build firmware for RP2040 RoomControl breakout board
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_Sensormodul_Breakout_RP2040 firmware-RaumController-Breakout-RP2040 rp2040-tp RaumController-Breakout-Board-Just-for-testers
    # if (!$?) { exit 1 }

    # build firmware productive RP2040 sensormodule
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_PM_HF firmware-OpenKNX-UP1-PM-HF rp2040-tp
    if (!$?) { exit 1 }

    # RP2040
    # build firmware for OpenKNX-REG1-Base-V0
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_BASE_V0 firmware-OpenKNX-REG1-BASE-V0 rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for OpenKNX-REG1-Base-V1
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_BASE firmware-OpenKNX-REG1-BASE rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for PiPico-BCU-Connector
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_PIPICO_BCU_CONNECTOR firmware-OpenKNX-PiPico-BCU-Connector rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for SEN_UP1_8XTH
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SEN_UP1_8XTH firmware-OpenKNX-UP1-SEN-8x rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for 1TE-RP2040-SmartMF
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_1TE_REG firmware-SmartMF-1TE-REG rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for RP2040 sensormodule 
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_SENSORMODUL firmware-SmartMF-Sensormodul-RP2040 rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for SmartMF-RealPresence (old version)
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_RealPresence firmware-RealPresence rp2040-tp
    # if (!$?) { exit 1 }

    # build firmware for SmartMF-RealPresence-V2
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_REALPRESENCE_V2 firmware-SmartMF-RealPresence-V2 rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for REG1_BASE_IP
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_BASE_IP firmware-REG1-BASE-IP rp2040-tp
    # if (!$?) { exit 1 }

    # build firmware for REG1_LAN_TP_BASE / ESP32+BCU
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_LAN_TP_BASE firmware-OpenKNX-REG1-LAN-TP-BASE esp32-tp
    if (!$?) { exit 1 }

    # build firmware for REG1_LAN_BASE / ESP32+DCU
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_LAN_BASE firmware-OpenKNX-REG1-LAN-BASE esp32-ip
    if (!$?) { exit 1 }




    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_RealPresence_HLK firmware-Smart-MF-RealPresence-2.0 rp2040-tp
    # if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_PresenceMultiSensor_ABSmartHouse firmware-AB-SmartHouse-PresenceMultiSensor rp2040-tp
    if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_PresenceMR16_ABSmartHouse firmware-AB-SmartHouse-PresenceMR16 rp2040-tp
    if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_PresenceWall_ABSmartHouse firmware-AB-SmartHouse-PresenceWall rp2040-tp
    if (!$?) { exit 1 }

}

# Remove unnecessary OTA upload scripts
Remove-Item -Path release/OTA-Upload-Firmware-*.ps1 -ErrorAction SilentlyContinue -Force


# execute generic post-build steps
lib/OGM-Common/scripts/setup/reusable/Build-Release-Postprocess.ps1 $args[0]
if (!$?) { exit 1 }

if (Test-Path -Path release-collection -PathType Container) {
    Copy-Item release/* release-collection/
}
