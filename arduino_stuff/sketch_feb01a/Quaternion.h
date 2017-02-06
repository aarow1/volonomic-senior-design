#ifndef QUATERNION_H
#define QUATERNION_H

#include "Arduino.h"

class Quaternion
{
public:
	// Quaternion entries stored in an array
  float q[4];

  // Instantiate standard Quaternion [1,0,0,0]
  Quaternion();

  // Instantiate Quaternion from input values
  Quaternion(int q0, int q1, int q2, int q3);

  // Return Quaternion inverse
  Quaternion inverse();

  // Return multiplication of two Quaternions
  Quaternion multiply(Quaternion q1, Quaternion q2);
};

#endif
