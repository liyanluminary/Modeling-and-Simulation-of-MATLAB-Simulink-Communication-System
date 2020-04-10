clear all
m = 4;
n = 2^m-1; %码字长度
N = 10000; %消息行数
k = 11; %消息长度
t = (n-k)/2; %纠错能力
msg = randi([0,1],N,k); %消息符号
msg1 = gf(msg,m);
msg1 = rsenc(msg1,n,k).'; %(15,11)RS编码
msg2 = de2bi(double(msg1.x),'left-msb'); %转换为二进制
y = bsc(msg2,0.01); %通过二进制对称信道
y = bi2de(y,'left-msb'); %转换为十进制
y = reshape(y,n,N).';
dec_x = rsdec(gf(y,4),n,k); %RS译码
[err,ber] = biterr(msg,double(dec_x.x),m); %译码后的误比特率
