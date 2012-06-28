%% Proc�dure assurant l'enrichissement du m�tamod�le
%% L. LAURENT -- 24/01/2012 -- laurent@lmt.ens-cachan.fr

function [approx,enrich,in]=enrich_meta(tirages,doe,meta,enrich)

%% initialisation des quantit�
new_tirages=tirages;
%evaluations de la fonction aux points
[new_eval,new_grad]=gene_eval(doe.fct,new_tirages,'eval');

%construction initiale du m�tamod�le
[approx]=const_meta(new_tirages,new_eval,new_grad,meta);

crit_atteint=false;
pts_ok=true;
mse_ok=true;
old_tirages=[];
old_eval=[];
old_grad=[];

enrich.ev_crit=cell(length(enrich.crit_type),1);
%suivant le critere d'enrichissement (critere multiple)
%critere TPS_CPU prioritaire si sp�cifi�

%correction rangement type
if ~iscell(enrich.crit_type)
    type={enrich.crit_type};
else
    type=enrich.crit_type;
end

%correction rangement critere
if ~iscell(enrich.val_crit)
    crit={enrich.val_crit};
else
    crit=enrich.val_crit;
end

fprintf('\n >>><<< Enrichissement >>><<<\n')
%tant que le crit�re retenu n'est pas atteint
while ~crit_atteint&&enrich.on
    %basculement des anciens r�sultats
    old_tirages=[old_tirages;new_tirages];
    old_eval=[old_eval;new_eval];
    old_grad=[old_grad;new_grad];
    new_tirages=[];new_eval=[];new_grad=[];
    
    
    
    %parcours des types d'enrichissement
    for  it_type=1:length(type)
        switch type{it_type}
            % controle en nombre de points
            case 'NB_PTS'
                fprintf(' >> V�rification nombre de points echantillons <<\n ')
                % Extraction temps CPU
                tir=old_tirages;
                nb_pts=size(tir,1);
                depass=(nb_pts-crit{it_type})/crit{it_type};
                % v�rification temps atteint
                if nb_pts>=crit{it_type}
                    pts_ok=false;
                    fprintf(' ====> Nb maxi de points ATTEINT: %d (max: %d) --- + %4.2f%s <====\n',nb_pts,crit{it_type},depass*100,char(37))
                else
                    pts_ok=true;
                    fprintf(' ====> Nb maxi de points OK: %d (max: %d) --- %4.2f%s <====\n',nb_pts,crit{it_type},depass*100,char(37))
                end
                
                %sauvegarde valeur crit�re
                enrich.ev_crit{it_type}=[enrich.ev_crit{it_type} nb_pts];
                
                % controle en MSE (CV)
            case 'CV_MSE'
                % Extraction MSE (CV)
                msep=approx.cv.msep;
                depass=(msep-crit{it_type})/crit{it_type};
                % v�rification temps atteint
                if msep<=crit{it_type}
                    mse_ok=false;
                    fprintf(' ====> MSE (CV) ATTEINTE: %0.7f (max: %0.7f) --- + %4.2f%s <====\n',msep,crit{it_type},depass,char(37))
                else
                    mse_ok=true;
                    fprintf(' ====> MSE (CV) OK: %0.7f (max: %0.7f) --- %4.2f%s <====\n',msep,crit{it_type},depass,char(37))
                end
                %sauvegarde valeur crit�re
                enrich.ev_crit{it_type}=[enrich.ev_crit{it_type} msep];
                % controle en convergence de r�ponse et/ou de localisation
            case {'CONV_REP','CONV_LOC'}
                %recherche du minimum de la fonction approch�e
                [Zap_min,X]=rech_min_meta(meta,approx,enrich.optim);
                %valeur cible
                Z_cible=enrich.min_glob.Z;
                X_cible=enrich.min_glob.X;
                switch type{it_type}
                    case 'CONV_REP'
                        %Calcul du crit�re
                        if Z_cible~=0
                            conv_rep=abs((Zap_min-Z_cible)/Z_cible);
                        else
                            conv_rep=abs(Zap_min-Z_cible);
                        end
                        depass=(conv_rep-crit{it_type})/crit{it_type};
                        % v�rification convergence
                        if conv_rep<=crit{it_type}
                            conv_rep_ok=false;
                            fprintf(' ====> Convergence vers le minimum (REP): %0.7f (max: %0.7f) --- + %4.2f%s <====\n',conv_rep,crit{it_type},depass,char(37))
                        else
                            conv_rep_ok=true;
                            fprintf(' ====> Convergence vers le minimum (REP) OK: %0.7f (max: %0.7f) --- %4.2f%s <====\n',conv_rep,crit{it_type},depass,char(37))
                        end
                        %sauvegarde valeur crit�re
                        enrich.ev_crit{it_type}=[enrich.ev_crit{it_type} conv_rep];
                    case 'CONV_LOC'
                        %Calcul du crit�re
                        ec=(X-X_cible).^2;
                        dist=sum(ec(:));
                        conv_loc=dist;
                        depass=(conv_loc-crit{it_type})/crit{it_type};
                        % v�rification convergence
                        if conv_loc<=crit{it_type}
                            conv_rep_ok=false;
                            fprintf(' ====> Convergence vers le minimum (LOC): %0.7f (max: %0.7f) --- + %4.2f%s <====\n',conv_loc,crit{it_type},depass,char(37))
                        else
                            conv_rep_ok=true;
                            fprintf(' ====> Convergence vers le minimum (LOC) OK: %0.7f (max: %0.7f) --- %4.2f%s <====\n',conv_loc,crit{it_type},depass,char(37))
                        end
                        %sauvegarde valeur crit�re
                        enrich.ev_crit{it_type}=[enrich.ev_crit{it_type} conv_loc];
                end
            otherwise
                fprintf('_______________________________\n')
                fprintf('>>>> Pas d''enrichissement <<<<\n')
                mse_ok=false;pts_ok=false;
        end
    end
    
    %test: si un des crti�res est atteint si c'est pas le cas alors on g�n�re
    %un nouveau point de calcul
    crit_atteint=conv_rep_ok&&conv_loc_ok&&mse_ok&&pts_ok;crit_atteint=~crit_atteint;
    
    if ~crit_atteint
        %en fonction du type d'enrichissement
        switch enrich.type
            % en se basant sur l'Expected Improvement
            case {'EI','GEI','VAR','WEI','LCB'}
                fprintf(' >> Enrichissement par metamodele, critere: %s\n',enrich.type)
                new_tirages=ajout_tir_meta(meta,approx,enrich);
                %en ajoutant des points dans le tirages
            case {'DOE'}
                fprintf(' >> Enrichissement du tirage\n')
                new_tirages=ajout_tir_doe(old_tirages);
            otherwise
                fprintf(' >> Mode d''enrichissement non d�fini <<\n');
        end
        
    else
        new_tirages=[];
        
    end
    
    %Affichage nouveau point
    if isempty(new_tirages)
        fprintf('>>> Pas de nouveaux points <<<\n')
        fprintf('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n')
    else
        fprintf(' >> Nouveau point: ');
        fprintf('%4.2f ',new_tirages);
        fprintf('\n')
    end
    
    
    
    %calcul des grandeurs en ce nouveau point et g�n�ration du nouveaux
    %metamodele
    if ~isempty(new_tirages)
        [new_eval,new_grad]=gene_eval(doe.fct,new_tirages,'eval');
        
        %stockage debug
        debug.old_tirages=old_tirages;
        debug.new_tirages=new_tirages;
        debug.old_eval=old_eval;
        debug.new_eval=new_eval;
        debug.old_grad=old_grad;
        debug.new_grad=new_grad;
        debug.approx=approx;
        global debug
        %construction du m�tamod�le
        [approx]=const_meta([old_tirages;new_tirages],[old_eval;new_eval],[old_grad;new_grad],meta);
    end
    
end


%Extraction des grandeurs ajout�s
in.tirages=old_tirages;
in.eval=old_eval;
in.grad=old_grad;