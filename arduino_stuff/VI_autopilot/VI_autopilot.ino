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

float quat_id[4][1] = {1,0,0,0};

Quaternion q_des(quat_id);
Quaternion q_curr_vicon(quat_id); // Attitude from vicon, read from xbee
Quaternion q_curr_imu(quat_id); // Attitude from imu, at time of reading xbee
Quaternion q_curr_imu_inv(quat_id); 
Quaternion q_curr_shift(quat_id);
Quaternion q_curr(quat_id); // Attitude merged from imu and vicon

Vec3 w_ff;
Vec3 f_des;
Vec3 w_curr;
float six_zeros[6][1] = {0,0,0,0,0,0};
Vec6 motor_forces(six_zeros);

#define SerialXbee Serial1
XBee xbee = XBee();

#define SerialUM7 Serial2
UM7 imu;

#define SerialMotors Serial3

const int ledPin = 13;

#define NORMAL_MODE 33
#define MOT_SPDS_MODE 34
byte current_mode = MOT_SPDS_MODE;

///////////////////////////////////////////////////////////////////////////
// Declare functions from other files
///////////////////////////////////////////////////////////////////////////

// Functions for wireless communications
bool readXbee(Quaternion q_curr); // Return true if XBee reads a full packet. current_mode is set there too

// Functions for controls
void readUM7();
void calculateMotorForces();  // Set motor forces based on attitude control and stuff
void spinMotors();

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

  if (readXbee() && (current_mode == NORMAL_MODE)){
    // Correct imu drift
    q_curr_imu = imu.q_curr;
    qinverse(q_curr_imu, q_curr_imu_inv);
    qmultiply(q_curr_vicon,q_curr_imu_inv,q_curr_shift);
  }
  
  //State machine
  switch (current_mode) {
    case NORMAL_MODE:
      // Adjust imu reading, comment if not flying with real vicon data
      // qmultiply(q_curr_shift,(Quaternion&)imu.q_curr,q_curr);
      q_curr = imu.q_curr;
      // Serial.print("q_curr"); q_toString(q_curr);
      // Calculate necessary motor forces
      calculateMotorForces();
      break;
    case MOT_SPDS_MODE:
      // Don't need to calculate motor forces, just use what is currently set
      break;
    default:
      break;
    }

    // Always spin motors
    spinMotors();
    // Serial.printf("motor forces: [%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]\n",
                  // motor_forces(0), motor_forces(1), motor_forces(2), motor_forces(3), motor_forces(4), motor_forces(5));
}




