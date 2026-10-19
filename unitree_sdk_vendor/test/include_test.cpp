#include <iostream>

#include <unitree/common/time/time_tool.hpp>
#include <unitree/robot/channel/channel_subscriber.hpp>
#include <unitree/robot/go2/sport/sport_client.hpp>
#include <unitree/idl/go2/LowState_.hpp>

int main()
{
  // Exercise a compiled SDK symbol without initializing DDS or contacting a robot.
  const auto now = unitree::common::GetCurrentTimeMicrosecond();
  if (now == 0) {
    std::cerr << "Unitree SDK2 returned an invalid timestamp\n";
    return 1;
  }
  unitree_go::msg::dds_::LowState_ state;
  (void)state;
  std::cout << "Unitree SDK2 headers, exported target, and library work\n";
  return 0;
}
