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
enum {PKT_START, ATT_CURR, ATT_DES, OMEGADOT_DES, FORCELIN_DES, PKT_END};
byte START_NUM = 32;
byte END_NUM = 26;

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


//temporary stored attitude(4), des att(4), des angular rates(3), des linear force (3)
float att_curr_temp[4];
float att_des_temp[4];
float omegadot_des_temp[3];
float forcelin_des_temp[3];

void readpkt() {
  while (pktIdx < 4) {
    u.b[pktIdx] = Serial1.read();
    pktIdx++;
  }
  pktIdx = 0;
  //   Serial.printf("u.f = [%2.2f] i = %d\n", u.f, i);
  switch (state) {
    case PKT_START:
      Serial.println("pkt_start");
      if (u.f == START_NUM) {
        state = ATT_CURR;
      }
      i = 0;
      break;

    case ATT_CURR:
      Serial.println("att_curr");
      att_curr_temp[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = ATT_DES;
        Serial.printf("att_curr = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      att_curr_temp[0], att_curr_temp[1], att_curr_temp[2], att_curr_temp[3]);
      }
      break;

    case ATT_DES:
      Serial.println("att_des");
      att_des_temp[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = OMEGADOT_DES;
        Serial.printf("att_des = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      att_des_temp[0], att_des_temp[1], att_des_temp[2], att_des_temp[3]);
      }
      break;

    case OMEGADOT_DES:
      Serial.println("omegadot_des");
      omegadot_des_temp[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = FORCELIN_DES;
        Serial.printf("omegadot_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      omegadot_des_temp[0], omegadot_des_temp[1], omegadot_des_temp[2]);
      }
      break;

    case FORCELIN_DES:
      Serial.println("forcelin_des");
      forcelin_des_temp[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = PKT_END;
        //        fin = 1;
        Serial.printf("forcelin_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      forcelin_des_temp[0], forcelin_des_temp[1], forcelin_des_temp[2]);
      }
      break;

    case PKT_END:
      Serial.println("pkt_end");
      if (u.f == END_NUM) {
        for (int j = 0; j < 4; j++) {
          att_curr[j] = att_curr_temp[j];
          att_des[j] = att_des_temp[j];
        }
        for (int j = 0; j < 3; j++) {
          omegadot_des[j] = omegadot_des_temp[j];
          forcelin_des[j] = forcelin_des_temp[j];
        }
        Serial.println("stored stuff");
      }

      state = PKT_START;
      break;

    default:
      Serial.println("defaul");
      state = PKT_START;
      break;
  }
  //  return fin;

}


