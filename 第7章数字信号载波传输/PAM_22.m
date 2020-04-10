%有错
clear all

EsN0 = 0:15;
EsN01 = 10.^(EsN0/10);
SymbolRate = 2;
for ii=1:length(EsN0)
    SNR=EsN0(ii);
    sim("PAM_2");
    ber(ii)=BER(1);
    ser(ii)=SER(1);
end

semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, 1.5*qfunc(sqrt(0.4*EsN01)), "-ro");
title("4-PAM信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率")
