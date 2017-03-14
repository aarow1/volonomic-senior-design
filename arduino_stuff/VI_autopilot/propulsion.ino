// Includes required for communication
// Message forming interface
#include "generic_interface.hpp"

// Client that speaks to complex motor controllers
#include "complex_motor_control_client.hpp"

// This buffer is for passing around messages.
// We use one buffer here to save space.
uint8_t communication_buffer[256];
// Stores length of message to send or receive
uint8_t communication_length;

// Make a communication interface object
GenericInterface com;
// Make a complex motor control object
ComplexMotorControlClient motor_client_0(0); //
ComplexMotorControlClient motor_client_1(1); //
ComplexMotorControlClient motor_client_2(2); //
ComplexMotorControlClient motor_client_3(3); //
ComplexMotorControlClient motor_client_4(4); //
ComplexMotorControlClient motor_client_5(5); //

//void propulsion_init(void){
//  Serial3.begin(115200);
//}

void spinMotors(Vec6 motorForces) {
   
    motor_client_0.cmd_velocity_.set(com,motorForces(0));
    motor_client_1.cmd_velocity_.set(com,motorForces(1));
    motor_client_2.cmd_velocity_.set(com,motorForces(2));
    motor_client_3.cmd_velocity_.set(com,motorForces(3));
    motor_client_4.cmd_velocity_.set(com,motorForces(4));
    motor_client_5.cmd_velocity_.set(com,motorForces(5));
    if(com.GetTxBytes(communication_buffer,communication_length))
    {
      // Use Arduino serial hardware to send messages
      SerialMotors.write(communication_buffer,communication_length);
    }
    
}

