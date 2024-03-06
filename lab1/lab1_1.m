clear all
close all
clc
% A ---------------------------
A=230;
f=50;
w=2*pi*f;
T=1/f;
hz=[10000, 500, 200];
color=["b-", "r-o", "k-x"];
figure(1);
for k=1:3
    t=linspace(0, 0.1, hz(k)*0.1);
    wave=A*sin(w*t);
    plot(t, wave, color(k))
    hold on
end
title(hz + " Hz");
pause;
%B--------------------------

hz_b=[10000, 51, 50, 49];
color_b=["b-", "g-o", "r-o", "k-o"];
figure(2)
for k=1:4
    t=linspace(0, 1, hz_b(k));
    wave=A*sin(w*t);
    plot(t, wave, color_b(k))
    hold on
end
title(hz_b + " Hz");
pause;
%-------------------------
hz_b=[10000, 26, 25, 24];
color_b=["b-", "g-o", "r-o", "k-o"];
figure(3)
for k=1:4
    t=linspace(0, 1, hz_b(k));
    wave=A*sin(w*t);
    plot(t, wave, color_b(k))
    hold on
end
title(hz_b + " Hz");
pause;

%C------------------------

f_c=0:5:300;
t=linspace(0, 1, 100);
figure(4)
for k=f_c
    w=2*pi*k;
    wave=sin(w*t);
    plot(t, wave, "r-");
    title("Iteracja: "+ (k/5 +1) +", "+ "Częstotliwość: "+k + " Hz")
    pause;
end
%------------------------
figure(5)
plot(t, sin(2*pi*5*t),t, sin(2*pi*105*t),t, sin(2*pi*205*t))
pause;
figure(6)
plot(t, sin(2*pi*95*t),t, sin(2*pi*195*t),t, sin(2*pi*295*t))
pause;
figure(7)
plot(t, sin(2*pi*95*t),t, sin(2*pi*105*t))
pause;

f_c=0:5:300;
t=linspace(0, 1, 100);
figure(8)
for k=f_c
    w=2*pi*k;
    wave=cos(w*t);
    plot(t, wave, "r-");
    title("Iteracja: "+ (k/5 +1) +", "+ "Częstotliwość: "+k + " Hz")
    pause;
end
%------------------------
figure(9)
plot(t, cos(2*pi*5*t),t, cos(2*pi*105*t),t, cos(2*pi*205*t))
pause;
figure(10)
plot(t, cos(2*pi*95*t),t, cos(2*pi*195*t),t, cos(2*pi*295*t))
pause;
figure(11)
plot(t, cos(2*pi*95*t),t, cos(2*pi*105*t))
pause;