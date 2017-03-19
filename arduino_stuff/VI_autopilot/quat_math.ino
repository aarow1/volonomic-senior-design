template <typename T> T sign(T& val) {
return (T(0) <= val) - (val < T(0));
}


Quaternion qMultiply(Quaternion a, Quaternion b) {
  static Quaternion c; 
  c(0) = b(0) * a(0) - b(1) * a(1) - b(2) * a(2) - b(3) * a(3);
  c(1) = b(0) * a(1) + b(1) * a(0) - b(2) * a(3) + b(3) * a(2);
  c(2) = b(0) * a(2) + b(1) * a(3) + b(2) * a(0) - b(3) * a(1);
  c(3) = b(0) * a(3) - b(1) * a(2) + b(2) * a(1) + b(3) * a(0);
  // Serial.printf("c =[%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", c(0), c(1), c(2), c(3));
  return c;
};

Quaternion qInverse(Quaternion q) {
  static Quaternion q_inv;
  q_inv(0) = q(0);
  q_inv(1) = -q(1);
  q_inv(2) = -q(2);
  q_inv(3) = -q(3);
  return q_inv;
};

// Rotates vec by rotation rot. Vec is a Quaternion with the first element set to 0
Vec3 qRotate(Vec3 vec, Quaternion rot){
  //p' = qpq-1
  static Vec3 ans;
  static Quaternion vec_quat;
  vec_quat(0) = 0;
  vec_quat(1) = vec(0);
  vec_quat(2) = vec(1);
  vec_quat(3) = vec(2);

  Quaternion rot_inv(quat_id);
  Quaternion ans_quat;
  rot_inv = qInverse(rot);
  ans_quat = qMultiply(qMultiply(rot_inv,vec_quat), rot);

  ans(0) = ans_quat(1);
  ans(1) = ans_quat(2);
  ans(2) = ans_quat(3);
  // Serial.printf("vec =[%2.2f,\t%2.2f,\t%2.2f]\n", vec(0), vec(1), vec(2));
  // Serial.print("vec_quat"); q_toString(vec_quat);
  // Serial.print("rot"); q_toString(rot);
  // Serial.print("ans_quat"); q_toString(ans_quat);
  // Serial.printf("ans =[%2.2f,\t%2.2f,\t%2.2f]\n", ans(0), ans(1), ans(2));
  return ans;
}

Vec3 cross(Vec3 a, Vec3 b) {
  static Vec3 c;
  c(0) = a(1) * b(2) - a(2) * b(1);
  c(1) = a(2) * b(0) - a(0) * b(2);
  c(2) = a(0) * b(1) - a(1) * b(0);
  return c;
};

Vec3 scalar_multiply(float a, Vec3 b) {
  static Vec3 c;
  for (int i = 0; i < 3; i++) {
    c(i) = a * b(i);
  }
  return c;
}

void q_toString(Quaternion q) {
  Serial.printf("[%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", q(0), q(1), q(2), q(3));
}

