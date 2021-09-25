clear all; 
close all;
%impulse test
fs=44100;   
x=zeros(1,fs*5);x(1)=1;

% %audio sample
% [x, fs]=audioread('home.mp3');
% x=x(1:fs*10);
% x=x';

src_to_lis=20;%ex)20m
d=1/src_to_lis;
k=0.98;%reflection coefficient
b=k.^4/src_to_lis;%att=k^m/distance (m=4)
c=[1 1 1 1 ];%only set attenuation b 

%hardamard matrix
G1=[0 1 1 0]*(1/sqrt(2));
G2=[-1 0 0 -1]*(1/sqrt(2));
G3=[1 0 0 -1]*(1/sqrt(2));
G4=[0 1 -1 0]*(1/sqrt(2));

%reverberation time of frequency
T_60_125=3.25;
T_60_500=2.75;
T_60_2000=2.75;

%delay samples setting
M=0.15*T_60_125*fs;%(M=~m1,m2,m3,m4)M is more higher than each of delay samples, and each of delay sameples are coprime.
%filter design_sampling frequecny method
m1 =5647 ;
m2 =6043;
m3 = 7151 ;
m4 = 8513;

%FIR filter 설계
filter_fs = 44100;
freq = [0 125 500 2000 filter_fs/2 ]/(filter_fs/2);
N = 128;%128차
%H1
g_125=10^((-3*m1)/(T_60_125*filter_fs));
g_500=10^((-3*m1)/(T_60_500*filter_fs)); 
g_2000=10^((-3*m1)/(T_60_2000*filter_fs));
mag = [1 g_125 g_500 g_2000 0];
coef = fir2(N, freq, mag);
h1=coef;

%H2
g_125=10^((-3*m2)/(T_60_125*filter_fs));
g_500=10^((-3*m2)/(T_60_500*filter_fs)); 
g_2000=10^((-3*m2)/(T_60_2000*filter_fs));
mag = [1 g_125 g_500 g_2000 0];
coef = fir2(N, freq, mag);
h2=coef;

%H3
g_125=10^((-3*m3)/(T_60_125*filter_fs));
g_500=10^((-3*m3)/(T_60_500*filter_fs)); 
g_2000=10^((-3*m3)/(T_60_2000*filter_fs));
mag = [1 g_125 g_500 g_2000 0];
coef = fir2(N, freq, mag);
h3=coef;

%H4
g_125=10^((-3*m4)/(T_60_125*filter_fs));
g_500=10^((-3*m4)/(T_60_500*filter_fs)); 
g_2000=10^((-3*m4)/(T_60_2000*filter_fs));
mag = [1 g_125 g_500 g_2000 0];
coef = fir2(N, freq, mag);
h4=coef;

% %figure
% [H,f]=freqz(coef,1,128,'whole',fs);
% figure, plot(f/(filter_fs/2), abs(H), 'k');
% axis([0 1 0 1]);
% xlabel('Frequency [Hz]'); ylabel('Magnitude');
% legend('Frequency response of filter H');
% grid;


%frequency dependent FDN design(FIR)
z1=zeros(1,m1);
z2=zeros(1,m2); 
z3=zeros(1,m3);
z4=zeros(1,m4);

B1=zeros(1,length(h1));
B2=zeros(1,length(h2));
B3=zeros(1,length(h3));
B4=zeros(1,length(h4));

for n=1:length(x)

B1=[z1(m1),B1(1:length(B1)-1)];
B2=[z2(m2),B2(1:length(B2)-1)];
B3=[z3(m3),B3(1:length(B3)-1)];
B4=[z4(m4),B4(1:length(B4)-1)];

tmp=[B1*h1' B2*h2' B3*h3' B4*h4'];%FIR filter 적용

z1=[tmp*G1'+x(n)*b z1(1:length(z1)-1)];
z2=[tmp*G2'+x(n)*b z2(1:length(z2)-1)];
z3=[tmp*G3'+x(n)*b z3(1:length(z3)-1)];
z4=[tmp*G4'+x(n)*b z4(1:length(z4)-1)];

y(n)=d*x(n)+c(1)*tmp(1)+c(2)*tmp(2)+c(3)*tmp(3)+c(4)*tmp(4);
end

% Energy Delay Relief
frameSizeMS = 30; % m,inimum frame length in ms
overlap = 0.5; % fraction of frame overlapping
windowType = 'hann'; % type of windowing used for each frame
minFrameLen = fs*frameSizeMS/1000; 
frameLenPow = nextpow2(minFrameLen);
frameLen = 2^frameLenPow; % frame length = fft  size
eval(['frameWindow = ' windowType '(frameLen);']);
[B,F,T] = spectrogram(y,frameWindow,overlap*frameLen,200,fs);
[nBins,nFrames] = size(B);
B_energy = B.*conj(B);
B_EDR = zeros(nBins,nFrames);
for i=1:nBins
    B_EDR(i,:) = fliplr(cumsum(fliplr(B_energy(i,:))));
end
B_EDRdb = 10*log10(abs(B_EDR));


figure(1),
T=[0 T(1:length(B_EDRdb)-1)];
plot(T,B_EDRdb(9,:),'k') %1 -->125Hz, 2-->200Hz, 9-->2000Hz
grid;
xlabel('time');
ylabel('magnitude');
axis([0 5 -120 0]);



figure(2);clf;
mesh(T,F/1000,B_EDRdb);
view(130,30);
title('Energy Delay Relief (EDR)');
xlabel('Time (s)');ylabel('Frequency (kHz)');zlabel('Magnitude (dB)');
axis tight;zoom on;
