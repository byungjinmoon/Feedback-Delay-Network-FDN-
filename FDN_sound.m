
clear all; close all;
%% FDN 
%Test for impulse signal
fs=16000;
x=zeros(1,3*fs);x(1)=1;

%Test for audio signal
% [x, fs]=audioread('home.mp3');
% x=x(1:fs*30);
% x=x';

%set parameters
src_to_lis=20;%ex)3m
d=1/src_to_lis;
k=0.98;%reflection coefficient
b=k.^4/src_to_lis;%att=k^m/distance (m=4)
c=[1 1 1 1 ];%only set attenuation b 

%gain and delay for reverberation time
T_60=2;
m4=round(src_to_lis/(340.29)*fs);%Del = src_to_lis/velocity of sound * sampling frequency
m3=round((m4/1.5));
m2=round((m3/1.5));
m1=round((m2/1.5));
m_list=[m1 m2 m3 m4];
for n=1:length(m_list)
   gains(n)= 10^((-3)*m_list(n)/(T_60*fs));
end
% gains=[0.8,0.6,0.5,0.4];
%Hadamard matrix
G1=[0 1 1 0]*(1/sqrt(2))*gains(1);
G2=[-1 0 0 -1]*(1/sqrt(2))*gains(2);
G3=[1 0 0 -1]*(1/sqrt(2))*gains(3);
G4=[0 1 -1 0]*(1/sqrt(2))*gains(4);

%implemenation FDN
z1=zeros(1,m_list(1));
z2=zeros(1,m_list(2)); 
z3=zeros(1,m_list(3));
z4=zeros(1,m_list(4)); 

for n=1:length(x)
y(n)=d*x(n)+c(1)*z1(m1)+c(2)*z2(m2)+c(3)*z3(m3)+c(4)*z4(m4);
tmp=[z1(m1) z2(m2) z3(m3) z4(m4)];
z1=[tmp*G1'+x(n)*b z1(1:length(z1)-1)];
z2=[tmp*G2'+x(n)*b z2(1:length(z2)-1)];
z3=[tmp*G3'+x(n)*b z3(1:length(z3)-1)];
z4=[tmp*G4'+x(n)*b z4(1:length(z4)-1)];
end

%% confirmation of db attenuation during reveberation time

t= 0:1/fs:length(x)/fs;
db=zeros(1,length(t));
for n=1:m4:length(y)
db(n)=20*log10((abs(y(n))/abs(y(1)))); 
end

%% Result plot
subplot(2,1,1);
plot(y)
title('Room impulse response');
xlabel('time');ylabel('Amplitude');

subplot(2,1,2);
plot(t,db);
title('60dB reduction of impulse response')
xlabel('t(sec)');
ylabel('level(dB)');


%%
% plot(y);
% figure,
% plot(t,db);
% % axis([0 1.8 -60 0])
% xlabel('time');
% xlabel('time(sec)');
% ylabel('db');
% % 
% % figure,
% plot(y);
% y=y*10;
sound(y,fs);
audiowrite('home_reberv.wav', y, 44100);
%    
%    
%    