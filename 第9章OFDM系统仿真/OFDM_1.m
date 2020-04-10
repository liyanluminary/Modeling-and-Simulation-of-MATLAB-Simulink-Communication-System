clear all
N = 8; %子载波数
f = 1:N; %子载波上的数据
x = randi([0,3],1,N); %子载波上的数据
x1 = qammod(x,4); %4-QAM调制

t = 0:0.001:1-0.001; %符号持续时间
w = 2*pi*f.'*t; 
w1 = 2*pi*(f+0.2).'*t; %频偏为0.2Hz时的子载波频率
y = x1*exp(j*w); %子载波调制
plot(t,abs(y)); %画出调制后的波形包络

for ii=1:N
    y1(ii)=sum(y.*exp(-j*w(ii,:)))/length(t); %无频偏解调第ii个子载波上的数据
end

stem(abs(x1))
hold on
stem(abs(y1), 'r') %显示无频偏时子载波解调后的结果
title("频偏为0时的子载波解调后的结果")
axis = ([0 9 0 3])
legend("原始数据", "子载波解调后的数据")

%存在频率偏差时的子载波解调结果
for ii=1:N
    y3(ii)=sum(y.*exp(-j*w1(ii,:)))/length(t); %无频偏解调第ii个子载波上的数据
end

figure
stem(abs(x1))
hold on
stem(abs(y3), 'g') %显示频偏时子载波解调后的结果,结果不一样，说明OFDM对频率偏差反应敏感
title("频偏为0.2时的子载波解调后的结果")
axis = ([0 9 0 3])
legend("原始数据", "子载波解调后的数据")
