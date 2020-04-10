% 离散时间信号
clear all
w = -4:0.001:4;
n1 = -15:15;
n2 = 0:20;
h1 = exp(-abs(0.1*n1));
h2(n2+1)=1;
Hjw1 = h1*exp(-j*pi).^(n1'*w);
Hjw2 = h2*exp(-j*pi).^(n2'*w);
subplot(2,1,1);plot(w,abs(Hjw1));
title("H1");xlabel("pi弧度(w)");ylabel("振幅");
subplot(2,1,2);plot(w,abs(Hjw2));
title("H2");xlabel("pi弧度(w)");ylabel("振幅");