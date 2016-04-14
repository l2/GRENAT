%%fonction de correlation exponentielle carree
%%L. LAURENT -- 18/01/2012 -- luc.laurent@ens-cachan.fr
%revision du 13/11/2012

%Rasmussen 2006 p. 83

function [corr,dcorr,ddcorr]=corr_sexp(xx,long)

%verification de la dimension de la longueur de correlation
lt=size(long);
%nombre de points a evaluer
nb_pt=size(xx,1);
%nombre de composantes
nb_comp=size(xx,2);
%nombre de sorties
nb_out=nargout;

if lt(1)*lt(2)==1
    %long est un reel, alors on en fait une matrice de la dimension de xx
    long = long*ones(nb_pt,nb_comp);
elseif lt(1)*lt(2)==nb_comp
    long = long(ones(nb_pt,1),:);
elseif lt(1)*lt(2)~=nb_comp
    error('mauvaise dimension de la longueur de correlation');
end


%calcul de la valeur de la fonction au point xx
td=-xx.^2./(2*long.^2);
ev=exp(sum(td,2));

if nb_out==1
    corr=ev;
elseif nb_out==2
    corr=ev;
    dcorr=-xx./long.^2.*ev(:,ones(1,nb_comp));
elseif nb_out==3
    corr=ev;
    dcorr=-xx./long.^2.*ev(:,ones(1,nb_comp));   
    
    %calcul des derivees secondes    
    
    %suivant la taille de l'evaluation demandee on stocke les derivees
    %secondes de manieres differentes
    %si on ne demande le calcul des derivees secondes en un seul point, on
    %les stocke dans une matrice 
    if nb_pt==1
        ddcorr=zeros(nb_comp);
        for ll=1:nb_comp
           for mm=1:nb_comp
                if(mm==ll)
                    ddcorr(mm,ll)=ev/long(1,mm)^4*(xx(mm)^2-long(1,mm)^2);
                else
                    ddcorr(mm,ll)=ev/(long(1,mm)^2*long(1,ll)^2)*xx(ll)*xx(mm);
                end
           end
        end
       
    %si on demande le calcul des derivees secondes en plusieurs point, on
    %les stocke dans un vecteur de matrices
    else
        ddcorr=zeros(nb_comp,nb_comp,nb_pt);
        for ll=1:nb_comp
           for mm=1:nb_comp
                if(mm==ll)                    
                    ddcorr(mm,ll,:)=ev./long(1,mm)^4.*(xx(:,mm).^2-long(1,mm)^2);
                else
                    ddcorr(mm,ll,:)=ev./(long(1,mm)^2*long(1,ll)^2).*xx(:,ll).*xx(:,mm);
                end
           end
        end
    end
else
    error('Mauvais argument de sortie de la fonction corr_sexp');
end