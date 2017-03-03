#include "Arduino.h"
#include "Quaternion.h"
#include <BasicLinearAlgebra.h>

// Quaternion::Quaternion(){
//   q(0) = 1;
//   q(1) = 0;
//   q(2) = 0;
//   q(3) = 0;
// }

// Quaternion::Quaternion(double q0_, double q1_, double q2_, double q3_){
//   q(0) = q0_;
//   q(1) = q1_;
//   q(2) = q2_;
//   q(3) = q3_;
// }

// void Quaternion::set(double q0_, double q1_, double q2_, double q3_){
//   q(0) = q0_;
//   q(1) = q1_;
//   q(2) = q2_;
//   q(3) = q3_;
// }

// Quaternion Quaternion::multiply(Quaternion r) {
//   double q0_ = r.q(0)*q(0) - r.q(1)*q(1) - r.q(2)*q(2) - r.q(3)*q(3);
//   double q1_ = r.q(0)*q(1) + r.q(1)*q(0) - r.q(2)*q(3) + r.q(3)*q(2);
//   double q2_ = r.q(0)*q(2) + r.q(1)*q(3) + r.q(2)*q(0) - r.q(3)*q(1);
//   double q3_ = r.q(0)*q(3) - r.q(1)*q(2) + r.q(2)*q(1) + r.q(3)*q(0);
//   return Quaternion(q0_, q1_, q2_, q3_);
// }

// void qmultiply(Matrix<4,1> a, Matrix<4,1> b, Matrix<4,1> c){
//   c(0) = b(0)*a(0) - b(1)*a(1) - b(2)*a(2) - b(3)*a(3);
//   c(1) = b(0)*a(1) + b(1)*a(0) - b(2)*a(3) + b(3)*a(2);
//   c(2) = b(0)*a(2) + b(1)*a(3) + b(2)*a(0) - b(3)*a(1);
//   c(3) = b(0)*a(3) - b(1)*a(2) + b(2)*a(1) + b(3)*a(0);
// }

Quaternion Quaternion::inverse(){
  double denom = q(0)*q(0) + q(1)*q(1) + q(2)*q(2) + q(3)*q(3);
  return Quaternion(q(0)/denom, -q(1)/denom, -q(2)/denom, -q(3)/denom);
}

Quaternion Quaternion::conjugate(){
  return Quaternion(q(0), -q(1), -q(2), -q(3));
}

String Quaternion::toString(){
  char buffer[50];
  sprintf(buffer, "[%2.2f, %2.2f, %2.2f, %2.2f]", q(0), q(1), q(2), q(3));
  return buffer;

}
