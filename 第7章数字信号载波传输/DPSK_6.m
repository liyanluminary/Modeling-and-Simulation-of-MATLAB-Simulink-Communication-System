%8-DPSK
clear all
nsymbol = 100000; %每种SNR下发送的符号数

M=8; %8-DPSK
graycode = [0 1 2 3 6 7 4 5];
EsN0 = 5:20;
snr1 = 10.^(EsN0/10); %信噪比转换为线性值
msg = randi([0,1],1,nsymbol);
msg1 = graycode(msg+1); % Gray映射
msgmod = pskmod(msg1, M); %8-PSK调制
spow = norm(msgmod).^2/nsymbol; %求每个符号的平均gonglv

for indx=1:length(EsN0)
    sigma = sqrt(spow/(2*snr1(indx))); %根据符号功率求噪声功率
    rx = msgmod+sigma*(randn(1,length(msgmod))+j*randn(1,length(msgmod))); %加如高斯白噪声
    y = dpskdemod(rx,M); %判决
    demsg = graycode(y+1);
    [err,ber(indx)] = biterr(msg(2:end),demsg(2:end),log2(M));
    [err,ser(indx)] = symerr(msg(2:end),demsg(2:end));
end

ser1 = 2*qfunc(sqrt(2*snr1)*sin(pi/M));
ber1 = 1/log2(M)*ser1;
semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, ser1, "-ro", EsN0, ber1, "-r*");
title("8-DPSK载波调制信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率", "理论误比特率")