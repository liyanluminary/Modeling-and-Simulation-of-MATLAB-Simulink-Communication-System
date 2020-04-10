% DFT
% ¿Î…¢Fourier±‰ªª
clear all
n=0:30;
x = sin(0.2*n).*exp(-0.1*n);
k=0:30;
N=31;
Wnk = exp(-j*2*pi/N).^(n'*k);
X = x*Wnk;
subplot(2,1,1);stem(n,x);title("–Ú¡–X")
subplot(2,1,2);stem(-15:15,[abs(X(17:end)) abs(X(1:16))])
title("X∑˘∂»")