close all;
clear all;

L = load('adsl_x.mat');
x = L.x;

K = 4;  % liczba bloków
M = 32; % długość prefiksu
N = 512; % długośc bloku

poczatki_prefiksow = zeros(K, 1);

% Dla każdego bloku:
for i = 1:K
    % Określenie indeksów początku i końca fragmentu sygnału
    indeks_poczatkowy = (i-1)*(M+N) + 1;
    indeks_koncowy = indeks_poczatkowy + M + N - 1;

    % Sprawdzenie, czy fragment mieści się w sygnale x
    if indeks_koncowy <= length(x)
        % Wybór fragmentu sygnału
        sygnal_fragment = x(indeks_poczatkowy:indeks_koncowy);

        % Obliczenie korelacji wzajemnej między fragmentem a całym sygnałem x
        korelacja = xcorr(sygnal_fragment, x);
        % Znalezienie indeksu maksymalnej wartości korelacji
        [~, idx_max] = max(korelacja);
        % Określenie początku prefiksu na podstawie indeksu maksymalnej wartości korelacji
        poczatek_prefiksu = idx_max -N + 1;

        % Zapisanie wyniku
        poczatki_prefiksow(i) = poczatek_prefiksu;
    end
end

% Wyświetlenie wyników
disp('Początki prefiksów:');
disp(poczatki_prefiksow);