clear all
N = 10000; %发送的帧数
L = 16; %一帧中的消息比特数
poly = [1 1 1 0 1 0 1 0 1]; %CRC生成多项式
N1 = length(poly)-1; %CRC码的长度
EbN0 = 0:2:10;
ber = berawgn(EbN0,'qam',16);

for index=1:length(ber)
    index
    pe = ber(index) %BSC信道错误概率
    err = zeros(1,N); %传输的帧是否产生误码
    err1 = zeros(1,N); %通过CRC校验传输的帧是否产生误码
    for iter=1:N
        msg = randi([0,1],1,L); %消息比特
        msg1 = [msg zeros(1,N1)]; %消息比特左移
        [q,r] = deconv(msg1,poly); %用多项式除法求CRC校验，q为商，r为余数
        r = mod(abs(r),2); %进行模2处理
        crc = r(L+1:end); %CRC校验码
        frame = [msg crc]; %发送帧
        x = bsc(frame,pe); %通过BSC信道
        [q1,r1] = deconv(x,poly); %接受序列除以多项式
        r1 = mod(abs(r1),2); %模2处理
        err(iter)=biterr(frame,x); %统计本帧是否产生误码
        err1(iter)=sum(r1); %通过CRC统计是否产生误码
    end
    fer1(index)=sum(err~=0); %误帧率
    fer2(index)=sum(err1~=0); %通过CRC统计误帧率
end

pnissed=(fer1-fer2)/N; %CRC漏检的概率
semilogy(EbN0,pnissed)
title("CRC-8检错性能")
xlabel("Eb/N0");ylabel("漏检概率");
    