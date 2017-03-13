//Quaternion q_curr;
Quaternion q_curr_inv;
//double id[4][1] = {1, 0, 0, 0};
//Quaternion q_des(id);
Quaternion q_err;

double J_vi_arr[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
Matrix<3, 3, double> J_vi(J_vi_arr);

double A_vi_arr[6][6] = {{1, 1, 0, 0, 0, 0}, {0, 0, 1, 1, 0, 0}, {0, 0, 0, 0, 1, 1},
  {0, 0, 1, -1, 0, 0}, {0, 0, 0, 0, 1, -1}, {1, -1, 0, 0, 0, 0}
};
Matrix<6, 6, double> A_vi(A_vi_arr);
Matrix<6, 6, double> A_inv = A_vi.Inverse();

//Matrix<3, 1, double> w_ff;
Vec3 w_des;
Vec3 t_des;
//Matrix<3, 1, double> f_des;
Vec6 x;

double tau_att = 1.0;
double tau_w = 1.0;

template <typename T> T sign(T val);
void qinverse(Quaternion q, Quaternion q_inv);
void qmultiply(Quaternion a, Quaternion b, Quaternion c);
Vec3 cross(Vec3 a, Vec3 b);
Vec3 scalar_multiply(double a, Vec3 b);

void readUM7() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
  }

}

Vec6 calculateMotorForces(Quaternion q_curr, Quaternion q_des, Vec3 w_ff, Vec3 f_des, Vec3 w_curr) {
  qinverse(q_curr, q_curr_inv);
  qmultiply(q_curr_inv, q_des, q_err);

  w_des(0) = (2 / tau_att) * sign(q_err(0)) * q_err(1) + w_ff(0);
  w_des(1) = (2 / tau_att) * sign(q_err(0)) * q_err(2) + w_ff(1);
  w_des(2) = (2 / tau_att) * sign(q_err(0)) * q_err(3) + w_ff(2);

  t_des = scalar_multiply((1 / tau_w), J_vi * (w_des - w_curr)) + cross(w_curr, J_vi * w_curr);
  Multiply(A_inv, (f_des && t_des), x);
  // scalar_multiply(tau_att, w_des);

//  Serial.printf("q_cur = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
//                imu.q_att(0), imu.q_att(1), imu.q_att(2), imu.q_att(3));
//  Serial.printf("w = [%2.2f,\t%2.2f,\t%2.2f]\n", imu.w(0), imu.w(1), imu.w(2));
  Serial.printf("x = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n", x(0), x(1), x(2), x(3), x(4), x(5));
  //  Serial.println("q_des = " + q);
  //    Serial.print(q_des.toString());
  //    Serial.print("q_err = ");
  //    Serial.print(q_err.toString());
  //  Serial.printf("\tw_des = [%2.2f, %2.2f, %2.2f]\n", w_des(0), w_des(1), w_des(2));
  return x;
}


