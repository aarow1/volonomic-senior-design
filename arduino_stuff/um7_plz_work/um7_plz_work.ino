#include <Quaternion.h>
#include <BasicLinearAlgebra.h>
#include <UM7.h>

//Connect the RX pin on the UM7 to TX1 (pin 18) on the DUE
//Connect the TX pin on the UM7 to RX1 (pin 19) on the DUE

UM7 imu;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial2.begin(115200);
  pinMode(13, OUTPUT);
}

Quaternion q_des = Quaternion();
Quaternion q_err;

void loop() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
  }

  q_err = imu.q_att.inverse().multiply(q_des);

  Serial.print("q_cur = ");
  Serial.print(imu.q_att.toString());
  Serial.print("q_des = ");
  Serial.print(q_des.toString());
  Serial.print("q_err = ");
  Serial.println(q_err.toString());

}
