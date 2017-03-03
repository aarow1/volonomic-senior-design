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

void loop() {

  if (Serial2.available()) {
    long t_last = micros();
    int bytes_read = 0;
    while (Serial2.available()) {
      imu.encode(Serial2.read());
      bytes_read++;
    }
    Serial.printf("time spent reading was: %i\t pitch is %2.2f\t and i read %i bytes\n", 
      micros() - t_last, imu.pitch, bytes_read);
  }
}
