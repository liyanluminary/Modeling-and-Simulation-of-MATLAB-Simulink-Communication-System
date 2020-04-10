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
plot(t,msg2) %画出消息信号
title("消息信号")


fc = 100; %载波频率
s1 = 0.5*msg2.*cos(2*pi*fc*t); %USSB信号的同相分量
hmsg = imag(hilbert(msg2)); %消息信号的Hilbert变化
s2 = 0.5*hmsg.*sin(2*pi*fc*t); %USSB信号的正交分量
Sussb = s1-s2; %完整的USSB信号
y = Sussb.*cos(2*pi*fc*t); %相干解调
Y = fft(y)./fs; %解调后的频谱
f_stop = 100; %低通滤波器的截止频率
n_stop = floor(f_stop/df);
Hlow = zeros(size(f));
Hlow(1:n_stop)=2; %设计低通滤波器
Hlow(length(f)-n_stop+1:end)=2;
DEM = Y.*Hlow; %解调信号通过低通滤波器
dem = real(ifft(DEM))*fs; %最终得到的解调信号
subplot(3,1,2)
plot(t,dem)
title("无噪声的解调信号")

y1=awgn(Sussb,20,"measured"); %调制信号通过AWGN信道
y2 = y1.*cos(2*pi*fc*t); %相干解调
Y2 = fft(y2)./fs;%解调后的频谱
DEM1 = Y2.*Hlow;%解调信号通过低通滤波器
dem1 = real(ifft(DEM1))*fs;%最终得到的解调信号
subplot(3,1,3)
plot(t,dem1)
title("信噪比为20时的的解调信号")