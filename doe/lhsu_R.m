%% Generation de plan d'experience LHS a partir de R (avec pr�tirage de LHS enrichi)
% L. LAURENT -- 14/01/2012 -- laurent@lmt.ens-cachan.fr


function [tir,new_tir]=lhsu_R(Xmin,Xmax,nb_samples,tir,nb_enrich)

%% INPUT: 
%    - Xmin,Xmax: bornes min et max de l'espace de concpetion
%    - nb_samples: nombre d'�chantillons requis
%    - nb_enrich: nombre d'�chantillons requis pour enrichir
%% OUTPUT
%   - tir: echantillons
%   - new_tir: nouveaux echantillons en phase d'enrichissement
%%

%%declaration des options
% repertoire de stockage
rep='LHS_R';
%nombre de plans pr�tir�s
nb_pretir=300;

%phase de creation des plans
if nargin==3

% recuperation dimensions (nombre de variables et nombre d'�chantillon)
nbs=nb_samples;
nbv=length(Xmin);

%%ecriture d'un script R
%Creation du repertoire de stockage (s'il n'existe pas)
if exist(rep,'dir')~=7
    cmd=['mkdir ' rep];
    unix(cmd);
end

%ecriture du script r
%proc�dure de cr�ation du tirage initial
text_init=['a<-randomLHS(

%phase d'enrichissement
elseif nargin==5

    
end
