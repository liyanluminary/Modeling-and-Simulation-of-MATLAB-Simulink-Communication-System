%4-QAM和4-FSK通过rayleigh衰落信道仿真
clear all
nsymbol = 100000; %每种SNR下发送的符号数
SymbolRate = 1000; %fuhaosulv
nsamp = 50; %每个符号的取样点数
fs = nsamp*SymbolRate; %采样频率
fd = 100; % Rayleigh衰落信道的最大多普勒频移
chan = rayleighchan(1/fs,fd); %生成Rayleigh衰落信道

M=4; 
graycode = [0 1 3 2];
EsN0 = 0:2:20;
snr1 = 10.^(EsN0/10); %信噪比转换为线性值
msg = randi([0,1],1,nsymbol);
msg1 = graycode(msg+1); % Gray映射
x1 = qammod(msg1,M); %基带4-QAM调制
x1 = rectpulse(x1,nsamp);
x2 = fskmod(msg1,M, SymbolRate, nsamp,fs); %4-FSK调制
spow1 = norm(x1).^2/nsymbol; %求每个符号的平均功率
spow2 = norm(x2).^2/nsymbol; %求每个符号的平均功率

for indx=1:length(EsN0)
    sigma1 = sqrt(spow1/(2*snr1(indx))); %根据符号功率求噪声功率
    sigma2 = sqrt(spow2/(2*snr1(indx))); %根据符号功率求噪声功率
    fadeSig1 = filter(chan,x1);
    fadeSig2 = filter(chan,x2);
    rx1 = fadeSig1+sigma1*(randn(1,length(x1))+j*randn(1,length(x1))); %加高斯白噪声
    rx2 = fadeSig2+sigma1*(randn(1,length(x2))+j*randn(1,length(x2))); %加高斯白噪声
    y1 = intdump(rx1,nsamp); %相关
    y1 = qamdemod(y1,M);
    demsg1 = graycode(y1+1);
    [err,ber1(indx)] = biterr(msg,demsg1,log2(M));
    [err,ser1(indx)] = symerr(msg,demsg1);
    y2 = fskdemod(rx2,M,SymbolRate,nsamp,fs);
    demsg2 = graycode(y2+1);
    [err,ber2(indx)] = biterr(msg,demsg2,log2(M));
    [err,ser2(indx)] = symerr(msg,demsg2);
end

semilogy(EsN0,ber1,"-ko", EsN0, ser1, "-k*", EsN0, ser2, "-ro", EsN0, ber2, "-r*");
title("4-QAM和4-FSK调制信号在rayleigh衰落信道下性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("4-QAM误比特率", "4-QAM误符号率", "4-FSK误符号率", "4-FSK误比特率")