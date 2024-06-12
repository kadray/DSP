clear all; close all;
% Parametry
K = 32;     % rozmiar bloku dla jednego bitu znaku wodnego (K x K pikseli) - rozmiar jednej kratki
wzm = 2;    % wzmocnienie znaku wodnego, im wiecej tym widoczniej, ale łatweij dekodować

blad_vec = zeros(1,10);    %wektor na błędy
l = 1;

for scale = 1:-0.1:0.1              %zmniejszamy obrazek
    % Wczytaj obraz do znakowania
    A = imread('lena512.png');
    B = double(A); [M, N] = size(B);

    % Znaku wodny
    Mb = (M/K); Nb=(N/K);                 % liczba bloków w wierszu i kolumnie
    plusminus1 = sign( randn(1,Mb*Nb) );  % losowa sekwencja liczb +1/-1
    Znak = zeros( size(B) );              % macierz znaku: szachownica z jakimś wzorkiem +1/-1 jak kod qr
    for i = 1:Mb
        for j = 1:Nb
            Znak( (i-1)*K+1 : i*K, (j-1)*K+1 : j*K ) = plusminus1(i*j);
        end
    end
    %Dodanie szumu - szum jak klucz - musi byc ten sam do kodowania i dekodowania
    Sz = round( randn(size(B)) );         % szum (nośna modulująca znak) - 
    ZnakSz = wzm * Sz .* Znak;            % modulacja znaku wodnego = wzm * szum * znak(+/-1)
    B = uint8( B + ZnakSz );              % obraz + znak wodny, konwersja do 8 bit�w
    
    % Rysunki
    figure, subplot(2,2,1), imshow(Znak,[]);   title('Znak wodny')
    subplot(2,2,2), imshow(ZnakSz,[]); title('Znak zmodulowany szumem')
%     figure, subplot(1,2,1); imshow(A,[]);      title('Obraz oryginalny')
%     subplot(1,2,2); imshow(B,[]);      title('Obraz z ukrytym znakiem wodnym')

    %Skalowanie
    B = imresize(B, scale, "Bilinear");
    B = imresize(B, [512 512], "Bilinear");
    %biliniowość - 'jak z 4 pikseli zrobić jeden żeby było ok'

    % Detekcja znaku wodnego
    B = double(B);                              % powrotna konwersja do podwójnej precyzji

    % Filtracja górnoprzepustowa (?) zaznaczonego obrazu
    L = 10; L2=2*L+1;                           % rozmiar filtra 2D (L x L)
    w = hamming(L2); w = w * w';                % okno 2D z okna 1D Hamminga

    f0=0.5; wc = pi*f0; [m, n] = meshgrid(-L:L,-L:L);                         %  filtr LowPass
    lp = wc * besselj( 1, wc*sqrt(m.^2 + n.^2) )./(2*pi*sqrt(m.^2 + n.^2) ); %
    lp(L+1,L+1)= wc^2/(4*pi);                                                %
    hp = - lp; hp(L+1,L+1) = 1 - lp(L+1,L+1);   % filtr HighPass z LowPass (bez okna 2D)
    h = hp .* w;                                % z oknem 2D
    B = conv2( B, h, 'same');                   % filtracja obrazu

    % Decyzja o warto�ci bitu w ka�dym bloku (+1/-1)
    Demod = B .* Sz;                            % demodulacja
    ZnakDetekt = zeros( size(B) );              % sumowanie pikseli w blokach
    for i=1:Mb
        for j=1:Nb
    %       sum( sum( Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K) ) )
            ZnakDetekt((i-1)*K+1:i*K, (j-1)*K+1:j*K) = ...
            sign( sum( sum( Demod((i-1)*K+1:i*K, (j-1)*K+1:j*K) ) ) );
        end
    end

    % Rysunki
    subplot(2,2,3); imshow(ZnakDetekt,[]); title('Detekcja znaku')
    subplot(2,2,4); imshow(Demod,[]);      title('Demodulacja')
 

    blad_detekcji = sum(sum( abs(Znak-ZnakDetekt) ));
    procent = 100-100*(blad_detekcji/(N*M));
    blad_vec(1,l) = procent;
    l= l+1;
end

figure;
plot(blad_vec); title('Błąd - ile % jest okej zdetektowane?');