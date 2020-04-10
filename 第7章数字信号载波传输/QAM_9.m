%基带等效方式仿真16-QAM载波调制信号在AWGN信道下的误比特率性能
clear all
nsymbol = 100000; %每种SNR下发送的符号数

M=16; %16-QAM 
graycode = [0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];
EsN0 = 5:20;
snr1 = 10.^(EsN0/10); %信噪比转换为线性值
msg = randi([0,1],1,nsymbol); %消息数据
msg1 = graycode(msg+1); % Gray映射
msgmod = qammod(msg1, M); %16-QAM调制
spow = norm(msgmod).^2/nsymbol; %求每个符号的平均gonglv

for indx=1:length(EsN0)
    sigma = sqrt(spow/(2*snr1(indx))); %根据符号功率求噪声功率
    rx = msgmod+sigma*(randn(1,length(msgmod))+j*randn(1,length(msgmod))); %加高斯白噪声
    y = qamdemod(rx,M); %判决
    demsg = graycode(y+1);
    [err,ber(indx)] = biterr(msg,demsg,log2(M));
    [err,ser(indx)] = symerr(msg,demsg);
end

P4 = 2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser1 = 1-(1-P4).^2;
ber1 = 1/log2(M)*ser1;
semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, ser1, "-r*", EsN0, ber1, "-ro");
title("16-QAM载波调制信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率", "理论误比特率")