byte current_pkt_type;

//temporary stored attitude(4), des att(4), des angular rates(3), des linear force (3)
float q_curr_vicon_temp[4];
float q_des_temp[4];
float w_curr_vicon_temp[3];
float w_ff_temp[3];
float f_des_temp[3];
float motor_forces_temp[6];
float motor_speeds_temp[6];

//temporary stored gain values
float tau_att_temp;
float tau_w_temp;
float ki_torque_temp;

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
#define MOTOR_SPEEDS_TYPE 36
#define GAINS_TYPE 37
#define STOP_TYPE 38
#define PKT_END_ENTRY 69

#define INT_16_MAX 32767.0
#define MOTOR_SPEEDS_MAX 32767.0 // Or we get rid of this
#define MOTOR_FORCES_MAX 10.0
#define GAINS_MAX 10.0
#define QUATERNION_MAX 1.0
#define W_VICON_MAX 10.0
#define W_FF_MAX 10.0
#define F_DES_MAX 10.0


// Enumeration of next expected entry types
enum {PKT_START, PKT_TYPE_ENTRY, PKT_END,
  Q_CURR_VICON, Q_DES, W_CURR_VICON, W_DES, F_DES, MOTOR_FORCES, MOTOR_SPEEDS, TAU_ATT, TAU_W, KI_TORQUE
};

#define DEBUG_readXbee 0

bool readXbee() {
  if (Serial1.available() > 0) {
    while (Serial1.available()) {

      // Reads 1 entry from Xbee

      static byte bytes[2];
      bytes[0] = Serial1.read();
      bytes[1] = Serial1.read();
      int16_t* entry_in_int = (int16_t*) bytes;
      float entry_in = (float) *entry_in_int;

      // Do the right thing with read entry
      static int expected_entry = PKT_START; // Next expected entry to be read

      switch (expected_entry) {

        // Expecting start of new packet
        case PKT_START:
        if (DEBUG_readXbee) Serial.println("pkt_start");
        if (entry_in == PKT_START_ENTRY) {
          expected_entry = PKT_TYPE_ENTRY;
        }
        break;

        // Expecting packet type entry
        case PKT_TYPE_ENTRY:
        if (DEBUG_readXbee) Serial.printf("pkt_type: %2.2f\n", entry_in);
        static int current_pkt_type;
        current_pkt_type = entry_in;

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
            case MOTOR_SPEEDS_TYPE: //{Motor_speeds[6]}
            expected_entry = MOTOR_SPEEDS;
            break;
            case GAINS_TYPE:        // {Tau_att[1], Tau_w[1], ki_torque[1]}
            expected_entry = TAU_ATT;
            break;
            case STOP_TYPE:
              expected_entry = PKT_END;  // No data, just stop doing things
              break;
              default:
              expected_entry = PKT_START;
              break;
            }
          static int entryIdx;  // Tracks which entry in a data structure you're on
          entryIdx = 0; // Start at 0 for every new piece of data
          break;

        // Expecting q_curr_vicon data structure, has 4 entries
          case Q_CURR_VICON:
//          if (DEBUG_readXbee) Serial.printf("q_curr_vicon entry %2.2f: %2.2f\n", entryIdx, entry_in);
          q_curr_vicon_temp[entryIdx] = entry_in * (QUATERNION_MAX/INT_16_MAX);
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
//          if (DEBUG_readXbee) Serial.printf("q_des entry %2.2f: %2.2f\n", entryIdx, entry_in);

          q_des_temp[entryIdx] = entry_in * (QUATERNION_MAX/INT_16_MAX);
          entryIdx++;
          if (entryIdx >= 4) {
            entryIdx = 0;
            expected_entry = W_CURR_VICON;
            if (DEBUG_readXbee) {
              Serial.printf("from wireless comms q_des_vicon = [%2.2f,\t%2.2f,\t%2.2f]\n",
                q_des_temp[0], q_des_temp[1], q_des_temp[2], q_des_temp[3]);
            }
          }
          break;
        //Expecting w_vicon data structure, has 3 entries
          case W_CURR_VICON:
//          if (DEBUG_readXbee) Serial.printf("w_curr_vicon entry %2.2f: %2.2f\n", entryIdx, entry_in);
          
          w_curr_vicon_temp[entryIdx] = entry_in * (W_VICON_MAX/INT_16_MAX);
          entryIdx++;
          if (entryIdx >= 3) {
            entryIdx = 0;
            expected_entry = W_DES;
             if (DEBUG_readXbee) {
              Serial.printf("from wireless comms w_curr_vicon = [%2.2f,\t%2.2f,\t%2.2f]\n",
                w_curr_vicon_temp[0], w_curr_vicon_temp[1], w_curr_vicon_temp[2]);
            }
          }
          break;
        // Expecting w_des data structure, has 3 entries
          case W_DES:
//          if (DEBUG_readXbee) Serial.printf("w_ff entry %2.2f: %2.2f\n", entryIdx, entry_in);
          w_ff_temp[entryIdx] = entry_in * (W_FF_MAX/INT_16_MAX);
          entryIdx++;
          if (entryIdx >= 3) {
            entryIdx = 0;
            expected_entry = F_DES;
            if (DEBUG_readXbee) {
              Serial.printf("w_ff = [%2.2f,\t%2.2f,\t%2.2f]\n",
                w_ff_temp[0], w_ff_temp[1], w_ff_temp[2]);
            }
          }
          break;

        // Expecting f_des data structure, has 3 entries
          case F_DES:
//          if (DEBUG_readXbee) Serial.printf("f_des entry %2.2f: %2.2f\n", entryIdx, entry_in);
          f_des_temp[entryIdx] = entry_in * (F_DES_MAX/INT_16_MAX);
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
          motor_forces_temp[entryIdx] = entry_in * (MOTOR_FORCES_MAX/INT_16_MAX);
//          if (DEBUG_readXbee) Serial.printf("motor_forces value %i: %2.2f\n", entryIdx, motor_forces_temp[entryIdx]);
          entryIdx++;
          if (entryIdx >= 6) {
            entryIdx = 0;
            expected_entry = PKT_END;
            if (DEBUG_readXbee) {
              Serial.printf("Motor forces are = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                motor_forces_temp[0], motor_forces_temp[1], motor_forces_temp[2],
                motor_forces_temp[3], motor_forces_temp[4], motor_forces_temp[5]);
            }
          }
          break;
        // Expecting motor_speeds data structure, has 6 entries
          case MOTOR_SPEEDS:
          motor_speeds_temp[entryIdx] = entry_in * (MOTOR_SPEEDS_MAX / INT_16_MAX);
//          if (DEBUG_readXbee) Serial.printf("motor_speeds value %i: %2.2f\n", entryIdx, motor_speeds_temp[entryIdx]);

          entryIdx++;
          if (entryIdx >= 6) {
            entryIdx = 0;
            expected_entry = PKT_END;
            if (DEBUG_readXbee) {
              Serial.printf("Motor speeds are = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                motor_speeds_temp[0], motor_speeds_temp[1], motor_speeds_temp[2],
                motor_speeds_temp[3], motor_speeds_temp[4], motor_speeds_temp[5]);
            }
          }
          break;
        // Expecting tau_att data structure, has 1 entry
          case TAU_ATT:
//          if (DEBUG_readXbee) Serial.printf("tau_att = %2.2f\n", entry_in);
          tau_att_temp = entry_in * (GAINS_MAX/INT_16_MAX);
          expected_entry = TAU_W;
          break;

        // Expecting tau_w data structure, has 1 entry
          case TAU_W:
//          if (DEBUG_readXbee) Serial.printf("tau_w = %2.2f\n", entry_in);
          tau_w_temp = entry_in * (GAINS_MAX/INT_16_MAX);
          expected_entry = KI_TORQUE;
          break;

       // Expecting ki_torque data structure, has 1 entry
          case KI_TORQUE:
//          if (DEBUG_readXbee) Serial.printf("ki_torque = %2.2f\n", entry_in);
          ki_torque_temp = entry_in * (GAINS_MAX/INT_16_MAX);
          expected_entry = PKT_END;
          break;

        // Expecting end of packet, we store the variables here
          case PKT_END:
          if (entry_in == PKT_END_ENTRY) {
            if (DEBUG_readXbee) Serial.printf("pkt_end entry\n");

            switch (current_pkt_type) {
              case ALL_INPUTS_TYPE:
              for (int j = 0; j < 4; j++) {
                q_curr_vicon(j) = q_curr_vicon_temp[j];
                q_des(j) = q_des_temp[j];
              }
              for (int j = 0; j < 3; j++) {
                w_curr_vicon(j) = w_curr_vicon_temp[j];
                w_ff(j) = w_ff_temp[j];
                f_des(j) = f_des_temp[j];
              }

              //shift w_curr_vicon into body frame
              w_curr_vicon = qRotate(w_curr_vicon,q_curr_vicon);
              if (DEBUG_readXbee) Serial.printf("w_curr_vicon rot = [%2.2f, \t%2.2f, \t%2.2f]\n",w_curr_vicon(1),w_curr_vicon(2),w_curr_vicon(3));
              if (DEBUG_readXbee) Serial.println("stored all_inputs packet");
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
              if (DEBUG_readXbee) Serial.println("stored no_vicon packet");
              current_mode = NO_VICON_MODE;
              break;
              case MOTOR_FORCES_TYPE:
              for (int j = 0; j < 6; j++) {
                motor_forces(j) = motor_forces_temp[j];
              }
              if (DEBUG_readXbee) Serial.println("stored motor forces");
              current_mode = MOTOR_FORCES_MODE;
              break;
              case MOTOR_SPEEDS_TYPE:
              for (int j = 0; j < 6; j++) {
                motor_speeds(j) = motor_speeds_temp[j];
              }
              if (DEBUG_readXbee) Serial.println("stored motor speeds");
              current_mode = MOTOR_SPEEDS_MODE;
              break;
              case GAINS_TYPE:
              tau_att = tau_att_temp;
              tau_w = tau_w_temp;
              ki_torque = ki_torque_temp;
              if (DEBUG_readXbee) {
                Serial.printf("stored gains: tau_att = %2.2f\t taw_w = %2.2f\t ki_torque = %2.2f\n", tau_att, tau_w, ki_torque);
              }
              break;
              case STOP_TYPE:
              current_mode = STOP_MODE;
              break;
              default:
              break;
            }
            expected_entry = PKT_START;
          }
          return 1;
          break;

        // Something is unexpected, so we go back to waiting for a new packet
          default:
          expected_entry = PKT_START;
          break;
        }
      }
    }
    return 0;
  }
