clear all
N1 = 2000;
N2 = 100;
x = randn(N2,N1);
for ii=1:N2
    y(ii,1)=x(ii,1);
    for jj=2:N1
        y(ii,jj)=0.6*y(ii,jj-1)+x(ii,jj);
    end
    [Ry(ii,:),lags]=xcorr(y(ii,:),50,"coeff");
    Sf(ii,:)=fftshift(abs(fft(Ry(ii,:))));
end

Ry_av = sum(Ry)/N2;
Sf_av = sum(Sf)/N2;
subplot(2,1,1);plot(lags,Ry_av);title("自相关函数")
subplot(2,1,2);plot(lags,Sf_av);title("功率谱密度")
% axis([-50 50 0 2])