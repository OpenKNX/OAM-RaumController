#include "Logic.h"
// #include "LogicRGBOutput.h"
#include "SmartMF.h"
#include "Feedback.h"
#include "MeterModule.h"
#include "OpenKNX.h"
#ifdef WIREMODULE
    #include "OneWireDS2482.h"
    #include "WireGateway.h"
#endif
#ifdef PRESENCEMODULE
    #include "Presence.h"
#endif
#include "SensorDevices.h"
#ifdef SENSORMODULE
    #include "SensorModule.h"
#endif
#include "DfaModule.h"
#include "ShutterControllerModule.h"
#include "FunctionBlocksModule.h"
#include "FileTransferModule.h"
#include "StatusLEDModule.h"

#ifdef ARDUINO_ARCH_RP2040
    #include "UsbExchangeModule.h"
#endif

#if defined(KNX_IP_LAN) || defined(KNX_IP_WIFI)
    #include "NetworkModule.h"
#endif

#ifdef ARDUINO_ARCH_RP2040
    #pragma message "Pico Core Version: " ARDUINO_PICO_VERSION_STR
#endif

#ifdef OPENKNX_BI_GPIO_PINS
    #ifdef BI_ChannelCount
        #include "GpioBinaryInputModule.h"
    #endif
#endif

#ifdef OPENKNX_ADC_ADS_GAIN
    #include "ADCInputModule.h"
#endif

#include "Sensor.h"
#ifdef BTN_ChannelCount
    #include "VirtualButtonModule.h"
#endif

void setup()
{
#ifdef ARDUINO_ARCH_RP2040
    #ifdef ONEWIRE_5V_ENABLE
    pinMode(ONEWIRE_5V_ENABLE, OUTPUT);
    digitalWrite(ONEWIRE_5V_ENABLE, HIGH);
    #endif
#endif

    openknx.init();
    openknx.addModule(1, openknxLogic);
#ifdef WIREMODULE
    openknx.addModule(2, openknxWireGateway);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_WIRE);
#endif

#if defined(SENSORMODULE) || defined(PMMODULE)
    openknx.addModule(6, openknxSensorDevicesModule);
#endif
#ifdef SENSORMODULE
    openknx.addModule(4, openknxSensorModule);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_SENS);
#endif
#ifdef PRESENCEMODULE
    openknx.addModule(3, openknxPresenceModule);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_PM);
#endif
openknx.addModule(5, openknxFileTransferModule);
#ifdef BTN_ChannelCount
    openknx.addModule(7, openknxVirtualButtonModule);
#endif
#ifdef OPENKNX_BI_GPIO_PINS
    #ifdef BI_ChannelCount
    openknx.addModule(8, openknxGpioBinaryInputModule);
    #endif
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_BI);
#endif
#ifdef OPENKNX_ADC_ADS_GAIN
    openknx.addModule(9, openknxADCInputModule);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_ADC);
#endif
    openknx.addModule(10, openknxMeterModule);
    openknx.addModule(11, openknxDfaModule);
    openknx.addModule(12, openknxShutterControllerModule);
    openknx.addModule(13, openknxFunctionBlocksModule);
#if defined(KNX_IP_LAN) || defined(KNX_IP_WIFI)
    openknx.addModule(14, openknxNetwork);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_NET);
#endif
#ifdef ARDUINO_ARCH_RP2040
    openknx.addModule(15, openknxUsbExchangeModule);
#endif
    openknx.addModule(16, smartmf);
#if defined(OPENKNX_BUZZER_PIN) || defined(OPENKNX_VIBRATION_PIN)
    openknx.addModule(17, openknxFeedback);
#else
    openknx.unsupportedEtsModule(ETS_ModuleId_BUZZ);
#endif
    openknx.addModule(18, openknxStatusLEDModule);


openknx.setup();
}

void loop()
{
    // test
    openknx.loop();
}