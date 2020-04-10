clear all

EbN0 = 0:12

for ii=1:length(EbN0)
    SNR=EbN0(ii);
    sim("zhengjiaoAWGN_3");
    ber(ii) = BER(1);
end

semilogy(EbN0,ber,"-ko", EbN0, qfunc(sqrt(10.^(EbN0/10))));
title("二进制正交信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率Pe");
legend("仿真结果", "理论结果");