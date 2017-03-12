#include <Quaternion.h>
#include <BasicLinearAlgebra.h>
#include <UM7.h>

#define Quaternion Matrix<4,1,double>

//Connect the RX pin on the UM7 to TX1 (pin 18) on the DUE
//Connect the TX pin on the UM7 to RX1 (pin 19) on the DUE

UM7 imu;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial2.begin(115200);
  pinMode(13, OUTPUT);
}

Quaternion q_curr;
Quaternion q_curr_inv;
double id[4][1] = {1, 0, 0, 0};
Quaternion q_des(id);
Quaternion q_err;

double J_vi_arr[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
Matrix<3, 3, double> J_vi(J_vi_arr);
double A_vi_arr[6][6] = {{1, 1, 0, 0, 0, 0}, {0, 0, 1, 1, 0, 0}, {0, 0, 0, 0, 1, 1}, 
                         {0, 0, 1, -1, 0, 0}, {0, 0, 0, 0, 1, -1}, {1, -1, 0, 0, 0, 0}};
Matrix<6, 6, double> A_vi(A_vi_arr);
Matrix<6, 6, double> A_inv = A_vi.Inverse();

Matrix<3, 1, double> w_ff;
Matrix<3, 1, double> w_des;
Matrix<3, 1, double> t_des;
Matrix<3, 1, double> f_des;
Matrix<6, 1, double> x;
double tau_att = 1.0;
double tau_w = 1.0;

template <typename T> T sign(T val);
void qinverse(Matrix<4, 1> q, Matrix<4, 1> q_inv);
void qmultiply(Matrix<4, 1> a, Matrix<4, 1> b, Matrix<4, 1> c);
Matrix <3, 1> cross(Matrix<3, 1> a, Matrix<3, 1> b);
Matrix<3, 1> scalar_multiply(double a, Matrix<3, 1> b);

void loop() {

  if (Serial2.available()) {
    while (Serial2.available()) {
      imu.encode(Serial2.read());
    }
  }

  qinverse(q_curr, q_curr_inv);
  qmultiply(q_curr_inv, q_des, q_err);

  w_des(0) = (2 / tau_att) * sign(q_err(0)) * q_err(1) + w_ff(0);
  w_des(1) = (2 / tau_att) * sign(q_err(0)) * q_err(2) + w_ff(1);
  w_des(2) = (2 / tau_att) * sign(q_err(0)) * q_err(3) + w_ff(2);

  t_des = scalar_multiply((1 / tau_w), J_vi * (w_des - imu.w)) + cross(imu.w, J_vi * imu.w);
  Multiply(A_inv,(f_des && t_des),x);
  // scalar_multiply(tau_att, w_des);
 
  Serial.printf("q_cur = [%2.2f,\t%2.2f,\t%2.2f,\t%2.2f]\n",
                imu.q_att(0), imu.q_att(1), imu.q_att(2), imu.q_att(3));
  Serial.printf("w = [%2.2f,\t%2.2f,\t%2.2f]\n", imu.w(0), imu.w(1), imu.w(2));
  Serial.printf("x = [%2.2f,\t%2.2f,\t%2.2f, \t%2.2f, \t%2.2f, \t%2.2f]\n", x(0),x(1),x(2),x(3),x(4),x(5));
  //  Serial.println("q_des = " + q);
  //    Serial.print(q_des.toString());
  //    Serial.print("q_err = ");
  //    Serial.print(q_err.toString());
  //  Serial.printf("\tw_des = [%2.2f, %2.2f, %2.2f]\n", w_des(0), w_des(1), w_des(2));
}


