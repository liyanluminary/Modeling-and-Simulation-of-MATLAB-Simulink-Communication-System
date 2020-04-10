clear all
ts = 0.0025; %信号抽样时间间隔
t = 0:ts:10-ts; %时间向量
fs = 1/ts; %抽样频率
df = fs/length(t); %fft的频率分辨率
msg = randi([-3,3],100,1); %生成消息序列
msg1 = msg*ones(1,fs/10); %扩展成取样信号形式
msg2 = reshape(msg1.',1,length(t));
Pn = fft(msg2)/fs; %求消息信号的频谱
f = -fs/2:df:fs/2-df;
subplot(2,1,1)
plot(f,fftshift(abs(Pn))) %画出消息信号频谱
title("消息信号频谱")


fc = 100; %载波频率
Sdsb=msg2.*cos(2*pi*fc*t); %DSB信号信号
Pdsb = fft(Sdsb)/fs; %DSB信号频谱
f_stop = 100; %低通滤波器的截止频率
n_stop = floor(f_stop/df);
Hlow = zeros(size(f));
Hlow(1:n_stop)=2; %设计低通滤波器
Hlow(length(f)-n_stop+1:end)=2;
Plssb = Pdsb.*Hlow;
subplot(2,1,2)
plot(f,fftshift(abs(Plssb))); %画出已调信号频谱
title("LSSB信号频谱")
axis([-200 200 0 2])

S1ssb = real(ifft(Plssb))*fs;
Pc = sum(abs(S1ssb).^2)/length(S1ssb); %已调信号功率
Ps = sum(abs(msg2).^2)/length(msg2);  %消息信号功率