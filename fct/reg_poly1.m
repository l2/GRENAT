%fonction assurant l'evaluation d'une fonction polynomiale de degre 1
%L.LAURENT -- 11/05/2010 -- luc.laurent@ens-cachan.fr

function [ret,dret]=reg_poly1(val)

d=size(val,2);

%fonction polynomiale
ret=[1 val];
ret
%derivee
if nargout==2
    dret=[zeros(d,1) eye(d)];   
end
end
