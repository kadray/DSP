clear all
close all
clc

A=230;
f=50;
w=2*pi*f;
T=1/f;
f_signal=200;
T_signal=1/f_signal;
t_signal=0:T_signal:1;
wave=A*sin(w*t_signal);
figure(1)
plot(t_signal, wave, "b-o")
hold on

f_sampling=10000;
T_sampling=1/f_sampling;
t_sampling=0:T_sampling:1; % wektor wszystkich miejsc (t) w których chcemy odtworzyć sygnał
ratio=f_sampling/f_signal;
for idx = 1:length(t_sampling)
    t = t_sampling(idx);
    xhat(idx) = 0;
    for k = 1:length(t_signal)
        arg=(pi/T_signal)*(T_sampling*(idx-1)-T_signal*(k-1));
        smp=sin(arg)/arg;
        if arg==0
            smp=1;
        end
        xhat(idx)=xhat(idx)+wave(k)*smp;
    end
end
plot(t_sampling, xhat, "r-")
legend("sygnał dany", "sygnał odtworzony")