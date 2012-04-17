%fonction assurant l'evaluation d'une fonction polynomiale de degre 0
%L.LAURENT -- 11/05/2010 -- luc.laurent@ens-cachan.fr

%% IN: 
%   -val: points d'�valuation (ligne: coordonn�es d'un point, colonne: les
%   diff�rents points)
%   -ret: monome 
%   -dret: derivees

function [ret,dret]=reg_poly0(val)


ret=ones(size(val,1),1);

if nargout==2
    dret=zeros(size(val));
end
end
