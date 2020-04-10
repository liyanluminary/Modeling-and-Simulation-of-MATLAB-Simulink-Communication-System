%扩频函数
function[out]=spread(data,code)
%DSCDMA 此处显示有关此函数的摘要
%   此处显示详细说明
%   data :输入数据序列
%   code :扩频码序列
%   out :输出数据序列

switch nargin
case{0,1} %如果输入参数个数不对，报错
error('缺少输入参数');
end

[hn,vn] = size(data);
[hc,vc] = size(code);

if hn>hc %扩频码数小于输入的待扩频数据序列，报错
    error('缺少扩频码序列');
end

out = zeros(hn,vn*vc);

for ii=1:hn
    out(ii,:)=reshape(code(ii,:).'*data(ii,:),1,vn*vc);
end