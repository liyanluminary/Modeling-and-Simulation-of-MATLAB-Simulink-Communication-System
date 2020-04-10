clear all
M = 4; %4-FSK
T = 1; %符号持续时间
deltaf = 1/T; %FSK的频率间隔
fs = 60; %采样频率
ts = 1/fs; %采样时间间隔
t = 0:ts:T; %一个符号周期的时间向量
fc = 4; %载波频率
msg = [0 1 3 2 randi([0,1],1,10000-M)]; %消息序列
msg_mod = fskmod(msg,M,deltaf,fs,fs); %4-FSK调制
t1 = 0:ts:length(msg)-ts; %消息序列时间向量
y = real(msg_mod.*exp(j*2*pi*fc*t1)); %载波调制
subplot(2,1,1)
plot(t1(1:4*fs),y(1:4*fs)); %时域信号波形
title("4-FSK调制的信号波形")
xlabel("时间t");ylabel("振幅");
ly = length(y); %调制信号长度
freq = [-fs/2:fs/ly:fs/2 - fs/ly];
Syy = 10*log10(fftshift(abs(fft(y)/fs))); %调制信号频谱
subplot(2,1,2)
plot(freq,Syy);
title("调制信号幅度谱")
xlabel("频率");ylabel("载波振幅");
