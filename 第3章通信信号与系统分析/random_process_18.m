clear all
ts = 0.002;
tao = -1:ts:1;
B=20;
f0=100;
R=sinc(2*B*tao).*cos(2*pi*f0*tao);

fs = 1/ts;
df=fs/length(tao);
f = -fs/2:df:fs/2-df;
S = fft(R)/fs;
subplot(2,1,1);plot(tao,R);title("自相关函数");xlabel("tao");ylabel("R")
subplot(2,1,2);plot(f,fftshift(abs(S)));title("功率谱密度");xlabel("f");ylabel("S")