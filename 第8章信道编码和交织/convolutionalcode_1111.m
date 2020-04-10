clear all
Lc = 7; %卷积码约束长度
BitRate=100000; %比特速率
EbN0 = 0:2:10; %SNR的范围

for ii=1:length(EbN0)
    ii
    SNR=EbN0(ii); %赋值给AWGN信道中的SNR
    sim('convolutionalcode_11'); %运行仿真模型
    ber1(ii)=BER1(1);
    ber2(ii)=BER2(1);
end

ber = berawgn(EbN0,'psk',2,'nodiff'); %BPSK调制的理论误比特率
semilogy(EbN0,ber,'-ko',EbN0,ber1,'-k*',EbN0,ber2,'-k+');
legend("BPSK调制的理论误比特率","硬判决误比特率","软判决误比特率");
title("卷积码性能")
xlabel("Eb/N0");ylabel("误比特率");