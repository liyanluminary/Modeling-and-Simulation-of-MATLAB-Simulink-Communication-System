clear all
n = 0:40;
h = exp(-0.1*n);
x = exp(-0.2*n);
y = conv(h,x);
subplot(3,1,1);stem(h);title("h")
subplot(3,1,2);stem(x);title("x")
subplot(3,1,3);stem(y);title("y")