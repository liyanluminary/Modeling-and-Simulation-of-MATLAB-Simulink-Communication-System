clear all
ts = 0.01;
fs = 1/ts;
t = 0:ts:10;
df = fs/length(t);
f = -50:df:50-df;
x = exp(-10*abs(t-5)).*cos(2*pi*20*t);
xa = hilbert(x);

fc1 = 20;
xl1 = xa.*exp(-j*2*pi*fc1*t);
Xl1 = fft(xl1)/fs;
subplot(2,1,1);plot(t,real(xl1));title("fc=20Hz时的低通信号同相分量");xlabel("时间t")
subplot(2,1,2);plot(f,fftshift(abs(Xl1)));title("fc=20Hz时的低通信号幅度谱");xlabel("频率f")

fc2 = 10;
xl2 = xa.*exp(-j*2*pi*fc2*t);
Xl2 = fft(xl2)/fs;
figure
subplot(2,1,1);plot(t,real(xl2));title("fc=10Hz时的低通信号同相分量");xlabel("时间t")
subplot(2,1,2);plot(f,fftshift(abs(Xl2)));title("fc=10Hz时的低通信号幅度谱");xlabel("频率f")
