clear all
x = ones(1,10);
snr = 10;
y1 = awgn(x,snr,"measured",10);
y2 = awgn(x,snr,"measured",5);
y3 = awgn(x,snr,"measured",10);