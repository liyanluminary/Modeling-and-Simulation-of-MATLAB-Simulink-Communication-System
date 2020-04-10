% SSB相移法
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
s1 = 0.5*msg2.*cos(2*pi*fc*t); %USSB信号的同相分量
hmsg = imag(hilbert(msg2)); %消息信号的Hilbert变化
s2 = 0.5*hmsg.*sin(2*pi*fc*t); %USSB信号的正交分量
Sussb = s1-s2; %完整的USSB信号
Pussb = fft(Sussb)/fs;


subplot(2,1,2)
plot(f,fftshift(abs(Pussb))); %画出已调信号频谱
title("USSB信号频谱")
axis([-200 200 0 2])


Pc = sum(abs(Sussb).^2)/length(Sussb); %已调信号功率
Ps = sum(abs(msg2).^2)/length(msg2);  %消息信号功率