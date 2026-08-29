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

# ---- PC FileTransferClient (ftc-cli / ftc) -- built FIRST -----------------------------------
# Build the whole PC-client OS/arch matrix (Windows x86/x64/arm64, macOS x64/arm64, Linux x64/arm64/armhf)
# with a single `pio run`: the ftc-cli platformio.ini defines one env per target and a pre-build hook that
# pulls a project-local zig for the cross targets. Done up front so a client build failure aborts BEFORE the
# firmware build. Skip with: $env:OPENKNX_SKIP_HOSTCLI = "1"
# The release layout Tools/ftc-cli/<OS>/<arch>/ftc[.exe] is assembled by OGM-Common's
# Build-Release-Postprocess.ps1 via FTM's scripts/release/Post.ps1 -- nothing to copy here.
# Note: the macOS targets need a macOS host; on Linux/Windows those two envs fail by design.
$ftcCliDir = "lib/OFM-FileTransferModule/ftc-cli"
if ($env:OPENKNX_SKIP_HOSTCLI -ne "1") {
    if (Test-Path (Join-Path $ftcCliDir "platformio.ini")) {
        Write-Host "Building the PC FileTransferClient matrix (pio run -> ftc, all OS/arch)..." -ForegroundColor Cyan
        pio run -d $ftcCliDir
        if (!$?) { Write-Host "ftc-cli build failed" -ForegroundColor Red; exit 1 }
    } else {
        Write-Host "  - ftc-cli project not found ($ftcCliDir) -- skipping" -ForegroundColor DarkGray
    }
} else {
    Write-Host "Skipping PC client build (OPENKNX_SKIP_HOSTCLI)" -ForegroundColor Yellow
}

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

    # # build firmware productive RP2040 RoomControl
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_SMARTMF_SENSORMODUL firmware-SmartMF-Sensormodul-RP2040 rp2040-tp
    # if (!$?) { exit 1 }

    # Dominiks HF-PM
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_UP1_PM_HF firmware-OpenKNX-UP1-PM-HF rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for OpenKNX-REG1-Base-V1
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_REG1_BASE firmware-OpenKNX-REG1-BASE rp2040-tp
    # if (!$?) { exit 1 }
    
    # # build firmware for UP1_SEN_8X
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_SEN_8X firmware-OpenKNX-UP1-SEN-8x rp2040-tp
    # if (!$?) { exit 1 }

    # # build firmware for UP1_TAS_4X
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_TAS_4X firmware-OpenKNX-UP1-TAS-4x rp2040-tp
    # if (!$?) { exit 1 }

    # build firmware for REG1_LAN_TP_BASE / ESP32+BCU
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_LAN_TP_BASE firmware-OpenKNX-REG1-LAN-TP-BASE esp32-tpip
    # if (!$?) { exit 1 }

    # # build firmware for REG1_LAN_BASE / ESP32+DCU
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_LAN_BASE firmware-OpenKNX-REG1-LAN-BASE esp32-ip
    # if (!$?) { exit 1 }

    # # build firmware for 1TE-RP2040-SmartMF
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild  release_DEVICE_SMARTMF_1TE_REG firmware-SmartMF_1TE_REG rp2040-tp
    # if (!$?) { exit 1 }

    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_PresenceMultiSensor_ABSmartHouse firmware-AB-SmartHouse-PresenceMultiSensor rp2040-tp
    # if (!$?) { exit 1 }

    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_DEVICE_PIPICO_BCU_CONNECTOR firmware-OpenKNX-PiPico-BCU-Connector rp2040-tp
    # if (!$?) { exit 1 }

    # # build firmware for RP2350
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_AB_TouchRound_RP2350 firmware-AB-TouchRound-RP2350 rp2350-tp
    # if (!$?) { exit 1 }
}

if ($releaseIndication -eq "Release-Beta") {
    # build firmware for PiPico-BCU-Connector
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_PIPICO_BCU_CONNECTOR firmware-OpenKNX-PiPico-BCU-Connector rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for OpenKNX-REG1-Base-V1
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_DEVICE_REG1_BASE firmware-OpenKNX-REG1-BASE rp2040-tp
    if (!$?) { exit 1 }

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_PresenceMultiSensor_ABSmartHouse firmware-AB-SmartHouse-PresenceMultiSensor rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for RP2040 sensormodule 
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 -DebugBuild release_DEVICE_SMARTMF_SENSORMODUL firmware-SmartMF-Sensormodul-RP2040 rp2040-tp
    if (!$?) { exit 1 }

    # build firmware productive RP2040 sensormodule
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_PM_HF firmware-OpenKNX-UP1-PM-HF rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for 1TE-RP2040-SmartMF
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_1TE_REG firmware-SmartMF-1TE-REG rp2040-tp
    if (!$?) { exit 1 }


} elseif ($releaseIndication -eq "Release") {
    # # build firmware for RP2040 RoomControl breakout board
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_Sensormodul_Breakout_RP2040 firmware-RaumController-Breakout-RP2040 rp2040-tp RaumController-Breakout-Board-Just-for-testers
    # if (!$?) { exit 1 }

    # build firmware productive RP2040 sensormodule
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_PM_HF firmware-OpenKNX-UP1-PM-HF rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for UP1_TAS_4X
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_TAS_4X firmware-OpenKNX-UP1-TAS-4x rp2040-tp
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

    # build firmware for UP1_SEN_8X
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_UP1_SEN_8X firmware-OpenKNX-UP1-SEN-8x rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for 1TE-RP2040-SmartMF
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_1TE_REG firmware-SmartMF-1TE-REG rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for RP2040 sensormodule 
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_SENSORMODUL firmware-SmartMF-Sensormodul-RP2040 rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for SmartMF-RealPresence (waldemar version)
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_RealPresence firmware-SmartMF-RealPresence rp2040-tp
    # if (!$?) { exit 1 }

    # build firmware for SmartMF-RealPresence (sisamiwe version)
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_BOARD_SMARTMF_RealPresence_V1_2 firmware-SmartMF-RealPresence-v1.2 rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for SmartMF-RealPresence-v2
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_SMARTMF_REALPRESENCE_V2 firmware-SmartMF-RealPresence-v2 rp2040-tp
    if (!$?) { exit 1 }

    # # build firmware for REG1_BASE_IP
    # lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_BASE_IP firmware-REG1-BASE-IP rp2040-tp
    # if (!$?) { exit 1 }

    # build firmware for REG1_LAN_TP_BASE / ESP32+BCU
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_DEVICE_REG1_LAN_TP_BASE firmware-OpenKNX-REG1-LAN-TP-BASE esp32-tpip
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

    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_PresenceWallOutside_ABSmartHouse firmware-AB-SmartHouse-PresenceWall-Outside rp2040-tp
    if (!$?) { exit 1 }

    # build firmware for AB-BUT-GIR
    lib/OGM-Common/scripts/setup/reusable/Build-Step.ps1 release_AB_BUT_GIR_ABSmartHouse firmware-AB-SmartHouse-PushButtonsForGira rp2040-tp
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
