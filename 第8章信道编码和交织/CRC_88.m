clear all
EbN0 = 0:2:10; %SNR的范围
ber = berawgn(EbN0,'qam',16);
for ii=1:length(EbN0)
    ii
    BER=ber(ii); %赋值给BSC信道中的BER
    sim('CRC_8'); %运行仿真模型
    pmissed(ii)=MissedFrame(end)/length(MissedFrame);
end
semilogy(EbN0,pmissed)
title("CRC-16检错性能")
xlabel("Eb/N0");ylabel("漏检概率");
% axis([0 8 10.^(-6) 10.^(-3)])