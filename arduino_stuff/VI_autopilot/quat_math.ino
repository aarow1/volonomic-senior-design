template <typename T> T sign(T& val) {
  return (T(0) <= val) - (val < T(0));
}

void qmultiply(Quaternion& a, Quaternion& b, Quaternion& c) {
  c(0) = b(0) * a(0) - b(1) * a(1) - b(2) * a(2) - b(3) * a(3);
  c(1) = b(0) * a(1) + b(1) * a(0) - b(2) * a(3) + b(3) * a(2);
  c(2) = b(0) * a(2) + b(1) * a(3) + b(2) * a(0) - b(3) * a(1);
  c(3) = b(0) * a(3) - b(1) * a(2) + b(2) * a(1) + b(3) * a(0);
};

void qinverse(Quaternion& q, Quaternion& q_inv) {
  q_inv(0) = q(0);
  q_inv(1) = -q(1);
  q_inv(2) = -q(2);
  q_inv(3) = -q(3);
};

// Rotates vec by rotation rot. Vec is a Quaternion with the first element set to 0
void qRotate(Vec3& vec, Quaternion& rot, Vec3& ans){
  //p' = qpq-1

  Quaternion vec_quat;
  vec_quat(0) = 0;
  vec_quat(1) = vec(0);
  vec_quat(2) = vec(1);
  vec_quat(3) = vec(2);

  static Quaternion rot_inv(quat_id);
  static Quaternion temp;
  static Quaternion ans_quat;
  qinverse(rot, rot_inv);
  qmultiply(rot, vec_quat, temp);
  qmultiply(temp, rot_inv, ans_quat);

  ans(0) = ans_quat(1);
  ans(1) = ans_quat(2);
  ans(2) = ans_quat(3);
}

Vec3 cross(Vec3 a, Vec3 b) {
  Vec3 c;
  c(0) = a(1) * b(2) - a(2) * b(1);
  c(1) = a(2) * b(0) - a(0) * b(2);
  c(2) = a(0) * b(1) - a(1) * b(0);
  return c;
};

Vec3 scalar_multiply(float a, Vec3 b) {
  Vec3 c;
  for (int i = 0; i < 3; i++) {
    c(i) = a * b(i);
  }
  return c;
}

void q_toString(Quaternion q) {
  Serial.printf("[%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", q(0), q(1), q(2), q(3));
}

