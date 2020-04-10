clear all
M=4;
msg = [1 2 3 0 3 2 1 1]; %消息信号
ts = 0.01; %抽样时间间隔
T = 1; %符号周期
t = 0:ts:T; %符号持续时间向量
x = 0:ts:length(msg); %所有符号的传输时间
fc = 1; %载波频率
c = sqrt(2/T)*exp(j*2*pi*fc*t); %载波信号
msg_psk = pskmod(msg,M).'; %基带4-PSK调制
msg_dpsk = dpskmod(msg,M).'; %基带4-DPSK调制
tx_psk = real(msg_psk*c); %载波调制
tx_psk= reshape(tx_psk.',1,length(msg)*length(t));
tx_dpsk = real(msg_dpsk*c); %载波调制
tx_dpsk= reshape(tx_dpsk.',1,length(msg)*length(t));
subplot(2,1,1)
plot(x,tx_psk(1:length(x)));
title("4PSK信号波形")
xlabel("时间t");ylabel("载波振幅");
subplot(2,1,2)
plot(x,tx_dpsk(1:length(x)));
title("4DPSK信号波形")
xlabel("时间t");ylabel("载波振幅");