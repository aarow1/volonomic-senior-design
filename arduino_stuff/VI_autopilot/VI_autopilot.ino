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

///////////////////////////////////////////////////////////////////////////
// Declare functions from other files
///////////////////////////////////////////////////////////////////////////

// Functions for wireless communications
int readXbee(Quaternion q_curr);

// Functions for controls
void readUM7();
Vec6 calculateMotorForces();
void spinMotors(Vec6 motorForces);

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
  //
  //  delay(1000);
  //  Serial.println("Spinnging some motors");
  //  float mot_spd_arr[6][1] = {0, -100, -50, 50, 100, 0};
  //  Matrix<6,1,float> mot_spd(mot_spd_arr);
  //  Serial.printf("motors speeds: [%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]\n", mot_spd(0), mot_spd(1), mot_spd(2), mot_spd(3), mot_spd(4), mot_spd(5));
  //  Serial.println("spinning in 3");
  //  delay(1000);
  //  Serial.println("spinning in 2");
  //  delay(1000);
  //  Serial.println("spinning in 1");
  //  delay(1000);
  //  spinMotors(mot_spd);
  //  delay(1000);
}

void loop() {
  readUM7();
  if (readXbee()) {
    q_curr_imu = imu.q_curr;
    qinverse(q_curr_imu, q_curr_imu_inv);
    qmultiply(q_curr_vicon,q_curr_imu_inv,q_curr_shift);
  }
  
  // R0 = vicon RS = imu at that time
  // Rts = newest imu //store Rto
  qmultiply(q_curr_shift,imu.q_curr,q_curr);

  //  w_curr = imu.w_curr;
  //  motor_forces = calculateMotorForces(q_curr,q_des,w_ff,f_des,w_curr);
//  if (testQuat) {
//    q_curr(0) = q_curr_vicon(0); q_curr(1) = q_curr_vicon(1);
//    q_curr(2) = q_curr_vicon(2); q_curr(3) = q_curr_vicon(3);
//    w_curr(0) = 0; w_curr(1) = 0; w_curr(2) = 0;
//    Serial.print("q_curr main"); q_toString(q_curr);
    motor_forces = calculateMotorForces();
    Serial.printf("motors speeds: [%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]\n",
                  motor_forces(0), motor_forces(1), motor_forces(2), motor_forces(3), motor_forces(4), motor_forces(5));
//  }
  //  delay(100);
}




