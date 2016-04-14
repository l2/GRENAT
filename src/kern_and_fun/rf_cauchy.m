%%fonction a base radiale: Cauchy
%%L. LAURENT      luc.laurent@ens-cachan.fr
%% 15/03/2010 modif le 12/04/2010

function [G,dG,DddG]=rf_cauchy(xx,para)

%evaluation de la fonction
te=xx'*xx/para^2;
ev=1/(1+te);

%traitement des cas d'appel (fonction ou sa derivee)
switch type
    %evaluation de la fonction
    case 'f'
        G=ev;
        
    %evaluation de la derivee ou du gradient de la fonction (suivant la
    %dimension de xx
    case 'd'
        dd=zeros(size(xx,1),1);
        taille=size(xx,1);
        for ii=1:taille
            dd(ii,1)=-2*xx(ii,1)*ev^2 /para^2;
        end
         G=dd;
    otherwise
        error('Type de paramètres non pris en compte (f ou d) cf. gauss.m');
        
        
end

end