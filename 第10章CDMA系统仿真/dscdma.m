%直接序列扩频主程序代码
function [ber] = dscdma(user,seq)
%DSCDMA 此处显示有关此函数的摘要
%   此处显示详细说明
%   user:同时进行扩频通信的用户数
%   seq：扩频码1：m-序列  扩频码2：Gold-序列  扩频码3：正交Gold-序列
%   ber：该用户数下的误码率

%初始化
sr = 256000.0; %符号速率
nSymbol = 10000; %每种信噪比下发送的符号数
M = 4; %4-QAM调制
br = sr*log2(M); %比特速率
graycode = [0 1 3 2]; %Gray编码规则
EbNo = 0:2:10; %Eb/N0变化范围

%%%脉冲成形滤波器参数%%%
delay = 10; %升余弦滤波器时延
Fs = 8; %滤波器过采样数
rolloff = 0.5; %升余弦滤波器滚降因子
rrcfilter = rcosine(1,Fs,'fir/sqrt',rolloff,delay); %设计根升余弦滤波器

%%%扩频码产生参数%%%
user = 4; %用户数
stage = 3; %m序列的阶数
ptap1 = [1 3]; %m序列1的寄存器连接方式
ptap2 = [2 3]; %m序列2的寄存器连接方式
regi1 = [1 1 1]; %m序列1的寄存器初始值
regi2 = [1 1 1]; %m序列1的寄存器初始值

%%%扩频码的生成%%%
switch seq
case 1 %M序列
    code = mseq(stage,ptap1,regi1,user);
case 2
    m1 = mseq(stage,ptap1,regi1); %Gold序列
    m2 = mseq(stage,ptap2,regi2);
    code = goldseq(m1,m2,user);
case 3
    m1 = mseq(stage,ptap1,regi1); %正交Gold序列
    m2 = mseq(stage,ptap2,regi2);
    code = [goldseq(m1,m2,user),zeros(user,1)];
end
code = code*2-1;
clen = length(code);

%%%衰落信道参数%%%
ts = 1/Fs/sr/clen; %采样时间间隔
t = (0:nSymbol*Fs*clen-1+2*delay*Fs)*ts; %每种信噪比下的符号传输时间
% fd=160; %多普勒频移[HZ]
% h=rayleigh(fd,t); %生成衰落信道

%%%仿真开始%%
for indx=1:length(EbNo)

%发射端
data = randsrc(user,nSymbol,0:3); %产生各个用户的发射数据
data1 = graycode(data+1); %Gray编码
data1 = qammod(data1,M); %4-QAM调制
[out] = spread(data1,code); %扩频

out1 = rcosflt(out.',sr,Fs*sr,'filter',rrcfilter); %通过脉冲成形滤波器
spow = sum(abs((out1)).^2)/nSymbol; %计算每个用户信号功率
if user>1
    out1 = sum(out1.'); %用户数大于1，所有用户数据相加
else 
    out1 = out1.';
end

%%%通过瑞利衰落信道%%
% out1=h.*out1;
%接收端
sigma = sqrt(0.5*spow*sr/br*10^(-EbNo(indx)/10)); %根据信噪比计算高斯白噪声方差
y = [];
for ii=1:user
y(ii,:) = out1+sigma(ii).*(randn(1,length(out1))+j*randn(1,length(out1))); %加入高斯白噪声（AWGN）
% y(ii,:)=y(ii,:)./h; %假设理想信道估计
end

y = rcosflt(y.',sr,Fs*sr,'Fs/filter',rrcfilter); %通过脉冲成形滤波器滤波
y = downsample(y,Fs); %降采样
for ii=1:user
    y1(:,ii)=y(2*delay+1:end-2*delay,ii);
end

yd = despread(y1.',code); %数据解扩
demodata = qamdemod(yd,M); %4-QAM解调
demodata = graycode(demodata+1); %Gray编码逆映射

[err,ber(indx)] = biterr(data(1,:),demodata(1,:),log2(M));
end


