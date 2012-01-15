%% Realisation des tirages
%% L. LAURENT -- 17/12/2010 -- laurent@lmt.ens-cachan.fr

function tirages=gene_doe(doe)
tic
% obtenir un "vrai" tirages pseudo al�atoire
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

fprintf('===== DOE =====\n');

%recup�ration bornes espace de conception
esp=doe.bornes;

%nombre de variables
nbv=size(esp,1);

%recuperation nombre d'�chantillons souhait�s
nbs=doe.nb_samples;

%ge�n�eration des diff�erents types de tirages
switch doe.type
    % plan factoriel complet
    case 'ffact'
        tirages=factorial_design(nbs,esp);
        % Latin Hypercube Sampling avec R (et pr�enrichissement)
    case 'LHS_R'
        Xmin=esp(:,1);
        Xmax=esp(:,2);
        tirages=lhsu_R(Xmin,Xmax,prod(nbs(:)));
        % Improved Hypercube Sampling avec R (et pr�enrichissement)
    case 'IHS_R'
        Xmin=esp(:,1);
        Xmax=esp(:,2);
        tirages=ihs_R(Xmin,Xmax,prod(nbs(:)));
        % Latin Hypercube Sampling (� loi uniforme)
    case 'LHS'
        Xmin=esp(:,1);
        Xmax=esp(:,2);
        tirages=lhsu(Xmin,Xmax,prod(nbs(:)));
        % LHS avec stockage des donn�es
    case 'LHS_manu'
        %on verifie si le dossier de stockage existe (si non on le cree)
        if exist('LHS_MANU','dir')~=7
            unix('mkdir LHS_MANU');
        end
        
        %on verifie si le tirages existe deja (si oui on le charge/si non on le
        %genere et le sauvegarde)
        fi=['LHS_MANU/lhs_man_' doe.fct sprintf('_%d',nbs)];
        fich=[fi '.mat'];
        if exist(fich,'file')==2
            st=load(fich,'tir_save');
            tirages=st.tir_save;
        else
            Xmin=esp(:,1);
            Xmax=esp(:,2);
            tirages=lhsu(Xmin,Xmax,prod(nbs(:)));
            save(fi,'tirages');
        end
        % tirages al�atoires
    case 'rand'
        tirages=repmat(esp(:,1)',prod(nbs(:)),1)...
            +repmat(esp(:,2)'-esp(:,1)',prod(nbs(:)),1).*rand(prod(nbs(:)),nbv);
        %tirages d�finis manuellement
    case 'perso'
        tirages=doe.manu;
        disp('/!\ Echantillonnage manuel (cf. conf_doe.m)');
    otherwise
        error('le type de tirage nest pas defini');
end

%Tri des tirages (par rapport � une variable
if isfield(doe,'tri')&&doe.tri>0
   if doe.tri<=size(tirages,1)
       [~,ind]=sort(tirages(:,doe.tri));
       tirages=tirages(ind,:);
   else
       fprintf('###############################################################\n');
       fprintf('## ##mauvais param�tre de tri des tirages (tri d�sactiv�) ## ##\n');
       fprintf('###############################################################\n');
   end
end

toc

%% affichage infos
fprintf(' >> type de tirages: %s\n',doe.type);
end