clc;
clear all;
close all;
%DSSS-BPSK Signal generation

%PN sequence
N=input("Enter the length of the PN sequence:");                %length of the PN sequence
c=input("Enter the PN sequence:");  %PN sequence

%Binary to polar mapping
for i=1:length(c)
    if c(i)==0
        cm(i)=-1;
    else
        cm(i)=1;
    end
end


%Information Bearing Signal
%b=randi([0 1],1,2);
b=[1 0];
ln=length(b);

x=1;
for i2=1:ln
    for j1=1:8
        bb(x)=b(i2);
        j1=j1+1;
        x=x+1;
    end
    i2=i2+1;
end
    
        
%DSSS-baseband mapping
m=[];
for k=1:length(b)
    if b(k)==0
        mm=-cm;
    else 
        mm=cm;
    end
    m=[m mm];
end


%NRZ pulse shaping
i=1;                %chip index in m
l=1/N;              %chip duration
S=700;               %samples per bit
t=0:1/S:length(b)-1/S;  %time duration

for j=1:length(t)
    if t(j)<=l
        y(j)=m(i);
    else
        y(j)=m(i);
        i=i+1;
        l=l+1/N;
    end
end

figure(1)
plot(t,y);
axis([0 length(b) -2 2]);
xlabel('time');
ylabel('amplitude');
title('DSSS baseband signal');

%QPSK modulation
%Since the sequence is in polar mapped form, we proceed with the
%demultiplexing of the signal i.e., to generate even and odd sequences.

%Separation of Even and Odd sequence
even_seq=m(1:2:length(m));
odd_seq=m(2:2:length(m));

%NRZ polar line coded signal generation
i1=1;
m1=2:2:length(m);
t1=0:0.01:length(m);
for k1=1:length(t1)
    if t1(k1)<=m1(i1)
        even_ps(k1)=even_seq(i1);
    else
        even_ps(k1)=even_seq(i1);
        i1=i1+1;
    end
end

i1=1;
m1=2:2:length(m);
for k1=1:length(t1)
    if t1(k1)<=m1(i1)
        odd_ps(k1)=odd_seq(i1);
    else
        odd_ps(k1)=odd_seq(i1);
        i1=i1+1;
    end
end

figure(2);
subplot(4,1,1);
plot(t1,even_ps,'r');
title('NRZ polar line coded signal for DSSS-even sequence');
xlabel('Time');
ylabel('Amplitude');

subplot(4,1,2)
plot(t1,odd_ps,'k');
title('NRZ polar line coded signal for DSSS-odd sequence');
xlabel('Time');
ylabel('Amplitude');

%Carrier Signal generation
T=2;
c1=sqrt(2/T)*cos(2*pi*1*t1);
c2=sqrt(2/T)*sin(2*pi*1*t1);
figure(2);
subplot(4,1,3);
plot(t1,c1,'r');
title('Carrier 1');
xlabel('Time');
ylabel('Amplitude');
subplot(4,1,4)
plot(t1,c2,'k');
title('Carrier 2');
xlabel('Time');
ylabel('Amplitude');

%QPSK waveform generation
r1=even_ps.*c1;
r2=odd_ps.*c2;
qpsk_sig=r1-r2;
figure(3);
subplot(3,1,1);
plot(t1,r1,'r');
title('DSSS-QPSK signal for even sequence');
xlabel('Time');
ylabel('Amplitude');
subplot(3,1,2)
plot(t1,r2,'k');
title('DSSS-QPSK signal for odd sequence');
xlabel('Time');
ylabel('Amplitude');
subplot(3,1,3)
plot(t1,qpsk_sig,'k');
title('DSSS-QPSK signal');
xlabel('Time');
ylabel('Amplitude');











