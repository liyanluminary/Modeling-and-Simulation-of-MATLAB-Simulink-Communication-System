clear all
n = 0:40;
x1 = sin(2*pi*0.1*n);
x2 = exp(-0.1*n);
x = x1 + x2;
y = x1.*x2;
subplot(4,1,1);stem(n,x1);title("x1")
subplot(4,1,2);stem(n,x2);title("x2")
subplot(4,1,3);stem(n,x);title("x")
subplot(4,1,4);stem(n,y);title("y")