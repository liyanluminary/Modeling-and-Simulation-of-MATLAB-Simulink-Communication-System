clear all
n1 = 0:20;
n2 = 0:10;
h = sinc(0.2*n1);
x = exp(-0.2*n2);
y = conv(x,h);


h1 = [h zeros(1, length(x)-1)];
x1 = [x zeros(1, length(h)-1)];
H1 = fft(h1);
X1 = fft(x1);
Y1 = H1.*X1;
y1 = ifft(Y1)

subplot(2,1,1);stem(y);title("直接计算");
subplot(2,1,2);stem(y1);title("DFT计算");