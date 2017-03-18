
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
#define MAX_MOTOR_SPEED 100
#define MOTORS_ENABLED 1
#define PRINT_SPEEDS 0

void spinMotors_forces() {

  for (int j = 0; j < 6; j++) {
    const float prop_const =  0.0000011858;
    motor_speeds(j) = sqrt(((1.0 / prop_const) * abs(motor_forces(j)))) * sign(motor_forces(j));

    // Limit motor speed to not go crazy
    if (motor_speeds(j) > MAX_MOTOR_SPEED)
      motor_speeds(j) = MAX_MOTOR_SPEED;
    else if (motor_speeds(j) < -1 * MAX_MOTOR_SPEED)
      motor_speeds(j) = -1 * MAX_MOTOR_SPEED;
  }
  spinMotors_speeds();
}

void spinMotors_speeds() {
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
    // Use Arduino serial hardware to send messages
    SerialMotors.write(communication_buffer, communication_length);
  }

}

