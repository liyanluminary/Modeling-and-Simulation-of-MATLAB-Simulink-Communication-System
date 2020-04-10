clear all

EbN0 = 0:10;

for ii=1:length(EbN0)
    SNR=EbN0(ii);
    sim("shuangjixingAWGN_5");
    ber(ii) = BER(1);
end

semilogy(EbN0,ber,"-ko", EbN0, qfunc(sqrt(10.^(EbN0/10))), "-k*", EbN0, qfunc(sqrt(2*10.^(EbN0/10))));
title("双极性信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率Pe");
legend("仿真结果", "正交信号理论误比特率", "双极性信号理论误比特率");