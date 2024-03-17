

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Przyjmij N=1024, wygeneruj losowe dane o rozkładzie normalnym 
N = 1024;
x1 = randn(1,N);
x2 = randn(1,N);

% Wykonaj transformatę rzeczywistą - Fast Fourier Transform
Xmat1 = fft(x1);
Xmat2 = fft(x2);

% Tworzenie sygnału zespolonego i jego transformata
y = x1 + 1i*x2;
Y = fft(y);

% Rozdzielanie 2 sygnałów na 2 transformaty pojednynczych sygnałów
for k=1:N-1
    X1r(k+1) = 0.5*(real(Y(k+1)) + real(Y(N-k+1)));
    X1i(k+1) = 0.5*(imag(Y(k+1)) - imag(Y(N-k+1)));

    X2r(k+1) = 0.5*(imag(Y(k+1)) + imag(Y(N-k+1)));
    X2i(k+1) = 0.5*(real(Y(N-k+1)) - real(Y(k+1)));
end

X1r(1) = real(Y(1));
X1i(1) = 0;
X2r(1) = imag(Y(1));
X2i(1) = 0;

X1 = X1r + 1i*X1i;
X2 = X2r + 1i*X2i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Porównanie otrzymanych transformat z tymi matlabowymi

fprintf("\n\n\n\n\n\n\n")
fprintf("Największy błąd sygnału 1: %u\n" ,max(abs(Xmat1 - X1)));
fprintf("Największy błąd sygnału 2: %u\n" ,max(abs(Xmat2 - X2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = (0:N-1)/(N-1) * 1000;
figure(3);
hold on;
plot(f,abs(Xmat1), "r-o");
plot(f,abs(X1), "k-x");
%xlim([0 500])
set(figure(3),'units','points','position',[0,30,720,720])
title('Sygnał 1');
legend('MAT','DFT');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
hold off;

figure(4);
plot(f,abs(Xmat1 - X1), "b-");
%xlim([0 500])
set(figure(4),'units','points','position',[720,30,720,720])
title('Sygnał 1');
legend('Błąd');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');

figure(5);
hold on;
plot(f,abs(Xmat2), "r-o");
plot(f,abs(X2), "k-x");
%xlim([0 500])
set(figure(5),'units','points','position',[0,30,720,720])
title('Sygnał 2');
legend('MAT','DFT');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
hold off;

figure(6);
plot(f,abs(Xmat2 - X2), "b-");
%xlim([0 500])
set(figure(6),'units','points','position',[720,30,720,720])
title('Sygnał 2');
legend('');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');