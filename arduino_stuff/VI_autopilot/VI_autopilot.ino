#include <XBee.h>
#include <BasicLinearAlgebra.h>
#include <UM7.h>

////////////////////////////////////////////////////////////////////////////
// Declare stuff
////////////////////////////////////////////////////////////////////////////

// Stuff from xbee
//curent attitude(4), des att(4), des angular rates(3), des linear force (3)
float att_curr[4];
float att_des[4];
float omegadot_des[3];
float forcelin_des[3];
Matrix<6, 1, double> motor_forces;

#define Quaternion Matrix<4,1,double>

#define SerialXbee Serial1
XBee xbee = XBee();

#define SerialUM7 Serial2
UM7 imu;

const int ledPin = 13;

///////////////////////////////////////////////////////////////////////////
// Declare functions from other files
///////////////////////////////////////////////////////////////////////////

// Functions for wireless communications
void readXbee();

// Functions for controls
void readUM7();
void calculateMotorForces();

///////////////////////////////////////////////////////////////////////////
// Autopilot code
///////////////////////////////////////////////////////////////////////////

void setup() {
  Serial.begin(9600); //USB
  Serial1.begin(9600); //XBee
  Serial2.begin(115200); //imu
  xbee.setSerial(Serial1);

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  Serial.println("teensy ready");
}

void loop() {
  readXbee();
  readUM7();
  calculateMotorForces();
  spinMotors(x);
}




