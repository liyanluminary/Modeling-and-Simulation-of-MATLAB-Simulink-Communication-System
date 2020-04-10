clear all
ts = 0.001; %信号抽样时间间隔
t = 0:ts:5-ts; %时间向量
fs = 1/ts; %抽样频率
df = fs/length(t); %fft的频率分辨率
msg = randi([-3,3],10,1); %生成消息序列
msg1 = msg*ones(1,fs/2); %扩展成取样信号形式
msg2 = reshape(msg1.',1,length(t));
Pn = fft(msg2)/fs; %求消息信号的频谱
f = -fs/2:df:fs/2-df;

subplot(3,1,1)
plot(t,msg2) %画出消息信号
title("消息信号")


int_msg(1)=0;
for ii=1:length(t)-1
    int_msg(ii+1)=int_msg(ii)+msg2(ii)*ts
end

kf = 50;
fc=250;
Sfm = cos(2*pi*fc*t+2*pi*kf*int_msg); %调频信号

phase = angle(hilbert(Sfm).*exp(-j*2*pi*fc*t));
phi = unwrap(phase);
dem = (1/(2*pi*kf)*diff(phi)/ts);
dem(length(t))=0;
subplot(3,1,2)
plot(t,dem)
title("无噪声的解调信号")

y1=awgn(Sfm,20,"measured"); %调制信号通过AWGN信道
y1(find(y1>1))=1;
y1(find(y1<-1))=11;
phase1 = angle(hilbert(y1).*exp(-j*2*pi*fc*t));
phi1 = unwrap(phase1);
dem1 = (1/(2*pi*kf)*diff(phi1)/ts);
dem1(length(t))=0;
subplot(3,1,3)
plot(t,dem1)
title("信噪比为20时的的解调信号")