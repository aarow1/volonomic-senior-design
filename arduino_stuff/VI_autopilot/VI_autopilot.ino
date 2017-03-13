#include <XBee.h>
#include <BasicLinearAlgebra.h>
#include <UM7.h>

////////////////////////////////////////////////////////////////////////////
// Declare stuff
////////////////////////////////////////////////////////////////////////////

// Stuff from xbee
//curent attitude(4), des att(4), des angular rates(3), des linear force (3)

#define Quaternion Matrix<4,1,float>
#define Vec3 Matrix<3,1,float>
#define Vec6 Matrix<6,1,float>

// Stuff from xbee
//curent attitude(4), des att(4), des angular rates(3), des linear force (3)
Quaternion q_curr;
Quaternion q_des;
Vec3 w_ff;
Vec3 f_des;

//stuff from IMU
Vec3 w_curr;

Quaternion q; //combined q
Vec6 motor_forces;

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
Vec6 calculateMotorForces(Quaternion q_curr, Quaternion q_des, Vec3 w_ff, Vec3 f_des, Vec3 w_curr);
void spinMotors();

///////////////////////////////////////////////////////////////////////////
// Autopilot code
///////////////////////////////////////////////////////////////////////////

void setup() {
  Serial.begin(9600); //USB
  SerialXbee.begin(9600); //XBee
  SerialUM7.begin(115200); //imu
  xbee.setSerial(SerialXbee);

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  Serial.println("teensy ready");
}

void loop() {
  readXbee();
  readUM7();
  q = (imu.q_att + q_curr); //for now
  w_curr = imu.w;
  motor_forces = calculateMotorForces(q,q_des,w_ff,f_des,w_curr);
//  spinMotors();
}




