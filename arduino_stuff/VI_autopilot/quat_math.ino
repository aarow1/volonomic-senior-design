template <typename T> T sign(T val) {
    return (T(0) < val) - (val < T(0));
}

void qmultiply(Quaternion a, Quaternion b, Quaternion c){
  c(0) = b(0)*a(0) - b(1)*a(1) - b(2)*a(2) - b(3)*a(3);
  c(1) = b(0)*a(1) + b(1)*a(0) - b(2)*a(3) + b(3)*a(2);
  c(2) = b(0)*a(2) + b(1)*a(3) + b(2)*a(0) - b(3)*a(1);
  c(3) = b(0)*a(3) - b(1)*a(2) + b(2)*a(1) + b(3)*a(0);
};

void qinverse(Quaternion q, Quaternion q_inv){
  q_inv(0) = q(0);
  q_inv(1) = -q(1);
  q_inv(2) = -q(2);
  q_inv(3) = -q(3);
};

Vec3 cross(Vec3 a, Vec3 b){
  Vec3 c; 
  c(0) = a(1)*b(2) - a(2)*b(1);
  c(1) = a(2)*b(0) - a(0)*b(2);
  c(2) = a(0)*b(1) - a(1)*b(0);
  return c;
};

Vec3 scalar_multiply(double a, Vec3 b){
  Vec3 c;
  for(int i = 0; i<3; i++){
    c(i) = a*b(i);
  }
  return c;
}

