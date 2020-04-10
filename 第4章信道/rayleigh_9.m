clear all
fd = 10; %多普勒频移为10
ts = 1/1000;
t = 0:ts:1;
h1 = reyleigh(fd,t);

fd = 20; %多普勒频移为20
h2 = reyleigh(fd,t);

subplot(2,1,1);plot(20*log10(abs(h1(1:1000))))
title("fd = 10Hz是的信道功率谱曲线")
xlabel("时间");ylabel("功率")

subplot(2,1,2);plot(20*log10(abs(h2(1:1000))))
title("fd = 20Hz是的信道功率谱曲线")
xlabel("时间");ylabel("功率")

