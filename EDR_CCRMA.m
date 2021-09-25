frameSizeMS = 30; % m,inimum frame length in ms
overlap = 0.75; % fraction of frame overlapping
windowType = 'hann'; % type of windowing used for each frame

 [signal,fs] =audioread('speech.wav');

fs=100;
b=1;
order=9;
a=[1 zeros(1,order-1) -0.9];
[h,t]=impz(b,a);

% calculate STFT frames
minFrameLen = fs*frameSizeMS/1000; 
frameLenPow = nextpow2(minFrameLen);
frameLen = 2^frameLenPow; % frame length = fft  size
eval(['frameWindow = ' windowType '(frameLen);']);
[B,F,T] = spectrogram(h,frameWindow,overlap*frameLen,2*100,fs);

[nBins,nFrames] = size(B);

B_energy = B.*conj(B);

B_EDR = zeros(nBins,nFrames);
for i=1:nBins
    B_EDR(i,:) = fliplr(cumsum(fliplr(B_energy(i,:))));
end
B_EDRdb = 10*log10(abs(B_EDR));

% normalize EDR to 0 dB and truncate the plot below a given dB threshold
offset = max(max(B_EDRdb));
B_EDRdbN = B_EDRdb-offset;
B_EDRdbN_trunc = B_EDRdbN;

% for i=1:nFrames
%   I = find(B_EDRdbN(:,i) < (-60));
%   if (I )
%     B_EDRdbN_trunc(I,i) = (-60);
%   end
% end


figure(gcf);clf;
mesh(T,F/1000,B_EDRdb);
view(130,30);
title('Normalized Energy Decay Relief (EDR)');
xlabel('Time (s)');ylabel('Frequency (kHz)');zlabel('Magnitude (dB)');
axis tight;zoom on;