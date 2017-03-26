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
Quaternion q_curr_imu_last(quat_id);
Quaternion q_curr_shift(quat_id);
Quaternion q_curr(quat_id); // Attitude merged from imu and vicon

float tau_att = 0.2;
float tau_w = 0.2;
float ki_torque = .1;


int time_delay = 50000; //in micros
bool match_delay = 0;
int idx = 0;
const int buffer_length = 100;
int buffer_idx = 0;
int time_buffer[buffer_length];
Quaternion q_curr_buffer[buffer_length];
Vec3 w_curr_buffer[buffer_length];

Vec3 w_curr_vicon;
Vec3 w_curr_imu;
Vec3 w_curr_imu_last;
Vec3 w_curr_shift;
Vec3 w_curr;
Vec3 w_ff;
Vec3 f_des;

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
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(2000);
  Serial.begin(115200); //USB
  SerialXbee.begin(57600); //XBee
  SerialUM7.begin(115200); //imu
  SerialMotors.begin(115200);
  xbee.setSerial(SerialXbee);
  for (int led_blink = 0; led_blink < 4; led_blink++) {
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
  w_curr = w_curr_imu;
  if (readXbee() && (current_mode == FLIGHT_MODE)) {
    match_delay = 0;
    idx = (buffer_idx % buffer_length);
    while (!match_delay) {
      static long curr_time = millis();
      if ((curr_time - time_buffer[idx]) <= time_delay) {
        q_curr_shift = qMultiply(q_curr_vicon, qInverse(q_curr_buffer[idx]));
        // Serial.print("q_curr_shift with buffer: "); q_toString(q_curr_buffer[idx]);
        // Serial.print("q_curr_shift: "); q_toString(qMultiply(q_curr_vicon, qInverse(q_curr_imu)));
        w_curr_shift = w_curr_buffer[idx] - w_curr_vicon;
        match_delay = 1;
      }
      else {
        idx--;
        if(idx < 0) {
          idx = buffer_length;
        }
      }
    }
  }

  static long last_loop;
  const float loop_hz = 150;
  if ((millis() - last_loop) > (1000.0 / loop_hz)) {
    last_loop = millis();
    //State machine
    switch (current_mode) {

      case STOP_MODE:
        // Serial.print("q = "); q_toString(q_curr);
      digitalWrite(ledPin, 0);
      break;
      case FLIGHT_MODE:
        // Adjust imu reading, comment if not flying with real vicon data
      q_curr = qMultiply(q_curr_shift, q_curr_imu);
      // Serial.print("q_curr"); q_toString(q_curr);
      // Serial.print("q_curr_vicon"); q_toString(q_curr_vicon);
      w_curr = w_curr_imu - w_curr_shift;
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
      calculateMotorForces();
      spinMotors_forces();
      break;

      default:
      break;
    }
  }
}




