clear all; 
close all;

% impulse test
fs=44100;
x=zeros(1,fs*4);
x(1)=1;
% audio test
%  [x, fs]=audioread('home_16000.mp3');
%  x=x(1:fs*6,1)'*0.6;

% RT , Desired delay
RT=3.25;
%delay samples setting
M=0.15*RT*fs;%(M=~m1,m2,m3,m4)M is more higher than each of delay samples, and each of delay sameples are coprime.
%filter design_sampling frequecny method
m1 =5647 ;
m2 =6043;
m3 =7151 ;
m4 =8513;
m=[m1 m2 m3 m4];

%first - order IIR filter design
for i=1 : 4
    T_60_DC=3.25;
    g_dc=10^((-3*m(i))/(T_60_DC*fs));
    T_60_Ny=0.7;
    g_ny=10^((-3*m(i))/(T_60_Ny*fs));
    p_i(i)= (g_dc-g_ny)/(g_ny+g_dc);
    g_i(i) =g_ny+g_ny*p_i(i); 

    b= g_i(i);
    a=[1,-p_i(i)];
%     [H,f] = freqz(b,a,128,'whole',fs);
%     figure(i), plot(f/(fs/2), abs(H), 'k');
% 
%     axis([0 fs/2 0 1]);
%     xlabel('Frequency [Hz]'); ylabel('Magnitude');
%     legend('Frequency response of filter H');
%     grid;
end

%% PARAPETER
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

%FDN implementation (IIR)
y1_buffer=0;
y2_buffer=0;
y3_buffer=0;
y4_buffer=0;

z1=zeros(1,m1);
z2=zeros(1,m2); 
z3=zeros(1,m3);
z4=zeros(1,m4);

for n=1:length(x)

    y1_buffer=p_i(1)*y1_buffer+g_i(1)*z1(m1);
    y2_buffer=p_i(2)*y2_buffer+g_i(2)*z2(m2);
    y3_buffer=p_i(3)*y3_buffer+g_i(3)*z3(m3);
    y4_buffer=p_i(4)*y4_buffer+g_i(4)*z4(m4);

    tmp=[y1_buffer y2_buffer y3_buffer y4_buffer];

    z1=[tmp*G1'+x(n)*b z1(1:length(z1)-1)];
    z2=[tmp*G2'+x(n)*b z2(1:length(z2)-1)];
    z3=[tmp*G3'+x(n)*b z3(1:length(z3)-1)];
    z4=[tmp*G4'+x(n)*b z4(1:length(z4)-1)];

    y(n)=d*x(n)+c(1)*tmp(1)+c(2)*tmp(2)+c(3)*tmp(3)+c(4)*tmp(4);

end

% sound(y,fs);
% audiowrite('4channel_IIR_respect.wav', y, 16000);
