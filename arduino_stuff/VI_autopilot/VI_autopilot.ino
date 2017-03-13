#include <XBee.h>
#include <BasicLinearAlgebra.h>
#include <UM7.h>

////////////////////////////////////////////////////////////////////////////
// Declare stuff
////////////////////////////////////////////////////////////////////////////

// Stuff from xbee
//curent attitude(4), des att(4), des angular rates(3), des linear force (3)
#define Quaternion Matrix<4,1,double>
#define Vec3 Matrix<3,1,double>
#define Vec6 Matrix<6,1,double>

Quaternion att_curr;
Quaternion att_des;
Vec3 w_ff_des;
Vec3 forcelin_des;
Vec6 motor_forces;

Quaternion q_curr;
Matrix<3, 1, double> w_ff;
Matrix<3, 1, double> f_des;
Matrix<3, 1, double> w_curr;

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
Matrix<6,1> calculateMotorForces(Quaternion q_curr, Quaternion q_des, Matrix<3,1> w_ff, Matrix<3,1> f_des, Matrix<3,1> w_curr);
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
  q_curr = (imu.q_att + att_curr); //for now
  w_curr = imu.w;
  motor_forces = calculateMotorForces(q_curr,att_des,w_ff,forcelin_des,w_curr);
  spinMotors();
}




