clear all
nsamp = 10;

s0 = zeros(1,nsamp);
s1 = ones(1,nsamp);

nsymbol = 100000;

EbN0 = 0:10;
msg = randi([0,1],1,nsymbol);
s00 = zeros(nsymbol,1);
s11 = zeros(nsymbol,1);
indx = find(msg==0);
s00(indx)=1;
s00 = s00*s0;
indx1 = find(msg==1);
s11(indx1)=1;
s11 = s11*s1;
s = s00 + s11;
s = s.';

for indx=1:length(EbN0)
    demsg = zeros(1,nsymbol);
    r = awgn(s,EbN0(indx)-7);
    r00 = s1*r;
    indx1 = find(r00>5);
    demsg(indx1)=1;
    [err,ber(indx)] = biterr(msg,demsg);
end

semilogy(EbN0,ber,"-ko", EbN0, qfunc(sqrt(10.^(EbN0/10)/2)), "-k*", EbN0, qfunc(sqrt(10.^(EbN0/10))), "-ro", EbN0, qfunc(sqrt(2*10.^(EbN0/10))), "-b+");
title("单极性信号在AWGN信道下的误比特率性能")
xlabel("EbN0");
ylabel("误比特率Pe");
legend("仿真结果", "单极性信号理论误比特率", "正交信号理论误比特率", "双极性信号理论误比特率");
