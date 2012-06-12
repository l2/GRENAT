%% fonction assurant l'examen des donn�es entrante (en cas de donn�es manquantes)
%% L. LAURENT -- 12/06/2012 -- laurent@lmt.ens-cachan.fr

function [ret]=examen_in_data(tirages,eval,grad)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Affichage des informations de construction
fprintf(' >> Examen des donn�es entrantes \n');

%nombre de variables
nb_var=size(tirages,2);
%nombre de points
nb_val=size(tirages,1);

%donn�es manquante dans les �valuations
manq_eval=isnan(eval);
nb_manq_eval=sum(manq_eval);
ix_manq_eval=find(manq_eval==1);

%donn�es manquantes dans les gradients
manq_grad=isnan(grad);
nb_manq_grad=sum(manq_grad);
[r,c]=find(manq_grad==1);
ix_manq_grad=[r c];

%affichage des infos
if nb_manq_eval==0&&nb_manq_grad==0
    fprintf('>>> Aucune donn�e manquante\n');
end

if nb_manq_eval~=0
    fprintf('>>> R�ponse(s) manquante(s) au(x) point(x):\n')
    for ii=1:nb_manq_eval
        num_tir=ix_manq_eval(ii);
        fprintf(' n%s %i (%4.2f',char(176),num_tir,tirages(1,num_tir)); 
        if nb_var>1;fprintf(',%4.2f',tirages(2:end,num_tir));end
        fprintf(')\n');
    end
end

if nb_manq_grad~=0
    fprintf('>>> Gradient(s) manquant(s) au(x) point(x):\n')
    for ii=1:nb_manq_grad
        num_tir=ix_manq_grad(ii,1);
        composante=ix_manq_grad(ii,1);
        fprintf(' n%s %i (%4.2f',char(176),num_tir,tirages(1,num_tir)); 
        if nb_var>1;fprintf(',%4.2f',tirages(2:end,num_tir));end
        fprintf(')\n');
        fprintf('  composante: %i\n',composante)
    end
end