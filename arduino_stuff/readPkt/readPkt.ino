#include <XBee.h>
XBee xbee = XBee();

//curent attitude(4), des att(4), des angular rates(3), des linear force (3)
float att_curr[4];
float att_des[4];
float omegadot_des[3];
float forcelin_des[3];

int pktIdx = 0;
int state = 0;
int i = 0; 
enum {ATT_CURR, ATT_DES, OMEGADOT_DES, FORCELIN_DES};

const int ledPin = 13;

void setup() {
  Serial.begin(9600); //USB
  Serial1.begin(9600); //XBee
  xbee.setSerial(Serial1);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  Serial.println("teensy ready");
}

union {
  byte b[4];
  float f;
} u;

void loop() {
  if (Serial1.available() > 0) {
    c = readpkt();
    switch (state) {
    case ATT_CURR:
    att_curr[i] = c;
    i++;
    if (i >= 4) {
      i = 0; 
      state = ATT_DES;
    }
    case ATT_DES:
    att_des[i] = c;
    i++;
    if (i >= 4) {
      i = 0; 
      state = OMEGADOT_DES;
    }
    case OMEGADOT_DES:
    omegadot_des[i] = c;
    i++;
    if (i >= 3) {
      i = 0; 
      state = FORCELIN_DES;
    }
    case FORCELIN_DES:
    forcelin_des[i] = c;
    i++;
    if (i >= 3) {
      i = 0; 
      continue; 
    }
    }
  }
}

float readpkt() {
  while (pktIdx < 4) {
      u.b[pktIdx] = Serial1.read();
      pktIdx++;
    }
    pktIdx = 0;
    return u.f;
}
//int i;
//void bin2float(byte pktIn[4]) {
//  for ( i = 0 ; i < 4 ; i++ )  {
//    u.b[i] = pktIn[i] ;
//  }
//  //  u.b = pktIn;
//  Serial.println(u.f) ;
//}


