// File to store all of the necessary code for reading messages sent via xbee


int pktIdx = 0;
int state = 0;
int i = 0;
bool fin = 0;
enum {PKT_START, Q_CURR, Q_DES, W_DES, F_DES, PKT_END};
byte START_NUM = 32;
byte END_NUM = 26;

// union magic
union {
  byte b[4];
  double f;
} u;

//temporary stored attitude(4), des att(4), des angular rates(3), des linear force (3)
double q_curr_temp[4];
double q_des_temp[4];
double w_ff_temp[3];
double f_des_temp[3];

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
        state = Q_CURR;
      }
      i = 0;
      break;

    case Q_CURR:
      Serial.println("att_curr");
      q_curr_temp[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = Q_DES;
        Serial.printf("att_curr = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      q_curr_temp[0], q_curr_temp[1], q_curr_temp[2], q_curr_temp[3]);
      }
      break;

    case Q_DES:
      Serial.println("att_des");
      q_des_temp[i] = u.f;
      i++;
      if (i >= 4) {
        i = 0;
        state = W_DES;
        Serial.printf("att_des = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      q_des_temp[0], q_des_temp[1], q_des_temp[2], q_des_temp[3]);
      }
      break;

    case W_DES:
      Serial.println("omegadot_des");
      w_ff_temp[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = F_DES;
        Serial.printf("omega_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      w_ff_temp[0], w_ff_temp[1], w_ff_temp[2]);
      }
      break;

    case F_DES:
      Serial.println("forcelin_des");
      f_des_temp[i] = u.f;
      i++;
      if (i >= 3) {
        i = 0;
        state = PKT_END;
        //        fin = 1;
        Serial.printf("forcelin_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      f_des_temp[0], f_des_temp[1], f_des_temp[2]);
      }
      break;

    case PKT_END:
      Serial.println("pkt_end");
      if (u.f == END_NUM) {
        for (int j = 0; j < 4; j++) {
          q_curr(j) = q_curr_temp[j];
          q_des(j) = q_des_temp[j];
        }
        for (int j = 0; j < 3; j++) {
          w_ff(j) = w_ff_temp[j];
          f_des(j) = f_des_temp[j];
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
