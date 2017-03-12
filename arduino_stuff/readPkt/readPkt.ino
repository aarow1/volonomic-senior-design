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
bool fin = 0;
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

// union magic
union {
  byte b[4];
  float f;
} u; 

void loop() {
  if (Serial1.available() > 0) {
    readpkt();
  }
}

void readpkt() {
  while (pktIdx < 4) {
    u.b[pktIdx] = Serial1.read();
    pktIdx++;
  }
  pktIdx = 0;
   Serial.printf("u.f = [%2.2f] i = %d\n", u.f, i);
  switch (state) {
    case ATT_CURR:
      att_curr[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = ATT_DES;
        Serial.printf("att_curr = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
        att_curr[0], att_curr[1], att_curr[2], att_curr[3]);
      }
      break;

    case ATT_DES:
      att_des[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = OMEGADOT_DES;
        Serial.printf("att_des = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
        att_des[0], att_des[1], att_des[2], att_des[3]);
      }
      break;

    case OMEGADOT_DES:
      omegadot_des[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = FORCELIN_DES;
        Serial.printf("omegadot_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
        omegadot_des[0], omegadot_des[1], omegadot_des[2]);
      }
      break;

    case FORCELIN_DES:
      forcelin_des[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = ATT_CURR;
//        fin = 1;
        Serial.printf("forcelin_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
        forcelin_des[0], forcelin_des[1], forcelin_des[2]);
      }
      break;
      
    default:
//      fin = 0;
      break;
  }
//  return fin;

}


