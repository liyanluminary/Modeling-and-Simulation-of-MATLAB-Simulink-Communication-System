clear all
syms t w;
F = pi*exp(-abs(w));
subplot(1,2,1);ezplot(abs(F));
f = ifourier(F,t);
subplot(1,2,2);ezplot(f);