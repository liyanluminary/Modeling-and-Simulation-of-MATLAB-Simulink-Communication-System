clear all
snr=-3:3;
Simulationtime=10;
for ii=1:length(snr)
    SNR=snr(ii)
    sim("awgnmodel");
    ber(ii)=BER(1);
    ser(ii)=SER(1);
end
figure
semilogy(snr,ber,"-ro", snr,ser,"-r*")
legend("BER","SER")
xlabel("信噪比(dB)")
ylabel("误符号率和误码率")