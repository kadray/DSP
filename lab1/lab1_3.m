clear all
close all
clc
a=load("adsl_x.mat");
signal=a.x;
prefix_len = 32;  
frame_len = 512; 
idx=[]

for i=1:length(signal)-prefix_len
    pref = signal(i:i+31);
    pref_corr = xcorr(pref, pref);
    pref_max = max(pref_corr);

    r=xcorr(signal, pref);
    r_max=max(r);
    
    pref_idx = find(r==pref_max);
    pref_idx = abs(pref_idx-length(signal))+1;

    if length(pref_idx)~=1
        find(r==pref_max);
        idx = [idx, pref_idx]
    end
end