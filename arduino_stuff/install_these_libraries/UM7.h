#ifndef UM7_H
#define UM7_H

#if defined(ARDUINO) && ARDUINO >= 100
#include "Arduino.h"
#else
#include "WProgram.h"
#endif

#include <stdlib.h>
// #include <Quaternion.h>
#include <BasicLinearAlgebra.h>

class UM7{
public:
	short roll_s, pitch_s, yaw_s, roll_rate_s, pitch_rate_s, yaw_rate_s;
	double roll, pitch, yaw, roll_rate, pitch_rate, yaw_rate;
	Matrix<3,1,float> w_curr;
  
	short quat_a_s, quat_b_s, quat_c_s, quat_d_s;
  	Matrix<4,1,double> q_curr;

  	int debug;
	
	UM7();
	
	bool encode(byte c);
	
private:

	int state;
	
	enum {STATE_ZERO,STATE_S,STATE_SN,STATE_SNP,STATE_PT,STATE_DATA,STATE_CHK1,STATE_CHK0};
	
	byte packet_type;
	byte address;
	bool packet_is_batch;
	byte batch_length;
	bool packet_has_data;
	byte data[30];
	byte data_length;
	byte data_index;

	byte checksum1;		// First byte of checksum
	byte checksum0;		// Second byte of checksum

	unsigned short checksum10;			// Checksum received from packet
	unsigned short computed_checksum;	// Checksum computed from bytes received
	
	int checksum(void);
	
	void save(void);
};

#endif
