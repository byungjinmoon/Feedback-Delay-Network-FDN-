clear all; close all;
frameSizeMS = 30; % m,inimum frame length in ms
overlap = 0.5; % fraction of frame overlapping
windowType = 'hann'; % type of windowing used for each frame

% [x, fs]=audioread('home.mp3');
fs=44100;
x=zeros(1,3*fs);x(1)=1;
m1 =5647 ;
m2 =6043;
m3 = 7151 ;
m4 = 8513;

T_60_125=3.25;
g_m1=10^((-3*m1)/(T_60_m1*fs));
T_60_m2=2.75;
g_m2=10^((-3*m2)/(T_60_m2*fs));
T_60_m3=2.75;
g_m3=10^((-3*m3)/(T_60_m3*fs));
T_60_m4=1.8;        
g_m4=10^((-3*m4)/(T_60_m4*fs));

b=[1 1 1 1];
c=[1 1 1 1 ];

G1=[1 -1 -1 -1]*(1/2)*g_m1;
G2=[-1 1 -1 -1]*(1/2)*g_m2;
G3=[-1 -1 1 -1]*(1/2)*g_m3;
G4=[-1 -1 -1 1]*(1/2)*g_m4;




z1=zeros(1,m4);
z2=zeros(1,m4); 
z3=zeros(1,m4);
z4=zeros(1,m4); 
    
for n=1:length(x)
tmp=[z1(m1) z2(m2) z3(m3) z4(m4)];

y(n)=x(n)+c(1)*z1(m1)+c(2)*z2(m2)+c(3)*z3(m3)+c(4)*z4(m4);

z1=[tmp*G1'+x(n)*b(1) z1(1:length(z1)-1)];
z2=[tmp*G2'+x(n)*b(2) z2(1:length(z2)-1)];
z3=[tmp*G3'+x(n)*b(3) z3(1:length(z3)-1)];
z4=[tmp*G4'+x(n)*b(4) z4(1:length(z4)-1)];
    
end
    


plot(y);
% plot(t,h);
% calculate STFT frames

minFrameLen = fs*frameSizeMS/1000; 
frameLenPow = nextpow2(minFrameLen);
frameLen = 2^frameLenPow; % frame length = fft  size
eval(['frameWindow = ' windowType '(frameLen);']);
[B,F,T] = spectrogram(y,frameWindow,overlap*frameLen,2*100,fs);

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
figure(1),
 T=[0 T(1:length(B_EDRdb)-1)];
plot(T,B_EDRdb(1,:),'k')
grid;
xlabel('time');
ylabel('magnitude');
axis([0 3 -150 20]);
figure(2);clf;
mesh(T,F/1000,B_EDRdb);
view(130,30);
title('Energy Decay Relief (EDR)');
xlabel('Time (s)');ylabel('Frequency (kHz)');zlabel('Magnitude (dB)');
axis ([0 3 0 fs/2/1000 -150 20]);zoom on;