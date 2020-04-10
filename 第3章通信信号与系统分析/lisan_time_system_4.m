clear all
N = 60;
x1 = zeros(1,N);
x1(1) = 1;
x2 = zeros(1,N);
x2(1:41)=exp(-0.1*(0:40));
y1(1) = x1(1);
y2(1) = x2(1);
for n = 2:N
    y1(n) = 0.8*y1(n-1)+x1(n);
    y2(n) = 0.8*y2(n-1)+x2(n);
end
subplot(4,1,1);stem(x1);title("x1")
subplot(4,1,2);stem(x2);title("x2")
subplot(4,1,3);stem(y1);title("y1")
subplot(4,1,4);stem(y2);title("y2")
    
    