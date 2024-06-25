function [zz,pp,wzm] = lp2bsMY(z,p,wzm,w0,dw)
    % transformacja LowPass-to-BandStop prototypowego filta analogowego
    
    zz = []; pp = [];
    for  k=1:length(z) % transformowanie zer transmitancji
         zz = [ zz roots([ 1 -dw/z(k) w0^2 ])' ];
         wzm = wzm*(-z(k));
    end
    for  k=1:length(p) % transformowanie biegunoww transmitancji
         pp = [ pp roots([ 1 -dw/p(k) w0^2 ])' ];
         wzm = wzm/(-p(k));
    end
    for k=1:(length(p)-length(z))
         zz = [ zz roots([ 1 0 w0^2 ])' ];
    end
    