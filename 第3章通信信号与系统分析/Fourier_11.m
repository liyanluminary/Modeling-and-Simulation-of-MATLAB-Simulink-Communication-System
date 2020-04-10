% 离散时间信号
% 卷积特性
clear all
w = -1:0.001:1;
n = 0:30;
h = sinc(0.2*n);
x = 2*sin(0.2*pi*n)+3*cos(0.4*pi*n);
Hjw = h*(exp(-j*pi).^(n'*w));
Xjw = x*(exp(-j*pi).^(n'*w));
Yjw = Xjw.*Hjw;
n1 = 0:2*length(n)-2;
dw = 0.001*pi;
y = (dw*Yjw*(exp(j*pi).^(w'*n1)))/(2*pi);
y1 = conv(x,h);

subplot(3,1,1);plot(w,abs(Hjw));
title("H");xlabel("pi弧度(w)");ylabel("振幅");
subplot(3,1,2);plot(w,abs(Xjw));
title("X");xlabel("pi弧度(w)");ylabel("振幅");
subplot(3,1,3);plot(w,abs(Yjw));
title("Y");xlabel("pi弧度(w)");ylabel("振幅");

figure
subplot(2,1,1);stem(abs(y));title("通过IDTFT计算出的输出序列Y");
subplot(2,1,2);stem(abs(y1));title("通过时域卷积计算出的输出序列Y1");