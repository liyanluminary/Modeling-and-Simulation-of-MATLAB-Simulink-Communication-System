clear all
nsamp = 10; %每个脉冲信号的抽样点数

nsymbol = 100000; %每种SNR下发送的符号数

M=4; %4-PAM
graycode = [0 1 3 2];
EsN0 = 0:15;
msg = randi([0,1],1,nsymbol);
msg1 = graycode(msg+1); % Gray映射
msg2 = pammod(msg1, M); %4-PAM调制
s = rectpulse(msg2,nsamp); %矩形脉冲波形

for indx=1:length(EsN0)
    demsg = zeros(1,nsymbol);
    r = awgn(real(s),EsN0(indx)-7, "measured");
    r1 = intdump(r,nsamp); %相关器输出
    msg_demod=pamdemod(r1,M); %判决
    demsg = graycode(msg_demod+1);
    [err,ber(indx)] = biterr(msg,demsg,log2(M));
    [err,ser(indx)] = symerr(msg,demsg);
end

semilogy(EsN0,ber,"-ko", EsN0, ser, "-k*", EsN0, 1.5*qfunc(sqrt(0.4*10.^(EsN0/10))), "-ro");
title("4-PAM信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率P和误符号率");
legend("误比特率", "误符号率", "理论误符号率")


