clear all
nSamp = 8; %矩阵脉冲的取样点数
numSymb = 1000000; %每种snr下传输的符号数
ts = 1/(numSymb*nSamp);
t = (0:numSymb*nSamp-1)*ts;

M=4; %QPSK的符号类型数
SNR=-3:3;
grayencod = [0 1 3 2] %Gray编码格式
for ii=1:length(SNR)
    msg = randsrc(1,numSymb,[0:3]);
    msg_gr = grayencod(msg+1);
    msg_tx = pskmod(msg_gr,M);
    msg_tx = rectpulse(msg_tx, nSamp);
    h = reyleigh(10,t);
    msg_tx1=h.*msg_tx;
    msg_rx = awgn(msg_tx,SNR(ii));
    msg_rx1 = awgn(msg_tx1,SNR(ii));
    msg_rx_down = intdump(msg_rx,nSamp);
    msg_rx_down1 = intdump(msg_rx1,nSamp);
    msg_gr_demod=pskdemod(msg_rx_down,M);
    msg_gr_demod1=pskdemod(msg_rx_down1,M);
    [dumay graydecod] = sort(grayencod);graydecod = graydecod - 1;
    msg_demod = graydecod(msg_gr_demod+1);
    msg_demod1 = graydecod(msg_gr_demod1+1);
    [errorBit BER(ii)] = biterr(msg, msg_demod,log2(M));
    [errorBit1 BER1(ii)] = biterr(msg, msg_demod1,log2(M));
    [errorSym SER(ii)] = symerr(msg, msg_demod);
    [errorSym1 SER1(ii)] = symerr(msg, msg_demod1);
end

semilogy(SNR,BER,"-ro", SNR,SER,"-r*",SNR,BER1,"-r.", SNR,SER1,"-r+")
legend("AWGN信道BER","AWGN信道SER","Rayleigh衰落+AWGN信道BER","Rayleigh衰落+AWGN信道SER")
title("QPSK在AWGN信道和Rayleigh衰落信道下的性能")
xlabel("信噪比（dB）")
ylabel("误符号率和误码率")