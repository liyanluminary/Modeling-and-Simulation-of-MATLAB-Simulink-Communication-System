clear all
EbN0 = 0:2:10; %SNR范围
N = 1000000; %消息比特个数
M = 2; %BPSK调制
L = 7; %约束长度
tre1 = poly2trellis(L,[171 133]); %卷积码的生成多项式
tblen = 6*L; %Viterbi译码器回溯深度
msg = randi([0,1],1,N); %消息比特序列
msg1 = convenc(msg,tre1); %卷积编码
x1 = pskmod(msg1,M); %BPSK调制
for ii=1:length(EbN0)
    ii
    y = awgn(x1,EbN0(ii)-3); %加入高斯白噪声，因为码率为1/2，所以每个符号的能量要比比特能量减少3dB
    y1 = pskdemod(y,M); %硬判决
    y1 = vitdec(y1,tre1,tblen,'cont','hard'); %Viterbi译码
    [err ber1(ii)] = biterr(y1(tblen+1:end),msg(1:end-tblen)); %误比特率
    
    y2 = vitdec(real(y),tre1,tblen,'cont','unquant'); %Viterbi译码
    [err ber2(ii)] = biterr(y2(tblen+1:end),msg(1:end-tblen)); %误比特率
end
ber = berawgn(EbN0,'psk',2,'nodiff'); %BPSK调制的理论误比特率
semilogy(EbN0,ber,'-ko',EbN0,ber1,'-k*',EbN0,ber2,'-k+');
legend("BPSK调制的理论误比特率","硬判决误比特率","软判决误比特率");
title("卷积码性能")
xlabel("Eb/N0");ylabel("误比特率");
    
    
    