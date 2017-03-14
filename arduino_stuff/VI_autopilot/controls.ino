//Quaternion q_curr;
Quaternion q_curr_inv;
//float id[4][1] = {1, 0, 0, 0};
//Quaternion q_des(id);
Quaternion q_err;

float J_vi_arr[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
Matrix<3, 3, float> J_vi(J_vi_arr);

float A_vi_arr[6][6] = {{1, 1, 0, 0, 0, 0}, {0, 0, 1, 1, 0, 0}, {0, 0, 0, 0, 1, 1},
  {0, 0, 1, -1, 0, 0}, {0, 0, 0, 0, 1, -1}, {1, -1, 0, 0, 0, 0}
};
Matrix<6, 6, float> A_vi(A_vi_arr);
Matrix<6, 6, float> A_inv = A_vi.Inverse();

//Matrix<3, 1, float> w_ff;
Vec3 w_des;
Vec3 t_des;
//Matrix<3, 1, float> f_des;
Vec6 x;

float tau_att = .1;
float tau_w = .01;

template <typename T> T sign(T& val);
void qinverse(Quaternion& q, Quaternion& q_inv);
void qmultiply(Quaternion& a, Quaternion& b, Quaternion& c);
Vec3 cross(Vec3 a, Vec3 b);
Vec3 scalar_multiply(float a, Vec3 b);
void q_toString(Quaternion q);

void readUM7() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
  }

}

Vec6 calculateMotorForces() {
  Serial.print("q_curr"); q_toString(q_curr);
  Serial.print("q_des"); q_toString(q_des);
  
  qinverse(q_curr, q_curr_inv);
  Serial.print("q_curr_inv"); q_toString(q_curr_inv);
  
  qmultiply(q_curr_inv, q_des, q_err);
    Serial.print("q_err"); q_toString(q_err);

  w_des(0) = (2 / tau_att) * sign(q_err(0)) * q_err(1) + w_ff(0);
  w_des(1) = (2 / tau_att) * sign(q_err(0)) * q_err(2) + w_ff(1);
  w_des(2) = (2 / tau_att) * sign(q_err(0)) * q_err(3) + w_ff(2);

  t_des = scalar_multiply((1 / tau_w), J_vi * (w_des - w_curr)) + cross(w_curr, J_vi * w_curr);
  Multiply(A_inv, (f_des && t_des), x);
  // scalar_multiply(tau_att, w_des);

  //  Serial.printf("q_cur = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
  //                imu.q_att(0), imu.q_att(1), imu.q_att(2), imu.q_att(3));
  //  Serial.printf("w = [%2.2f,\t%2.2f,\t%2.2f]\n", imu.w(0), imu.w(1), imu.w(2));
  //  Serial.printf("x = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", x(0), x(1), x(2), x(3), x(4), x(5));
  //  Serial.println("q_des = " + q);
  //    Serial.print(q_des.toString());
  //    Serial.print(q_err.toString());
  //  Serial.printf("\tw_des = [%2.2f, %2.2f, %2.2f]\n", w_des(0), w_des(1), w_des(2));
  return x;
}


