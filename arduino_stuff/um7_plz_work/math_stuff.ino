#include <BasicLinearAlgebra.h>

template <typename T> T sign(T val) {
    return (T(0) < val) - (val < T(0));
}

void qmultiply(Matrix<4,1> a, Matrix<4,1> b, Matrix<4,1> c){
  c(0) = b(0)*a(0) - b(1)*a(1) - b(2)*a(2) - b(3)*a(3);
  c(1) = b(0)*a(1) + b(1)*a(0) - b(2)*a(3) + b(3)*a(2);
  c(2) = b(0)*a(2) + b(1)*a(3) + b(2)*a(0) - b(3)*a(1);
  c(3) = b(0)*a(3) - b(1)*a(2) + b(2)*a(1) + b(3)*a(0);
};

void qinverse(Matrix<4,1> q, Matrix<4,1> q_inv){
  q_inv(0) = q(0);
  q_inv(1) = -q(1);
  q_inv(2) = -q(2);
  q_inv(3) = -q(3);
};

Matrix<3,1> cross(Matrix<3,1> a, Matrix<3,1> b){
  Matrix<3,1> c;
  c(0) = a(1)*b(2) - a(2)*b(1);
  c(1) = a(2)*b(0) - a(0)*b(2);
  c(2) = a(0)*b(1) - a(1)*b(0);
  return c;
};

Matrix<3,1> scalar_multiply(double a, Matrix<3,1> b){
  Matrix<3,1> c;
  for(int i = 0; i<3; i++){
    c(i) = a*b(i);
  }
  return c;
}

