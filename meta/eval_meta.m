%% Evaluation du metamodele
%% L. LAURENT -- 04/12/2011 -- laurent@lmt.ens-cachan.fr


function [Z,ret]=eval_meta(ret,tirages,eval,grad,points,meta)

% Generation du metamodele
textd='===== METAMODELE de ';
textf=' =====';

%nombre de variables
nb_var=size(tirages,2);
%nombre de points
nb_val=size(tirages,1);
dim_ev=size(points);

%prise en compte gradients ou pas
if isempty(grad)||meta.grad==false;pec_grad='Non';grad=[];else;pec_grad='Oui';end

var=zeros(dim_ev([1 2]));
rep=zeros(dim_ev([1 2]));
GR=zeros(dim_ev(1),dim_ev(2),nb_var);

%%%%%%% Generation de divers metamodeles
%initialisation stockage
ret=cell(length(meta.type),1);
Z=ret;
% generation des metamodeles
num_meta=1;
for type=meta.type
    ret{num_meta}.type=type{1};
    
    % en dimension 1, les points ou l'on souhaite evaluer le metamodele se
    % presentent sous forme d'une matrice
    if nb_var==1
        
        switch type{1}
            %%%%%%%%=================================%%%%%%%%
            %%%%%%%%=================================%%%%%%%%
            case 'SWF'
                %%	Evaluation du metamodele 'Shepard Weighting Functions'
                for jj=1:length(points)
                    [rep(jj),G]=eval_swf(points(jj),swf);
                    GR(jj)=G;
                end
            case 'RBF'
                %%	Evaluation du metamodele 'RBF/HBRBF'
                
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'CKRG'
                %%     Evaluation du metamodele de CoKrigeage
                for jj=1:length(points)
                    [rep(jj),G,var(jj)]=eval_ckrg(points(jj),tirages,ckrg);
                    GR(jj)=G;
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'KRG'
                %%     Evaluation du metamodele de Krigeage
                for jj=1:length(points)
                    [rep(jj),G,var(jj)]=eval_krg(points(jj),tirages,krg);
                    GR(jj)=G;
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'DACE'
                %% Evaluation du metamodele de Krigeage (DACE)
                for jj=1:length(points)
                    [rep(jj),G,var(jj)]=predictor(points(jj),dace.model);
                    GR(jj)=G;
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'PRG'
                for degre=meta.deg
                    %% Evaluation du metamodele de Regression
                    for jj=1:length(points)
                        rep(jj)=eval_prg(prg.coef,points(jj,1),points(jj,2),degre);
                        %evaluation des gradients du MT
                        [GRG1,GRG2]=evald_prg(prg.coef,points(jj,1),points(jj,2),degre);
                        GR(jj)=[GRG1 GRG2];
                    end
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'ILIN'
                %% interpolation par fonction de base lin�aire
                fprintf('\n%s\n',[textd  'Interpolation par fonction de base lin�aire' textf]);
                for jj=1:length(points)
                    [rep(jj),GR(jj)]=interp_lin(points(jj),tirages,eval);
                end
                ret=[];
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'ILAG'
                %% interpolation par fonction polynomiale de Lagrange
                fprintf('\n%s\n',[textd  'Interpolation par fonction polynomiale de Lagrange' textf]);
                for jj=1:length(points)
                    [rep(jj),GR(jj)]=interp_lag(points(jj),tirages,eval);
                end
                ret=[];
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
                
        end
        
        % en dimension ou plus, les points ou l'on souhaite evaluer le metamodele se
        % presentent sous forme d'un vecteur de matrices
    elseif nb_var>=2
        if meta.verif
            Zverif=zeros(nb_val,1);varverif=zeros(nb_val,1);
            GZverif=zeros(nb_val,nb_var);
        end
        switch type{1}
            %%%%%%%%=================================%%%%%%%%
            %%%%%%%%=================================%%%%%%%%
            case 'SWF'
                %%	Evaluation du metamodele 'Shepard Weighting Functions'
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G]=eval_swf(points(jj,kk,:),swf);
                        GR(jj,kk,:)=G;
                    end
                end
            %%%%%%%%=================================%%%%%%%%
            %%%%%%%%=================================%%%%%%%%
            case 'CKRG'
                %% Evaluation du metamodele de CoKrigeage
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G,var(jj,kk)]=eval_ckrg(points(jj,kk,:),tirages,ckrg);
                        GR(jj,kk,:)=G;
                    end
                end
                %% verification interpolation
                if meta.verif
                    for jj=1:size(tirages,1)
                        [Zverif(jj),G,varverif(jj)]=eval_ckrg(tirages(jj,:),tirages,ckrg);
                        GZverif(jj,:)=G;
                    end
                    diffZ=Zverif-eval;
                    diffGZ=GZverif-grad;
                    if ~isempty(find(diffZ>1e-7))
                        fprintf('pb d''interpolation (eval) CKRG\n')
                        diffZ
                    end
                    if ~isempty(find(diffGZ>1e-7))
                        fprintf('pb d''interpolation (grad) CKRG\n')
                        diffGZ
                    end
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'KRG'
                %% Evaluation du metamodele de Krigeage
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G,var(jj,kk)]=eval_krg(points(jj,kk,:),tirages,krg);
                        GR(jj,kk,:)=G;
                    end
                end
                %% verification interpolation
                if meta.verif
                    for jj=1:size(tirages,1)
                        [Zverif(jj),G,varverif(jj)]=eval_krg(tirages(jj,:),tirages,krg);
                    end
                    diffZ=Zverif-eval;
                    if ~isempty(find(diffZ>1e-7))
                        fprintf('pb d''interpolation (eval) KRG\n')
                        diffZ
                    end
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'DACE'
                %% Evaluation du metamodele de Krigeage (DACE)
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G,var(jj,kk)]=predictor(points(jj,kk,:),dace.model);
                        GR(jj,kk)=G(1);
                        GR(jj,kk)=G(2);
                    end
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'PRG'
                for degre=meta.deg
                    %% Evaluation du metamodele de Regression
                    for jj=1:length(points)
                        for kk=1:size(points,2)
                            rep(jj,kk)=eval_prg(prg.coef,points(jj,kk,1),points(jj,kk,2),degre);
                            %evaluation des gradients du MT
                            [GRG1,GRG2]=evald_prg(prg.coef,points(jj,kk,1),points(jj,kk,2),degre);
                            GR(jj,kk)=GRG1;
                            GR(jj,kk)=GRG2;
                        end
                    end
                end
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'ILIN'
                %% interpolation par fonction de base lin�aire
                fprintf('\n%s\n',[textd  'Interpolation par fonction de base lin�aire' textf]);
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G]=interp_lin(points(jj,kk,:),tirages,eval);
                        GR1(jj,kk)=G(1);
                        GR2(jj,kk)=G(2);
                    end
                end
                ret=[];
                %%%%%%%%=================================%%%%%%%%
                %%%%%%%%=================================%%%%%%%%
            case 'ILAG'
                %% interpolation par fonction polynomiale de Lagrange
                fprintf('\n%s\n',[textd  'Interpolation par fonction polynomiale de Lagrange' textf]);
                for jj=1:size(points,1)
                    for kk=1:size(points,2)
                        [rep(jj,kk),G]=interp_lag(points(jj,kk,:),tirages,eval);
                        GR1(jj,kk)=G(1);
                        GR2(jj,kk)=G(2);
                    end
                end
                ret=[];
        end
    else
        error('dimension non encore prise en charge');
    end
    
    %Stockage des evaluations
    Z{num_meta}.Z=rep;
    Z{num_meta}.GZ=GR;
    Z{num_meta}.var=var;
    
    num_meta=num_meta+1;
end

