
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
    motor_client_0.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(0)+25281)+159));
    motor_client_1.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(1)+25281)+159));
    motor_client_2.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(2)+25281)+159));
    motor_client_3.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(3)+25281)+159));
    motor_client_4.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(4)+25281)+159));
    motor_client_5.cmd_velocity_.set(com,10/121*(sqrt(1210000*motorForces(5)+25281)+159));
    if(com.GetTxBytes(communication_buffer,communication_length))
    {
      // Use Arduino serial hardware to send messages
      SerialMotors.write(communication_buffer,communication_length);
    }
    
}

