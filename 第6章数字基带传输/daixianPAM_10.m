% 有错！！！
clear all
nsymbol = 100000; %每种SNR下发送的符号数

Fd = 1; %符号采样频率
Fs = 10; %滤波器采样频率
rolloff = 0.25; %滤波器滚降系数
delay = 5; %滤波器时延
M=4; %4-PAM
graycode = [0 1 3 2];
EsN0 = 0:15;
msg = randi([0,1],1,nsymbol);
msg1 = graycode(msg+1); % Gray映射
msgmod = pammod(msg1, M); %4-PAM调制
rrcfilter = rcosine(Fd,Fs,'fir/sqrt',rolloff,delay); %设计跟升余弦滤波器
s = rcosflt(msgmod,Fd,Fs,'filter',rrcfilter);

for indx=1:length(EsN0)
    demsg = zeros(1,nsymbol);
    r = awgn(real(s),EsN0(indx)-7, "measured");
    rx = rcosflt(r,Fd,Fs,'filter',rrcfilter);
    rx1 = downsample(rx,Fs);
    rx2 = rx1(2*delay+1:end-2*delay);
    msg_demod=pamdemod(rx2,M); %判决
    demsg = graycode(msg_demod+1);
    [err,ber(indx)] = biterr(msg,demsg,log2(M));
    [err,ser(indx)] = symerr(msg,demsg);
end

semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, 1.5*qfunc(sqrt(0.4*10.^(EsN0/10))), "-ro");
title("4-PAM信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率")