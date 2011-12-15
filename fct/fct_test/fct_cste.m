% Fonction constante
% L. LAURENT -- 20/10/2011 --

function [res,dres]=fct_cste(xx)

%Nombre de variables
nbvar=size(xx,3);

%valeur constant
val=10;

if nbvar==1
    if size(xx,2)==2
        xxx=xx(:,1);
    elseif size(xx,1)==2
        xxx=xx(:,2);
    else
        error('Mauvais format variable entr�e fct Constante');
    end
    res=val*ones(size(xxx));
    if nargout==2
        dres(:,:,1)=0*res;
        dres(:,:,2)=0*res;
    end

else
    res=val*ones(size(xx(:,:,1)));
    if nargout==2
        dres(:,:,1)=0*res;
        dres(:,:,2)=0*res;
    end
end
end