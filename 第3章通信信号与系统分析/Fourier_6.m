clear all
syms t;
f = t*exp(-abs(t));
subplot(1,2,1);ezplot(f);
F = fourier(f);
subplot(1,2,2);ezplot(abs(F));
