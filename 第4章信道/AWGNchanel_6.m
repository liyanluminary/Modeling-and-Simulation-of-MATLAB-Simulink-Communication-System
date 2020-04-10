clear all
nSamp = 8; %矩阵脉冲的取样点数
numSymb = 1000000; %每种snr下传输的符号数
M=4; %QPSK的符号类型数
SNR=-3:3;
grayencod = [0 1 3 2] %Gray编码格式
for ii=1:length(SNR)
    msg = randsrc(1,numSymb,[0:3]);
    msg_gr = grayencod(msg+1);
    msg_tx = pskmod(msg_gr,M);
    msg_tx = rectpulse(msg_tx, nSamp);
    msg_rx = awgn(msg_tx,SNR(ii),"measured");
    msg_rx_down = intdump(msg_rx,nSamp);
    msg_gr_demod=pskdemod(msg_rx_down,M);
    [dumay graydecod] = sort(grayencod);graydecod = graydecod - 1;
    msg_demod = graydecod(msg_gr_demod+1);
    [errorBit BER(ii)] = biterr(msg, msg_demod,log2(M));
    [errorSym SER(ii)] = symerr(msg, msg_demod);
end
scatterplot(msg_tx(1:100))
title("发射信号星座图")
xlabel("同相分量")
ylabel("正交分量")
scatterplot(msg_rx(1:100))
title("接收信号星座图")
xlabel("同相分量")
ylabel("正交分量")
figure
semilogy(SNR,BER,"-ro", SNR,SER,"-r*")
legend("BER","SER")
title("QPSK在AWGN信道下的性能")
xlabel("信噪比（dB）")
ylabel("误符号率和误码率")