
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

Vec6 motor_speeds;
#define MAX_MOTOR_SPEED 2000
#define MOTORS_ENABLED 1
#define PRINT_SPEEDS 0

float motor_voltage = 10;

void spinMotors_forces() {

  bool saturated = 0;
  saturated = 0;
  for (int j = 0; j < 6; j++) {
    const float prop_const =  0.0000011858;
    motor_speeds(j) = sqrt(((1.0 / prop_const) * abs(motor_forces(j)))) * sign(motor_forces(j));

    // Limit motor speed to not go crazy
    if (motor_speeds(j) > MAX_MOTOR_SPEED) {
      motor_speeds(j) = MAX_MOTOR_SPEED;
      saturated = 1;
    }
    else if (motor_speeds(j) < -1 * MAX_MOTOR_SPEED) {
      motor_speeds(j) = -1 * MAX_MOTOR_SPEED;
      saturated = 1;
    }
  }

  // Serial.println(saturated);
  digitalWrite(ledPin, saturated);
  spinMotors_speeds();
}

void readVoltage();

void spinMotors_speeds() {
  readVoltage();
  
  if (MOTORS_ENABLED) {
    motor_client_0.cmd_velocity_.set(com, (int)motor_speeds(0));
    motor_client_1.cmd_velocity_.set(com, (int)motor_speeds(1));
    motor_client_2.cmd_velocity_.set(com, (int)motor_speeds(2));
    motor_client_3.cmd_velocity_.set(com, (int)motor_speeds(3));
    motor_client_4.cmd_velocity_.set(com, (int)motor_speeds(4));
    motor_client_5.cmd_velocity_.set(com, (int)motor_speeds(5));
  }

  if (PRINT_SPEEDS) {
    Serial.printf("motor_speeds = [%i,\t%i,\t%i,\t%i,\t%i,\t%i]\n",
                  (int)motor_speeds(0), (int)motor_speeds(1), (int)motor_speeds(2),
                  (int)motor_speeds(3), (int)motor_speeds(4), (int)motor_speeds(5));
  }

  if (com.GetTxBytes(communication_buffer, communication_length))
  {

    SerialMotors.write(communication_buffer, communication_length);
  }
}

void readVoltage(){  
  motor_client_4.obs_supply_volts_.get(com);
  motor_client_4.obs_velocity_.get(com);
  motor_client_4.drive_pwm_.get(com);
  
  // Reads however many bytes are currently available
  communication_length = SerialMotors.readBytes(communication_buffer, SerialMotors.available());
  
  // Puts the recently read bytes into com's receive queue
  com.SetRxBytes(communication_buffer,communication_length);

  uint8_t *rx_data;   // temporary pointer to received type+data bytes
  uint8_t rx_length;  // number of received type+data bytes
  // while we have message packets to parse
//  com.PeekPacket(&rx_data,&rx_length);
  while(com.PeekPacket(&rx_data,&rx_length))
  {    
    // Share that packet with all client objects
    motor_client_4.ReadMsg(com,rx_data,rx_length);

    // Once we're done with the message packet, drop it
    com.DropPacket();
  }
//  if(!com.PeekPacket((&rx_data,&rx_length))) Serial.println("NOT the thing");

  // Check if we have any fresh data
  // Checking for fresh data is not required, it simply
  // lets you know if you received a message that you
  // have not yet read.
  if(motor_client_4.obs_supply_volts_.IsFresh())
  {
    motor_voltage = motor_client_4.obs_supply_volts_.get_reply();
    Serial.printf("%2.2f,\t%2.2f,\t%2.2f\n", 
      motor_voltage, motor_client_4.obs_velocity_.get_reply(),motor_client_4.drive_pwm_.get_reply());
    
  }
}



