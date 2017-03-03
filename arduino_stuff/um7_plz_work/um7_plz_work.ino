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
  Quaternion q_des = Quaternion();
}

void loop() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
  }

  
}
