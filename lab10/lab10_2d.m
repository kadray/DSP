clc; clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');% wczytaj sygnał mowy (cały)
[cv, ~]=audioread('coldvox.wav');
plot(x); title('sygnał mowy');	% pokaż go
							% oraz odtwórz na głośnikach (słuchawkach)

N=length(x);	  % długość sygnału
Mlen=240;		  % długość okna Hamminga (liczba próbek)
Mstep=180;		  % przesunięcie okna w czasie (liczba próbek)
Np=10;			  % rząd filtra predykcji
gdzie=Mstep+1;	  % początkowe położenie pobudzenia dźwięcznego

lpc=[];								   % tablica na współczynniki modelu sygnału mowy
s=[];									   % cała mowa zsyntezowana
ss=[];								   % fragment sygnału mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygnału mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragmentów (ramek) jest do przetworzenia
x=filter([1 -0.9735], 1, x);	% filtracja wstępna (preemfaza) - opcjonalna

figure; plot(abs(fft(x)));

for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnału
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    % Progowanie
    bx = bx - mean(bx);  % usuń wartość średnią
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
    if (nr==20 || nr==470)
        figure;
        subplot(411); plot(n,bx); title('fragment sygnału mowy');
        subplot(412); plot(r); title('jego funkcja autokorelacji');
    end
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz współczynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);	% oblicz jego odp. częstotliwościową
    if (nr==20 || nr==470)
        subplot(413); plot(abs(H)); title('widmo filtra traktu głosowego');
    end
    offset=20; rmax=max( r(offset : Mlen) );	   % znajdź maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdź indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % głoska dźwięczna/bezdźwięczna?
    if (T>80) T=round(T/2); end							% znaleziono drugą podharmoniczną
    lpc=[lpc; T; wzm; a; ];								% zapamiętaj wartości parametrów
    
    % SYNTEZA - odtwórz na podstawie parametrów ----------------------------------------------------------------------
    T = 0;                                        % usuń pierwszy znak "%" i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					% przesuń pobudzenie dźwięczne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            %pob=2*(rand(1,1)-0.5);
            pob=cv(n);
            gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            if (n==gdzie) 
                pob=1; 
                gdzie=gdzie+T;	   % pobudzenie dźwięczne
            else pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja „syntetycznego” pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunięcie bufora wyjściowego
    end
    if (nr==20 || nr==470)
        subplot(414); plot(ss); title('zsyntezowany fragment sygnału mowy'); 
    end
% pause
    s = [s ss];						% zapamiętanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; plot(s); title('mowa zsyntezowana');
% soundsc(x,fpr); 
% pause(1);
soundsc(s, fpr)
