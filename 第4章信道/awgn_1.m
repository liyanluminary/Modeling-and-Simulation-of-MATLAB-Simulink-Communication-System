clear all
t = 0:0.001:10;
x = sin(2*pi*t);
snr = 20;
y = awgn(x,snr);
subplot(2,1,1);plot(t,x);title("正弦信号x")
subplot(2,1,2);plot(t,y);title("叠加了高斯白噪声后的正弦信号")

z = y-x;
var(z)