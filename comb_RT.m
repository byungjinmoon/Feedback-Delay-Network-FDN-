clear all;close all;clc;

%% Impulse response of comb filter
%make impulse
fs=1000;
x=zeros(1,fs*1.5); 
x(1)=1;
%gain and delay for reverberation time
mdelay=30;
T_60=1.2;
g= 10^((-3)*mdelay/(T_60*fs));

%implementation of comb filter(IIR filter)
buf=zeros(1,mdelay);
for n=1:length(x)
    y(n)=buf(mdelay)*g+x(n);%A=(y(n-mdelay)*g)
    buf=[y(n) buf(1:mdelay-1)];
end

%% confirmation of db attenuation during reveberation time
t= 0:1/fs:1.5;
db=zeros(1,length(t));
for n=1:mdelay:length(y)
db(n)=20*log10(abs(y(n)));
end


%% Result plot
subplot(2,1,1);
plot(y)
title('Impulse response of comb filter');
xlabel('sample');ylabel('Amplitude');

subplot(2,1,2);
plot(t,db);
title('60dB reduction of impulse response')
xlabel('t(sec)');
ylabel('level(dB)');