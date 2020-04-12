%仿真V-BLAST结构ZF检测算法性能，调制方式为QPSK
clear all
Nt = 4; %发射天线数
Nr = 4; %接收天线数
N = 10; %每帧的长度
L = 10000; %仿真的总帧数
EbN0 = 0:2:20;
M = 4; %QPSK调制
x = randi([0,1],N*L,Nt); %信源数据
s = pskmod(x,M,pi/4); %QPSK调制

for index=1:length(EbN0)
    s1 = [];
    s2 = [];
    s3 = [];
    for index1 = 1:L
        h = randn(Nt,Nr)+j*randn(Nt,Nr); %Rayleigh衰落信道
        h = h./sqrt(2); %信道系数归一化
        [q1,r1] = qr(h'); %信道QR分解
        r = r1(1:Nt,:)'; %矩阵R
        q = q1(:,1:Nt)'; %矩阵Q
        
        sigma1 = sqrt(1/(10.^(EbN0(index)/10))); %每根接收天线的高斯白噪声标准差
        n = sigma1*(randn(N,Nr)+j*randn(N,Nr)); %每根接收天线的高斯白噪声
        
        y = s((index1-1)*N+1:index1*N,:)*h*q'+n*q'; %信号通过信道
        
        y1 = y*inv(r); %无干扰消除时的ZF检测
        s1 = [s1;pskdemod(y1,M,pi/4)];
        
        %有干扰消除时的ZF检测
        y(:,Nt) = y(:,Nt)./(r(Nt,Nt)); %检测第Nt层
        y1(:,Nt) = pskdemod(y(:,Nt),M,pi/4); %解调第Nt层
        y(:,Nt) = pskmod(y1(:,Nt),M,pi/4); %对第Nt层解调结果重新进行调制
        y2 = y;
        y3 = y1;
        for jj=Nt-1:-1:1
            for kk=jj+1:Nt
                y(:,jj) = y(:,jj)-r(kk,jj).*y(:,kk); %非理想干扰消除
                y2(:,jj) = y2(:,jj)-r(kk,jj).*s((index1-1)*N+1:index1*N,kk); %理想干扰消除
            end
            y(:,jj) = y(:,jj)./r(jj,jj);
            y2(:,jj) = y2(:,jj)./r(jj,jj); %第jj层判决变量
            y1(:,jj) = pskdemod(y(:,jj),M,pi/4); %第jj层进行解调
            y3(:,jj) = pskdemod(y2(:,jj),M,pi/4);
            y(:,jj) = pskmod(y1(:,jj),M,pi/4); %第jj解调结果重新进行调制
            y2(:,jj) = pskmod(y3(:,jj),M,pi/4);
        end
        s2 = [s2;y1];
        s3 = [s3;y3];
    end
    
    [temp,ber1(index)] = biterr(x,s1,log2(M)); %无干扰消除时的系统误码
    [temp,ber2(index)] = biterr(x,s2,log2(M)); %非理想干扰消除时的系统误码
    [temp,ber3(index)] = biterr(x,s3,log2(M)); %理想干扰消除时的系统误码
    
    [temp,ber24(index)] = biterr(x(:,1),s2(:,1),log2(M)); %非理想干扰消除时第4层的系统误码
    [temp,ber23(index)] = biterr(x(:,2),s2(:,2),log2(M)); %非理想干扰消除时第3层的系统误码
    [temp,ber22(index)] = biterr(x(:,3),s2(:,3),log2(M)); %非理想干扰消除时第2层的系统误码
    [temp,ber21(index)] = biterr(x(:,4),s2(:,4),log2(M)); %非理想干扰消除时第1层的系统误码
    
    [temp,ber34(index)] = biterr(x(:,1),s3(:,1),log2(M)); %理想干扰消除时第4层的系统误码
    [temp,ber33(index)] = biterr(x(:,2),s3(:,2),log2(M)); %理想干扰消除时第3层的系统误码
    [temp,ber32(index)] = biterr(x(:,3),s3(:,3),log2(M)); %理想干扰消除时第2层的系统误码
    [temp,ber31(index)] = biterr(x(:,4),s3(:,4),log2(M)); %理想干扰消除时第1层的系统误码
    
end

semilogy(EbN0,ber1,'-ko',EbN0,ber2,'-ro',EbN0,ber3,'-go')
title('V-BLAST结构ZF检测算法性能')
legend('无干扰消除','非理想干扰消除', '理想干扰消除')
xlabel('信噪比Eb/N0')
ylabel('误比特率（BER）')

figure
semilogy(EbN0,ber34,'-ko',EbN0,ber33,'-ro',EbN0,ber32,'-go',EbN0,ber31,'-bo')
title('理想干扰消除ZF检测算法性能')
legend('第1层','第2层', '第3层', '第4层')
xlabel('信噪比Eb/N0')
ylabel('误比特率（BER）')

figure
semilogy(EbN0,ber24,'-ko',EbN0,ber23,'-ro',EbN0,ber22,'-go',EbN0,ber21,'-bo')
title('非理想干扰消除ZF检测算法性能')
legend('第1层','第2层', '第3层', '第4层')
xlabel('信噪比Eb/N0')
ylabel('误比特率（BER）')

            