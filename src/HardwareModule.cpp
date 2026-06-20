#ifdef DEVICE_AB_BUT_GIR

#include "HardwareModule.h"
#include "Feedback.h"

const std::string HardwareModule::name()
{
    return "ROOM";
}

const std::string HardwareModule::version()
{
    return MAIN_Version;
}

void HardwareModule::setup()
{
    // GPIO
    _gpio[0].pin = BUTTON_TOP_LEFT_PIN;
    _gpio[1].pin = BUTTON_BOTTOM_LEFT_PIN;
    _gpio[2].pin = BUTTON_TOP_RIGHT_PIN;
    _gpio[3].pin = BUTTON_BOTTOM_RIGHT_PIN;

    for (uint8_t i = 0; i < 4; i++)
        pinMode(_gpio[i].pin, INPUT_PULLUP);
}

void HardwareModule::loop()
{
    bool status = 0;
    for (uint8_t i = 0; i < 4; i++)
    {
        status = (digitalRead(_gpio[i].pin) == LOW);

        if (status != _gpio[i].status)
        {
            if (status) {
                openknxFeedback.setBuzzer(true);
                openknxFeedback.setVibration(true);
            } 
            _gpio[i].status = status;
        }
    }
}

#endif