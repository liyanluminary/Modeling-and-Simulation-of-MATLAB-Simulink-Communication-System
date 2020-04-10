function [mout] = mseq(n,taps,inidata,num)
%MSEQ 此处显示有关此函数的摘要
%   n:m序列的阶数
%   taps:反馈寄存器的连接位置
%   inidata:寄存器的初始序列
%   num:输出m序列的个数
%   mout:输出的m序列，如果num>1,则第一行为一个m序列
if nargin < 4
    num = 1;
end

mout = zeros(num,2^n-1);
fops = zeros(n,1);
fops(taps) = 1;

for ii=1:2^n-1
    mout(1,ii) = inidata(n);  %寄存器的输出序列
    temp = mod(inidata*fops,1);  %计算反馈数据
    inidata(2:n) = inidata(1:n-1); %寄存器移位一次
    inidata(1) = temp; %更新第一个寄存器的值
end

if num > 1
    for ii=2:num
        mout(ii,:) = shift(mout(ii-1,:),1);
    end
end
end

