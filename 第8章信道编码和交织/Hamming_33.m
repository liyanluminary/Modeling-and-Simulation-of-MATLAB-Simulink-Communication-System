clear all
EbN0 = 0:2:10; %SNR范围
SymbolRate = 50000; %符号速率
for ii=1:length(EbN0)
    ii
    SNR=EbN0(ii); %赋值给AWGN信道模块中的SNR
    sim('Hamming_3'); %运行仿真模型
    ber1(ii)=BER1(1);
    ber2(ii)=BER2(2);
end

semilogy(EbN0,ber1,'-ko',EbN0,ber2,'-k*');
legend("未编码","Hamming(7,4)编码");
title("未编码和Hamming(7,4)编码的QPSK在AWGN信道下的性能")
xlabel("Eb/N0");ylabel("误比特率");
