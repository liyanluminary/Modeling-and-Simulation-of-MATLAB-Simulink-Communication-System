%编码器输入有问题
clear all
EbN0 = 0:2:10; %SNR的范围
ber = berawgn(EbN0,'qam',16);
for ii=1:length(EbN0)
    ii
    BER=ber(ii); %赋值给BSC信道中的BER
    sim('RS_7'); %运行仿真模型
    ber1(ii)=BER(1);
end
semilogy(EbN0,ber,'-ko',EbN0,ber1,'-k*');
legend("未编码","RS(15,11)编码");
title("未编码和RS(15,11)编码的16-QAM在AWGN信道下的性能")
xlabel("Eb/N0");ylabel("误比特率");