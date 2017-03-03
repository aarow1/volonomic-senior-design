#ifndef QUATERNION_H
#define QUATERNION_H

#include "Arduino.h"
#include <BasicLinearAlgebra.h>

class Quaternion
{
public:
	// Quaternion entries stored in a matrix
  Matrix<4,1,double> q;

  // Instantiate standard Quaternion [1,0,0,0]
  Quaternion();

  // Instantiate Quaternion from input values
  Quaternion(double q0_, double q1_, double q2_, double q3_);

  // // Set to given values
  // void set(double q0_, double q1_, double q2_, double q3_);

  // Set to result of multiplication of two Quaternions
  
  // Set to inverse of input Quaternion
  Quaternion inverse();
  
  Quaternion conjugate();

  String toString();
};

// extern void qmultiply(Matrix<4,1> a, Matrix<4,1> b, Matrix<4,1> c);

#endif
