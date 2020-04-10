clear all
h = [6 3 4 2 1 -2]
x = [3 2 6 7 -1 -3];
h1 = fliplr(h);
H = toeplitz(h,[h(1) h1(1:5)]);
y = H*x';

H = fft(h);
X = fft(x);
Y = H.*X;
y1 = ifft(Y);

subplot(2,1,1);stem(y);title("直接计算");
subplot(2,1,2);stem(y1);title("DFT计算");