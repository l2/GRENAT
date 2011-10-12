%%Evaluation de la fonction et de ses gradients
%% L. LAURENT -- 17/12/2010 -- laurent@lmt.ens-cachan.fr

function [eval,grad]=gene_eval(fct,X,type)


% en fonction du type d'�valuation (calcul au points tir�s ou calcul pour
% affichage)
switch type
    %evaluations des pts tir�es (X est une matrice: 1var par colonne)
    case 'eval'
        %% X matrice de tirages:
        % colonnes: chaque dimension
        % lignes: un jeu de param�tres
        nb_var=size(X,2);
        nb_val=size(X,1);
        %X
        
        %pr�paration jeu de donn�es pour evaluation
        X_eval=zeros(nb_val,1,nb_var);
        
        for ii=1:nb_var
            X_eval(:,:,ii)=X(:,ii);
        end
        %�valuation pour affichage (X est une matrice de matrice)
    case 'aff'
        X_eval=X;
end

%evaluation fonction et gradients aux points x
if nargout==1
    [eval]=feval(fct,X_eval);
elseif nargout==2
    [eval,gradb]=feval(fct,X_eval);
    % dans le cas des �valuations aux points tir�s on reorganise les
    % gradients
    if strcmp(type,'eval')
        grad=zeros(size(X));
        for ii=1:nb_var
           grad(:,ii)=gradb(:,:,ii); 
        end
    else
        grad=gradb;
    end
else
    fprintf('Mauvais nombre de param�tres de sortie (cf. gene_eval)');
end

