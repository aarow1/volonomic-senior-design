/* 
 *  IQinetics serial communication example.
 *  
 *  Turns off the LED when the motor's position is under pi.
 *  Turns on the LED when the motor's position is over pi.
 *  
 *  The circuit:
 *    LED attached from pin 13 to ground
 *    Arduino RX is directly connected to motor TX
 *    Arduino TX is directly connected to motor RX
 *    
 *  Created 2016/12/28 by Matthew Piccoli
 *  
 *  This example code is in the public domain.
 */

// Includes required for communication
// Message forming interface
#include "generic_interface.hpp"

// Client that speaks to complex motor controllers
#include "complex_motor_control_client.hpp"

// LED pin
const int kLedPin =  13;

// This buffer is for passing around messages.
// We use one buffer here to save space.
uint8_t communication_buffer[256];
// Stores length of message to send or receive
uint8_t communication_length;

// Time in milliseconds since we received a packet
unsigned long communication_time_last;

// Make a communication interface object
GenericInterface com;
// Make a complex motor control object
ComplexMotorControlClient motor_client(0);

void setup() {
  // Initialize the Serial peripheral
  Serial1.begin(115200);
  // Initialize the LED pin as an output:
  pinMode(kLedPin, OUTPUT);

  // Initialize communication time
  communication_time_last = millis();
}

void loop() {

  // Puts an absolute angle request message in the outbound com queue
  motor_client.obs_absolute_angle_.get(com);
  
  // Grab outbound messages in the com queue, store into buffer
  // If it transferred something to communication_buffer...
  if(com.GetTxBytes(communication_buffer,communication_length))
  {
    // Use Arduino serial hardware to send messages
    Serial1.write(communication_buffer,communication_length);
  }
  
  // wait a bit so as not to send massive amounts of data
  delay(100);

  // Reads however many bytes are currently available
  communication_length = Serial1.readBytes(communication_buffer, Serial1.available());
  // Puts the recently read bytes into com's receive queue
  com.SetRxBytes(communication_buffer,communication_length);

  uint8_t *rx_data;   // temporary pointer to received type+data bytes
  uint8_t rx_length;  // number of received type+data bytes
  // while we have message packets to parse
  while(com.PeekPacket(&rx_data,&rx_length))
  {
    // Remember time of received packet
    communication_time_last = millis();
    
    // Share that packet with all client objects
    motor_client.ReadMsg(com,rx_data,rx_length);

    // Once we're done with the message packet, drop it
    com.DropPacket();
  }

  // Check if we have any fresh data
  // Checking for fresh data is not required, it simply
  // lets you know if you received a message that you
  // have not yet read.
  if(motor_client.obs_absolute_angle_.IsFresh())
  {
    // Check if position is above pi
    if (motor_client.obs_absolute_angle_.get_reply() > 3.14f) {
      // turn LED on:
      digitalWrite(kLedPin, HIGH);
    } 
    else {
      // turn LED off:
      digitalWrite(kLedPin, LOW);
    }
  }

  // If we haven't heard from the motor in 250 milliseconds
  if(millis() - communication_time_last > 250)
  {
    // Toggle the LED
    // Should flash at 5 hz thanks to the delay(100) above
    digitalWrite(kLedPin, !digitalRead(kLedPin));
  }
}
