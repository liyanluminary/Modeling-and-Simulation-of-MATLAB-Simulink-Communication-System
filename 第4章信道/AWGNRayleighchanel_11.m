clear all
snr=-3:3;
Simulationtime=10;
AWGNchanel_7;
ser1 = ser;ber1 = ber;
for ii=1:length(snr)
    SNR=snr(ii)
    sim("awgnrayleighmodel");
    ber(ii)=BER(1);
    ser(ii)=SER(1);
end
figure
semilogy(snr,ber,"-ro", snr,ser,"-r*",snr,ber1,"-r.", snr,ser1,"-r+")
legend("Rayleigh衰落+AWGN信道BER","Rayleigh衰落+AWGN信道SER","AWGN信道BER","AWGN信道SER")
title("QPSK在AWGN信道和Rayleigh衰落信道下的性能")
xlabel("信噪比(dB)")
ylabel("误符号率和误码率")