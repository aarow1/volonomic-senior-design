Quaternion q_curr_inv;
Quaternion q_err;

Vec3 w_des;
Vec3 t_des;

float J_vi_arr[3][3] = {
  {  0.0106063129, 0.00030489483,  -0.00022202219},
  { 0.00030489483, 0.01063727884,   0.00031613497},
  { -0.00022202219, 0.00031613497,   0.01058215165}
};
Matrix<3, 3, float> J_vi(J_vi_arr);

float r = .15; // m

float A_vi_arr[6][6] = {
  {0,   0,  -1,  -1,   0,   0},
  {0,   0,   0,   0,   1,   1},
  {1,  -1,   0,   0,   0,   0},
  {0,   0,   0,   0,  -r,   r},
  {r,   r,   0,   0,   0,   0},
  {0,   0,  -r,   r,   0,   0}
};
Matrix<6, 6, float> A_vi(A_vi_arr);
Matrix<6, 6, float> A_inv = A_vi.Inverse();
float x_arr[4][1] = {0.0,1.0,0.0,0.0};
Quaternion x(x_arr);

template <typename T> T sign(T& val);
Quaternion qInverse(Quaternion q);
Quaternion qMultiply(Quaternion a, Quaternion b);
Vec3 cross(Vec3 a, Vec3 b);
Vec3 scalar_multiply(float a, Vec3 b);
void q_toString(Quaternion q);
Vec3 qRotate(Vec3 vec, Quaternion rot);
Quaternion qmultiply_test(Quaternion a, Quaternion b);
void readUM7() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
    q_curr_imu = qMultiply(x,(Quaternion)imu.q_curr);
    Serial.print("q_curr w/o rot"); q_toString((Quaternion)(imu.q_curr));
    Serial.print("q_curr_imu"); q_toString(q_curr_imu);
  }

}

#define DEBUG_calculateMotorForces 0

void calculateMotorForces() {

  q_curr_inv = qInverse(q_curr);
  q_err = qMultiply(q_curr_inv, q_des);

  static Vec3 w_ff_body;
  w_ff_body = qRotate(w_ff, q_curr);

  w_des(0) = (2 / tau_att) * sign(q_err(0)) * q_err(1) + w_ff(0);
  w_des(1) = (2 / tau_att) * sign(q_err(0)) * q_err(2) + w_ff(1);
  w_des(2) = (2 / tau_att) * sign(q_err(0)) * q_err(3) + w_ff(2);

  // t_des = scalar_multiply((1 / tau_w), J_vi * (w_des - w_curr)) + cross(w_curr, J_vi * w_curr);

  t_des(0) = 0;
  t_des(1) = 0;
  t_des(2) = 0;

  // Rotate f_des into body frame
  static Vec3 f_des_body;
  f_des_body = qRotate(f_des, q_curr);
  Multiply(A_inv, (f_des_body && t_des), motor_forces);
 

  if (DEBUG_calculateMotorForces) {
    Serial.print("q_curr"); q_toString(q_curr);
    Serial.print("q_des"); q_toString(q_des);
    Serial.print("q_curr_inv"); q_toString(q_curr_inv);
    Serial.print("q_err"); q_toString(q_err);
    Serial.printf("w_des =[%2.2f,\t%2.2f,\t%2.2f]\n", w_des(0), w_des(1), w_des(2));
    Serial.printf("w_curr =[%2.2f,\t%2.2f,\t%2.2f]\n", w_curr(0), w_curr(1), w_curr(2));
    Serial.printf("t_des =[%2.2f,\t%2.2f,\t%2.2f]\n", t_des(0), t_des(1), t_des(2));
    Serial.printf("f_des =[%2.2f,\t%2.2f,\t%2.2f]\n", f_des(0), f_des(1), f_des(2));
    Serial.printf("f_des_body =[%2.2f,\t%2.2f,\t%2.2f]\n", f_des_body(0), f_des_body(1), f_des_body(2));
    Serial.printf("tau_w: %2.5f\n", tau_w);
  }
}


