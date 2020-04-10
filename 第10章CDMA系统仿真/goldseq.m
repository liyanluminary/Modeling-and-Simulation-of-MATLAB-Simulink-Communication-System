function [gout] = goldseq(m1,m2,num)
%GOLDSEQ 此处显示有关此函数的摘要
%   此处显示详细说明
%   m1:m序列1
%   m2:m序列2
%   num：生成的Gold序列个数
%   gout：生成的Gold序列输出
if nargin < 3  %如果没有指定生成的Gol序列个数，默认为1
    num = 1;
end
gout =zeros(num,length(m1));
for ii=1:num %根据Gold序列生成方法生成Gold序列
    gout(ii,:) = xor(m1,m2);
    m2 = shift(m2,1);
end

