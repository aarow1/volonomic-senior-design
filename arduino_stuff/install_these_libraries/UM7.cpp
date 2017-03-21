#include "UM7.h"
#include "Arduino.h"

#define DREG_EULER_PHI_THETA 0x70	// Packet address sent from the UM7 that contains roll,pitch,yaw and rates.
#define DREG_QUAT_AB 0x6D	// Packet address sent from the UM7 that contains attitude quaternion
#define DREG_GYRO_PROC_X 0x61	// Packet address sent from the UM7 that contains attitude quaternion

UM7::UM7() : state(STATE_ZERO){
}

bool UM7::encode(byte c){
	switch(state){
	case STATE_ZERO:
		if (c == 115){
			state = STATE_S;		// Entering state S from state Zero
		} else {
			state = STATE_ZERO;
		}
		return 0;
	case STATE_S:
		if (c == 110){
			state = STATE_SN;		// Entering state SN from state S
		} else {
			state = STATE_ZERO;
		}
		return 0;
	case STATE_SN:
		if (c == 112){
			state = STATE_SNP;		// Entering state SNP from state SN.  Packet header detected.
		} else {
			state = STATE_ZERO;
		}
		return 0;
	case STATE_SNP:
		state = STATE_PT;			// Entering state PT from state SNP.  Decode packet type.
		packet_type = c;
		packet_has_data = (packet_type >> 7) & 0x01;
		packet_is_batch = (packet_type >> 6) & 0x01;
		batch_length    = (packet_type >> 2) & 0x0F;
		if (packet_has_data){
			if (packet_is_batch){
				data_length = 4 * batch_length;	// Each data packet is 4 bytes long
			} else {
				data_length = 4;
			}
		} else {
			data_length = 0;
		}  
		return 0;
	case STATE_PT:
		state = STATE_DATA;		// Next state will be READ_DATA.  Save address to memory. (eg 0x70 for a DREG_EULER_PHI_THETA packet)
		address = c;
		data_index = 0;
		return 0;
	case STATE_DATA:			//  Entering state READ_DATA.  Stgyro_y in state until all data is read.
		data[data_index] = c;
		data_index++;
		if (data_index >= data_length){
			state = STATE_CHK1;	//  Data read completed.  Next state will be CHK1
		}
		return 0;
	case STATE_CHK1:			// Entering state CHK1.  Next state will be CHK0
		state = STATE_CHK0;
		checksum1 = c;
		return 0;
	case STATE_CHK0: 				
		state = STATE_ZERO;		// Entering state CHK0.  Next state will be state Zero.
		checksum0 = c;
		return checksum();
	default:
	  return 0;
	}
}

int UM7::checksum(){
	checksum10  = checksum1 << 8;	// Combine checksum1 and checksum0
	checksum10 |= checksum0;
	computed_checksum = 's' + 'n' + 'p' + packet_type + address;
	for (int i = 0; i < data_length; i++){
		computed_checksum += data[i];
	}
	if (checksum10 == computed_checksum){
		save();
		return 1;
	} else {
		return 0;
	}
}

void UM7::save(){
	switch(address){
	case DREG_EULER_PHI_THETA :		// data[6] and data[7] are unused.
		if(packet_is_batch){
			roll_s = data[0] << 8;
			roll_s |= data[1];
			pitch_s = data[2] << 8;
			pitch_s |= data[3];
			yaw_s = data[4] << 8;
			yaw_s |= data[5];

      		roll  = roll_s / 91.02222;
      		pitch = pitch_s / 91.02222;
      		yaw   = yaw_s / 91.02222;

			roll_rate_s = data[8] << 8;
			roll_rate_s |= data[9];
			pitch_rate_s = data[10] << 8;
			pitch_rate_s |= data[11];
			yaw_rate_s = data[12] << 8;
			yaw_rate_s |= data[13];

			roll_rate = roll_rate_s / 16.0;
			pitch_rate = pitch_rate_s / 16.0;
			yaw_rate = yaw_rate_s / 16.0;

			// w_curr(0) = roll_rate;
			// w_curr(1) = pitch_rate;
			// w_curr(2) = yaw_rate;
		}
		break;
  case DREG_QUAT_AB :
    if(packet_is_batch) {

      quat_a_s = (data[0] << 8) + data[1];
      quat_b_s = (data[2] << 8) + data[3];
      quat_c_s = (data[4] << 8) + data[5];
      quat_d_s = (data[6] << 8) + data[7];

      q_curr(0) = quat_a_s / 29789.09091;
      q_curr(1) = quat_b_s / 29789.09091;
      q_curr(2) = quat_c_s / 29789.09091;
      q_curr(3) = quat_d_s / 29789.09091;
    }
    break;

   case DREG_GYRO_PROC_X :
    if(packet_is_batch) {
    	static float gyro_x; 
    	static float gyro_y; 
    	static float gyro_z;
    	static float AccTime;

    	*((byte*)(&gyro_x)) = data[3];
        *((byte*)(&gyro_x) + 1) = data[2];
        *((byte*)(&gyro_x) + 2) = data[1];
        *((byte*)(&gyro_x) + 3) = data[0];

        *((byte*)(&gyro_y)) = data[7];
        *((byte*)(&gyro_y) + 1) = data[6];
        *((byte*)(&gyro_y) + 2) = data[5];
        *((byte*)(&gyro_y) + 3) = data[4];

        *((byte*)(&gyro_z)) = data[11];
        *((byte*)(&gyro_z) + 1) = data[10];
        *((byte*)(&gyro_z) + 2) = data[9];
        *((byte*)(&gyro_z) + 3) = data[8];

        *((byte*)(&AccTime)) = data[15];
        *((byte*)(&AccTime) + 1) = data[14];
        *((byte*)(&AccTime) + 2) = data[13];
        *((byte*)(&AccTime) + 3) = data[12];
    	// debug = sizeof(data);

    	const float pi = 3.14159265358979323846264338327950288419716939937;
    	w_curr(0) = gyro_x * (2 * pi / 360.0); 
    	w_curr(1) = gyro_y * (2 * pi / 360.0);
    	w_curr(2) = gyro_z * (2 * pi / 360.0);

     //  w_curr(0) = *(float *)(&data[0]);
     //  w_curr(1) = *(float *)(&data[4]);
     //  w_curr(2) = *(float *)(&data[8]);
      // float gyro_time = *(float *) (&data + 12);

    }
    break;
	}
}
