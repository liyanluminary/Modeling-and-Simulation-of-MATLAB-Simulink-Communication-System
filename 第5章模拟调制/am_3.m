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
subplot(3,1,1)
plot(f,msg2) %画出消息信号
title("消息信号")

A=4;
fc=100;
Sam=(A+msg2).*cos(2*pi*fc*t); %已调信号

dems = abs(hilbert(Sam))-A;
subplot(3,1,2)
plot(t,dems)
title("无噪声的解调信号")

y=awgn(Sam,20,"measured");
dems2 = abs(hilbert(y))-A;
subplot(3,1,3)
plot(t,dems2)
title("信噪比为20时的的解调信号")

