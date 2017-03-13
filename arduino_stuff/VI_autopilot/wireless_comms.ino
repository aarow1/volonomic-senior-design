// File to store all of the necessary code for reading messages sent via xbee


int pktIdx = 0;
int state = 0;
int i = 0;
bool fin = 0;
enum {PKT_START, ATT_CURR, ATT_DES, OMEGA_DES, FORCELIN_DES, PKT_END};
byte START_NUM = 32;
byte END_NUM = 26;

// union magic
union {
  byte b[4];
  double f;
} u;

//temporary stored attitude(4), des att(4), des angular rates(3), des linear force (3)
double att_curr_temp[4];
double att_des_temp[4];
double w_ff_des_temp[3];
double forcelin_des_temp[3];

void readXbee() {
  if(Serial1.available() > 0) {

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
        state = OMEGA_DES;
        Serial.printf("att_des = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      att_des_temp[0], att_des_temp[1], att_des_temp[2], att_des_temp[3]);
      }
      break;

    case OMEGA_DES:
      Serial.println("omegadot_des");
      w_ff_des_temp[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = FORCELIN_DES;
        Serial.printf("omega_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      w_ff_des_temp[0], w_ff_des_temp[1], w_ff_des_temp[2]);
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
          att_curr(j) = att_curr_temp[j];
          att_des(j) = att_des_temp[j];
        }
        for (int j = 0; j < 3; j++) {
          w_ff_des(j) = w_ff_des_temp[j];
          forcelin_des(j) = forcelin_des_temp[j];
        }
        Serial.println("stored stuff");
      }

      state = PKT_START;
      break;

    default:
      Serial.println("default");
      state = PKT_START;
      break;
  }
  }

}
