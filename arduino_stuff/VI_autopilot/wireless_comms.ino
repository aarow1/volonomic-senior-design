byte current_pkt_type;

// union magic
union {
  byte b[4];
  float f;
} u;

//temporary stored attitude(4), des att(4), des angular rates(3), des linear force (3)
float q_curr_vicon_temp[4];
float q_des_temp[4];
float w_ff_temp[3];
float f_des_temp[3];
float motor_forces_temp[6];

//temporary stored gain values
float tau_att_temp;
float tau_w_temp;

////////////////////////////////////////////////////////////////////////////////////////
// Packet Structure
//    Packets are made from entries, each is an IEEE float consisting of 4 bytes
//   PKT_START         PKT_TYPE         vars           PKT_END
// { PKT_START_ENTRY | PKT_TYPE_ENTRY | data entries | PACKET_END_ENTRY }
//
////////////////////////////////////////////////////////////////////////////////////////

#define PKT_START_ENTRY 32
#define ALL_INPUTS_TYPE 33
#define NO_VICON_TYPE 34
#define MOTOR_FORCES_TYPE 35
#define GAINS_TYPE 36
#define PKT_END_ENTRY 69

// Enumeration of next expected entry types
enum {PKT_START, PKT_TYPE, PKT_END,
      Q_CURR, Q_DES, W_DES, F_DES, MOT_SPDS, TAU_ATT, TAU_W
     };

#define DEBUG_readXbee 1

bool readXbee() {
  if (Serial1.available() > 0) {

    // Reads 1 entry from Xbee
    static int byteIdx = 0;  //keeps track of byte in number, numbers have 4 bytes
    while (byteIdx < 4) {
      u.b[byteIdx] = Serial1.read();
      byteIdx++;
    }
    byteIdx = 0;
    if (DEBUG_readXbee) Serial.printf("u.f = [%2.2f] byteIdx = %d\n", u.f, byteIdx);

    // Do the right thing with read entry
    static int expected_entry = PKT_START; // Next expected entry to be read

    switch (expected_entry) {

      // Expecting start of new packet
      case PKT_START:
        if (DEBUG_readXbee) Serial.println("pkt_start");
        if (u.f == PKT_START_ENTRY) {
          expected_entry = PKT_TYPE_ENTRY;
        }
        break;

      // Expecting packet type entry
      case PKT_TYPE_ENTRY:
        if (DEBUG_readXbee) Serial.printf("pkt_type: %i\n", u.f);
        static int current_pkt_type = u.f;

        switch (current_pkt_type) {
          case ALL_INPUTS_TYPE:   // {Q_curr_vicon[4], Q_des[4], w_ff[3], f_des[3]}
            expected_entry = Q_CURR_VICON;
            break;
          case NO_VICON_TYPE:     // {Q_des[4], w_ff[3], f_des[3]}
            expected_entry = Q_DES;
            break;
          case MOTOR_FORCES_TYPE: // {Motor_forces[6]}
            expected_entry = MOTOR_FORCES;
            break;
          case GAINS_TYPE:        // {Tau_att[1], Tau_w[1]}
            expected_entry = TAU_ATT;
            break;
          default:
            expected_entry = PKT_START;
            break;
        }
    }
    static int entryIdx;  // Tracks which entry in a data structure you're on
    entryIdx = 0; // Start at 0 for every new piece of data
    break;

    // Expecting q_curr_vicon data structure, has 4 entries
  case Q_CURR_VICON:
    if (DEBUG_readXbee) Serial.printf("q_curr_vicon entry %i: %2.2f\n", entryIdx, u.f);
    q_curr_vicon_temp[entryIdx] = u.f;
    entryIdx++;
    if (entryIdx >= 4) {
      if (DEBUG_readXbee) {
        Serial.printf("q_curr_vicon_temp = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", q_curr_vicon_temp[0], q_curr_vicon_temp[1], q_curr_vicon_temp[2], q_curr_vicon_temp[3]);
      }
      expected_entry = Q_DES;
      entryIdx = 0;
    }
    break;

    // Expecting q_des data structure, has 4 entries
  case Q_DES:
    if (DEBUG_readXbee) Serial.printf("q_des entry %i: %2.2f\n", entryIdx, u.f);
    q_des_temp[entryIdx] = u.f;
    entryIdx++;
    if (entryIdx >= 4) {
      entryIdx = 0;
      expected_entry = W_DES;
      if (DEBUG_readXbee) {
        Serial.printf("from wireless comms q_des_vicon = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      q_des_temp[0], q_des_temp[1], q_des_temp[2], q_des_temp[3]);
      }
    }
    break;

    // Expecting w_des data structure, has 3 entries
  case W_DES:
    if (DEBUG_readXbee) Serial.printf("w_des entry %i: %2.2f\n", entryIdx, u.f);
    w_ff_temp[entryIdx] = u.f;
    entryIdx++;
    if (entryIdx >= 3) {
      entryIdx = 0;
      expected_entry = F_DES;
      if (DEBUG_readXbee) {
        Serial.printf("omega_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      w_ff_temp[0], w_ff_temp[1], w_ff_temp[2]);
      }
    }
    break;

    // Expecting f_des data structure, has 3 entries
  case F_DES:
    if (DEBUG_readXbee) Serial.printf("f_des entry %i: %2.2f\n", entryIdx, u.f);
    f_des_temp[entryIdx] = u.f;
    entryIdx++;
    if (entryIdx >= 3) {
      entryIdx = 0;
      expected_entry = PKT_END;
      if (DEBUG_readXbee) {
        Serial.printf("forcelin_des = [%2.2f,\t%2.2f,\t%2.2f]\n",
                      f_des_temp[0], f_des_temp[1], f_des_temp[2]);
      }
    }
    break;

    // Expecting motor_forces data structure, has 6 entries
  case MOTOR_FORCES:
    if (DEBUG_readXbee) Serial.printf("motor_forces entry %i: %2.2f\n", entryIdx, u.f);
    motor_forces_temp[entryIdx] = u.f;
    entryIdx++;
    if (entryIdx >= 6) {
      entryIdx = 0;
      expected_entry = PKT_END;
      if (DEBUG_readXbee) {
        Serial.printf("Motor speeds are = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                      motor_forces(0), motor_forces(1), motor_forces(2), motor_forces(3), motor_forces(4), motor_forces(5));
      }
    }
    break;

    // Expecting tau_att data structure, has 1 entry
  case TAU_ATT:
    if (DEBUG_readXbee) Serial.printf("tau_att entry %2.2f\n", u.f);
    tau_att_temp = u.f;
    expected_entry = TAU_W;
    break;

    // Expecting tau_w data structure, has 1 entry
  case TAU_W:
    if (DEBUG_readXbee) Serial.printf("tau_w entry %2.2f\n", u.f);
    tau_w_temp = u.f;
    expected_entry = PKT_END;
    break;

    // Expecting end of packet, we store the variables here
  case PKT_END:
    if (u.f == PKT_END_ENTRY) {
      if (DEBUG_readXbee) Serial.printf("pkt_end entry\n");

      switch (current_pkt_type) {
        case ALL_INPUTS_TYPE:
          for (int j = 0; j < 4; j++) {
            q_curr_vicon(j) = q_curr_vicon_temp[j];
            q_des(j) = q_des_temp[j];
          }
          for (int j = 0; j < 3; j++) {
            w_ff(j) = w_ff_temp[j];
            f_des(j) = f_des_temp[j];
          }
          Serial.println("stored all_inputs packet");
          expected_entry = PKT_START;
          current_mode = FLIGHT_MODE;
          break;

        case NO_VICON_TYPE:
          for (int j = 0; j < 4; j++) {
            q_des(j) = q_des_temp[j];
          }
          for (int j = 0; j < 3; j++) {
            w_ff(j) = w_ff_temp[j];
            f_des(j) = f_des_temp[j];
          }
          Serial.println("stored no_vicon packet");
          expected_entry = PKT_START;
          current_mode = NO_VICON_MODE;
          break;
        case MOTOR_FORCES_TYPE:
          for (int j = 0; j < 6; j++) {
            motor_forces(j) = motor_forces_temp[j];
          }
          Serial.println("stored motor forces");
          expected_entry = PKT_START;
          current_mode = MOTOR_FORCES_MODE;
          break;
        case GAINS_TYPE:
          tau_att = tau_att_temp;
          tau_w = tau_w_temp;
          Serial.println("stored gains");
          expected_entry = PKT_START;
          break;
        default:
          expected_entry = PKT_START;
          break;
      }
    }
    return 1;
    break;

    // Something is unexpected, so we go back to waiting for a new packet
  default:
    expected_entry = PKT_START;
    break;
  }
}
return 0;
}
