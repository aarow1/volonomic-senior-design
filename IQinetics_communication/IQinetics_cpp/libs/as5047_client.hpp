#ifndef AS5047_CLIENT_H
#define AS5047_CLIENT_H

#include "communication_interface.h"
#include "client_communication.hpp"

//TODO::Cleanup then include common_message_types and delete the below line
const uint8_t kTypeAs5047 = 56;

class As5047Client: public ClientAbstract{
  public:
    As5047Client(uint8_t obj_idn):
      ClientAbstract( kTypeAs5047, obj_idn),
      position_(      kTypeAs5047, obj_idn, kSubPosition)
      {};
      
    // Client Entries
    ClientEntry<float>    position_;

    void ReadMsg(CommunicationInterface& com, 
      uint8_t* rx_data, uint8_t rx_length)
    {
      static const uint8_t kEntryLength = kSubPosition+1;
      static ClientEntryAbstract* entry_array[kEntryLength] = {
        &position_
      };
      
      ParseMsg(rx_data, rx_length, entry_array, kEntryLength);
    }    
    
  private:
    static const uint8_t kSubPosition  = 0;
};

#endif // AS5047_CLIENT_H
