const_grams = .000121;
w = 0:10:1700;

f_grams = const_grams * w.^2;
f_newtons_grams = f_grams * 9.8 / 1000;

const_newtons = const_grams * 9.8 / 1000
f_newtons = const_newtons * w.^2;

plot(w, f_newtons_grams, '--');
hold on;
plot(w, f_newtons, 'o');