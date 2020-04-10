%有错
clear all
M=16;
EsN0 = 0:2:20;
EsN01 = 10.^(EsN0/10);
SymbolRate = 2;
for ii=1:length(EsN0)
    SNR=EsN0(ii);
    sim("PSK_4");
    ber(ii)=BER(1);
    ser(ii)=SER(1);
end

ser1 = 2*qfunc(sqrt(2*snr1)*sin(pi/M));
ber1 = 1/log2(M)*ser1;
semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, ser1, "-ro", EsN0, ber1, "-r*");
title("16-PSK载波调制信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率", "理论误比特率")