#include "OpenKNX.h"
#include "OpenKNX/Module.h"
#include "hardware.h"

struct GPIOInfo
{
    bool status = false;
    uint8_t pin;
};

class HardwareModule : public OpenKNX::Module
{

  public:
    const std::string name() override;
    const std::string version() override;
    void loop() override;
    void setup() override;

  private:
    GPIOInfo _gpio[4];
};