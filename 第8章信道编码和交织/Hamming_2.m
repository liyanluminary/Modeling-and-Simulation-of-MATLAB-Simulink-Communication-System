clear all
N = 100000; %信息比特的行数
M = 4; %QPSK调制
n = 7; %Hamming码组长度n=2^m-1
m = 3; %监督位长度
graycode = [0 1 3 2];

msg = randi([0,1],N,n-m); %产生比特数据
msg1 = reshape(msg.',log2(M),N*(n-m)/log2(M)).';
msg1_de = bi2de(msg1,'left-msb'); %消息比特转换为10进制形式
msg1 = graycode(msg1_de+1); %Gray编码
msg1 = pskmod(msg1,M); %QPSK调制
Eb1 = norm(msg1).^2/(N*(n-m)); %计算比特能量
msg2 = encode(msg,n,n-m); %Hamming编码
msg2 = reshape(msg2.',log2(M),N*n/log2(M)).';
msg2_de = bi2de(msg2,'left-msb'); %消息比特转换为10进制形式
msg2 = graycode(msg2_de+1); %Gray编码
msg2 = pskmod(msg2,M); %QPSK调制
Eb2 = norm(msg2).^2/(N*(n-m)); %计算比特能量
EbN0 = 0:2:20; %信噪比
EbN0_lin = 10.^(EbN0/10); %信噪比的线性值
for index=1:length(EbN0_lin)
    index
    sigma1 = sqrt(Eb1/(2*EbN0_lin(index))); %未编码的噪声标准差
    rx1 = msg1+sigma1*(randn(1,length(msg1))+j*randn(1,length(msg1))); %加入高斯白噪声
    y1 = pskdemod(rx1,M); %未编码QPSK解调
    y1_de = graycode(y1+1); %未编码的Gray逆映射
    [err ber1(index)] = biterr(msg1_de.',y1_de,log2(M)); %未编码的误比特率
    
    sigma2 = sqrt(Eb2/(2*EbN0_lin(index))); %编码的噪声标准差
    rx2 = msg2+sigma2*(randn(1,length(msg2))+j*randn(1,length(msg2))); %加入高斯白噪声
    y2 = pskdemod(rx2,M); %编码QPSK解调
    y2 = graycode(y2+1); %编码的Gray逆映射
    y2 = de2bi(y2,'left-msb'); %转换为二进制形式
    y2 = reshape(y2.',n,N).';
    y2 = decode(y2,n,n-m); %译码
    [err ber2(index)] = biterr(msg,y2); %未编码的误比特率
end

semilogy(EbN0,ber1,'-ko',EbN0,ber2,'-k*');
legend("未编码","Hamming(7,4)编码");
title("未编码和Hamming(7,4)编码的QPSK在AWGN信道下的性能")
xlabel("Eb/N0");ylabel("误比特率");

%结果分界原因是编码增益开始小于信噪比带来的影响

