function ret = scaleToInt(val, val_max)

INT_16_MAX  = 32767.0;

ret = ((val / val_max) * INT_16_MAX);

end