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

Quaternion q_des;

Quaternion q_curr_vicon; // Attitude from vicon, read from xbee
Quaternion q_curr_imu; // Attitude from imu, at time of reading xbee
Quaternion q_curr_imu_inv; Quaternion q_curr_shift;
Quaternion q_curr; // Attitude merged from imu and vicon

Vec3 w_ff;
Vec3 f_des;
Vec3 w_curr;
Vec6 motor_forces;

#define SerialXbee Serial1
XBee xbee = XBee();

#define SerialUM7 Serial2
UM7 imu;

#define SerialMotors Serial3

const int ledPin = 13;

#define NORMAL_MODE 33;
#define MOT_SPDS_MODE 34;
byte current_mode;

///////////////////////////////////////////////////////////////////////////
// Declare functions from other files
///////////////////////////////////////////////////////////////////////////

// Functions for wireless communications
int readXbee(Quaternion q_curr);

// Functions for controls
void readUM7();
Vec6 calculateMotorForces();
void spinMotors(Vec6 motorForces);


void qinverse(Quaternion& q, Quaternion& q_inv);
void qmultiply(Quaternion& a, Quaternion& b, Quaternion& c);
void q_toString(Quaternion q);

///////////////////////////////////////////////////////////////////////////
// Autopilot code
///////////////////////////////////////////////////////////////////////////

void setup() {
  Serial.begin(9600); //USB
  SerialXbee.begin(9600); //XBee
  SerialUM7.begin(115200); //imu
  SerialMotors.begin(115200);
  xbee.setSerial(SerialXbee);

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  Serial.println("teensy ready");
}

void loop() {
  readUM7();
  if (readXbee()) {
    q_curr_imu = imu.q_curr;
    qinverse(q_curr_imu, q_curr_imu_inv);
    qmultiply(q_curr_vicon,q_curr_imu_inv,q_curr_shift);
  }
  
  qmultiply(q_curr_shift,(Quaternion&)imu.q_curr,q_curr);
  motor_forces = calculateMotorForces();
    Serial.printf("motors speeds: [%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]\n",
                  motor_forces(0), motor_forces(1), motor_forces(2), motor_forces(3), motor_forces(4), motor_forces(5));
}




