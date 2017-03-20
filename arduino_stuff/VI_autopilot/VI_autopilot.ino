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

float quat_id[4][1] = {1, 0, 0, 0}; // Identity quaternion

Quaternion q_des(quat_id);
Quaternion q_curr_vicon(quat_id); // Attitude from vicon, read from xbee
Quaternion q_curr_imu(quat_id); // Attitude from imu, at time of reading xbee
Quaternion q_curr_imu_inv(quat_id);
Quaternion q_curr_shift(quat_id);
Quaternion q_curr(quat_id); // Attitude merged from imu and vicon

float tau_att = .05;
float tau_w = 1.8;

Vec3 w_ff;
Vec3 f_des;
Vec3 w_curr;
float six_zeros[6][1] = {0, 0, 0, 0, 0, 0};
Vec6 motor_forces(six_zeros);

#define SerialXbee Serial1
#define SerialUM7 Serial2
#define SerialMotors Serial3
XBee xbee = XBee();
UM7 imu;

const int ledPin = 13;

enum {STOP_MODE, FLIGHT_MODE, NO_VICON_MODE, MOTOR_FORCES_MODE, MOTOR_SPEEDS_MODE};
int current_mode = STOP_MODE;

///////////////////////////////////////////////////////////////////////////
// Declare functions from other files, like header file
///////////////////////////////////////////////////////////////////////////

// Functions for wireless communications
bool readXbee(Quaternion q_curr); // Return true if XBee reads a full packet. current_mode is set there too

// Functions for controls
void readUM7();
void calculateMotorForces();  // Set motor forces based on attitude control and stuff
void spinMotors();

Quaternion qInverse(Quaternion q);
Quaternion qMultiply(Quaternion a, Quaternion b);
void q_toString(Quaternion q);

///////////////////////////////////////////////////////////////////////////
// Autopilot code
///////////////////////////////////////////////////////////////////////////

void setup() {
  Serial.begin(115200); //USB
  SerialXbee.begin(57600); //XBee
  SerialUM7.begin(115200); //imu
  SerialMotors.begin(115200);
  xbee.setSerial(SerialXbee);

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(1000);
  for(int led_blink = 0; led_blink < 4; led_blink++){
    digitalWrite(ledPin, HIGH);
    delay(100);
    digitalWrite(ledPin, LOW);
    delay(100);
  }
  Serial.println("teensy ready");
}

void loop() {
//  static long loop_time;
//  float loop_freq = 1000000.0 / (micros() - loop_time);
//  loop_time = micros();
//  Serial.printf("loop_freq: %2.2f\n", loop_freq);
  
  readUM7();
  q_curr = q_curr_imu;
  
  if (readXbee() && (current_mode == FLIGHT_MODE)) {
    // Correct imu drift
    q_curr_shift = qMultiply(q_curr_vicon, qInverse(q_curr_imu));
    
    // Serial.print("q_curr_shift"); q_toString(q_curr_shift);
  }

  //State machine
  switch (current_mode) {

    case STOP_MODE:
      // Serial.print("q = "); q_toString(q_curr);
      break;

    case FLIGHT_MODE:
      // Adjust imu reading, comment if not flying with real vicon data
     q_curr = qMultiply(q_curr_shift,q_curr_imu);

      // Calculate necessary motor forces
      calculateMotorForces();
      spinMotors_forces();
      break;

    case MOTOR_FORCES_MODE:
      // Don't need to calculate motor forces, just use what is currently set in forces
      spinMotors_forces();
      break;
    case MOTOR_SPEEDS_MODE:
      //Don't need to calculate anything, just use what is currently set in speeds
      spinMotors_speeds();
      break;
    case NO_VICON_MODE:
      // Calculate necessary motor forces;
      q_curr = q_curr_imu;
      calculateMotorForces();
      spinMotors_forces();
      break;

    default:
      break;
  }
}




