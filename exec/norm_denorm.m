%% fonction assurant la normalisation/denormalisation des donnees
%% L. LAURENT -- 18/10/2011 -- laurent@lmt.ens-cachan.fr

function [out,infos]=norm_denorm(in,type,infos)

% nombre d'echantillons
nbs=size(in,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%traitement de tous le cas de figure
norm_data=false;norm_manq=false;
if nargin==3
    if isfield(infos,'moy')
        if ~isempty(infos.moy)
            norm_data=true;
        end
    elseif isfield(infos,'eval')
        norm_manq=infos.eval.on;
    elseif isfield(infos,'moy')&&isfield(infos,'eval')
        norm_data=true;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout==2
    extr_infos=true;
else
    extr_infos=false;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%normalisation//denormalisation
switch type
    case 'norm'
        %dans le cas de donn�es manquantes, on retire les donn�es � NaN
        if norm_manq
            inm=in(infos.eval.ix_dispo);
        else
            inm=in;
        end
        calc_para_norm=true;
        if norm_data
            out=(in-repmat(infos.moy,nbs,1))./repmat(infos.std,nbs,1);
            calc_para_norm=false;
        end
        
        if calc_para_norm
            %calcul des moyennes et des ecarts type
            moy_i=mean(inm);
            std_i=std(inm);
            %test pour verification ecart type
            ind=find(std_i==0);
            if ~isempty(ind)
                std_i(ind)=1;
            end
            if norm_manq
                outm=(inm-repmat(moy_i,infos.eval.nb,1))./...
                    repmat(std_i,infos.eval.nb,1);
                out=NaN*zeros(size(in));
                out(infos.eval.ix_dispo)=outm;
            else
                out=(inm-repmat(moy_i,nbs,1))./repmat(std_i,nbs,1);
            end
            
            if extr_infos
                infos.moy=moy_i;
                infos.std=std_i;
            end
            
        end
        
        %denormalisation
    case 'denorm'
        if norm_data
            out=repmat(infos.std,nbs,1).*in+repmat(infos.moy,nbs,1);
        else
            out=in;
        end
        
        %denormalisation d'une difference de valeurs normalisees
    case 'denorm_diff'
        if norm_data
            out=repmat(infos.std,nbs,1).*in;
        else
            out=in;
        end
    otherwise
        error('Mauvais nombre de parametres d''entr�e (cf. norm_denorm.m)')
end
