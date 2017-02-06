#include "Arduino.h"
#include "Quaternion.h"

Quaternion::Quaternion() {
	q = new float[4]{1, 0, 0, 0};
}
