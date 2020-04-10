clear all
N1 = 2000;
N2 = 100;
x = randn(N2,N1);
for ii=1:N2
    [Rx(ii,:),lags]=xcorr(x(ii,:),50,"coeff");
    Sf(ii,:)=fftshift(abs(fft(Rx(ii,:))));
end

Rx_av = sum(Rx)/N2;
Sf_av = sum(Sf)/N2;
subplot(2,1,1);plot(lags,Rx_av);title("自相关函数")
subplot(2,1,2);plot(lags,Sf_av);title("功率谱密度")
axis([-50 50 0 2])