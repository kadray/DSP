clear all
close all
clc
% Wczytaj nagranie dźwiękowe
[x, fs] = audioread('engine.wav');

% Odtwórz nagranie dźwiękowe
soundsc(x, fs);

% Oblicz współczynniki transformaty kosinusowej
c = dct(x);

% Wyświetl wartości współczynników transformaty
figure;
stem(c);
title('Współczynniki transformaty kosinusowej');
xlabel('Numer współczynnika');
ylabel('Wartość współczynnika');

% Synteza dźwięku przy użyciu K największych współczynników
N = length(c);
for K = [1, 2, 3, 100, 1000, 16000, N]
    % Tworzenie maski dla K największych współczynników
    mask = zeros(size(c));
    [~, idx] = sort(abs(c), 'descend');
    mask(idx(1:K)) = c(idx(1:K));
    
    % Odtworzenie sygnału
    x_syn = idct(mask);
    
    % Odtwórz zsyntetyzowany dźwięk
    disp(['Odtwarzanie z K = ' num2str(K) ' największymi współczynnikami']);
    figure;
    subplot(2, 1, 1); plot(x_syn);
    subplot(2, 1, 2); stem(mask);
    soundsc(x_syn, fs);

    % Pauza na czas trwania nagrania + 1 sekunda
    pause(length(x)/fs + 1);
end
