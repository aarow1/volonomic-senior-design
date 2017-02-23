#include <Quaternion.h>

void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

Quaternion quat0;

void loop() {
//  Quaternion quat0 = Quaternion();

//  Serial.printf("basic quat is [%2.2f, %2.2f, %2.2f, %2.2f]\n", quat0.q0, quat0.q1, quat0.q2, quat0.q3);

//    Quaternion quat1 = Quaternion(0, 1, 0, 0);
//    Quaternion quat2 = Quaternion(0, 0, 1, 0);
//
//    Quaternion quat3;
//  
//    quat3.multiply(quat1, quat2);
//  
//    Serial.printf("[0,1,0,0] * [0,0,1,0] = [%2.2f, %2.2f, %2.2f, %2.2f]\n", quat3.q0, quat3.q1, quat3.q2, quat3.q3);

  Quaternion q = Quaternion(0.9052, -0.0298, -0.3816, -0.1850);
  Quaternion q1 = Quaternion(0.0270, 0.4063, -0.7976, -0.4450);
  Quaternion q2, q3;

  Serial.println("q              = " + q.toString()); 
  Serial.println("q.inverse()    = " + q.inverse().toString());
  Serial.println("q.conjugate()  = " + q.conjugate().toString());
  Serial.println("q.multiply(q1) = " + q.multiply(q1).toString());

  delay(1000);
  static bool led_on = 1;
  led_on = !led_on;
  digitalWrite(13, led_on);

}
