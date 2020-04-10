%8PSK
clear all
nsymbol = 100000; %每种SNR下发送的符号数

T = 1; %符号周期
fs = 100; %每个符号的采样点数
ts = 1/fs; %采样时间间隔
t = 0:ts:T-ts; %时间向量
fc = 10;%载波频率
c = sqrt(2/T)*exp(j*2*pi*fc*t); %载波信号
c1 = sqrt(2/T)*cos(2*pi*fc*t);  %同相载波
c2 = sqrt(2/T)*sin(2*pi*fc*t);  %正交载波

M=8; %8-PAM
graycode = [0 1 2 3 6 7 4 5];
EsN0 = 0:15;
snr1 = 10.^(EsN0/10); %信噪比转换为线性值
msg = randi([0,1],1,nsymbol);
msg1 = graycode(msg+1); % Gray映射
msgmod = pskmod(msg1, M); %8-PSK调制
tx = real(msgmod'*c); %载波调制
tx1= reshape(tx.',1,length(msgmod)*length(c));
spow = norm(tx1).^2/nsymbol; %求每个符号的平均gonglv

for indx=1:length(EsN0)
    sigma = sqrt(spow/(2*snr1(indx))); %根据符号功率求噪声功率
    rx = tx1+sigma*randn(1,length(tx1)); %加如高斯白噪声
    rx1 = reshape(rx,length(c),length(msgmod));
    r1 = (c1*rx1)/length(c1); %相关运算
    r2 = (c2*rx1)/length(c2); %相关运算
    r = r1+j*r2;
    y = pskdemod(r,M); %判决
    demsg = graycode(y+1);
    [err,ber(indx)] = biterr(msg,demsg,log2(M));
    [err,ser(indx)] = symerr(msg,demsg);
end

ser1 = 2*qfunc(sqrt(2*snr1)*sin(pi/M));
ber1 = 1/log2(M)*ser1;
semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, ser1, "-ro", EsN0, ber1, "-r*");
title("8-PSK载波调制信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率", "理论误比特率")