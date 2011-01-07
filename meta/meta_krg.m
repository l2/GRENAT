
%fonction assurant la creation du metamodele de Krigeage
%L. LAURENT -- 11/05/2010 -- luc.laurent@ens-cachan.fr


function krg=meta_krg(tirages,eval,meta)
tic;
tps_start=toc;


ns=size(eval,1);
tai_conc=size(tirages,2);

%Normalisation
if meta.norm
    disp('Normalisation');
    moy_e=mean(eval);
    std_e=std(eval);
    moy_t=mean(tirages);
    std_t=std(tirages);

    %normalisation des valeur de la fonction objectif et des tirages
    evaln=(eval-repmat(moy_e,ns,1))./repmat(std_e,ns,1);
    tiragesn=(tirages-repmat(moy_t,ns,1))./repmat(std_t,ns,1);
    
    %sauvegarde des donnees
    nkrg.norm.moy_eval=moy_e;
    nkrg.norm.std_eval=std_e;
    nkrg.norm.moy_tirages=moy_t;
    nkrg.norm.std_tirages=std_t;
    nkrg.norm.on=true;
else
    nkrg.norm.on=false;
    evaln=eval;
    tiragesn=tirages;
end

%evaluation aux points de l'espace de conception
y=evaln;

%creation matrice de conception
%(regression polynomiale)
if meta.deg==0
    nb_termes=1;
elseif meta.deg==1
    nb_termes=1+tai_conc;
elseif meta.deg==2
    p=(tai_conc+1)*(tai_conc+2)/2;
    nb_termes=p;
else
    error('Degre de regression non pris en charge')
end

fc=zeros(ns,nb_termes);
fct=['reg_poly' num2str(meta.deg,1)];
for ii=1:ns
    fc(ii,:)=feval(fct,tiragesn(ii,:)); 
end


%%Construction des differents elements avec ou sans estimation des
%%paramètres
if meta.para.estim
    fprintf('Estimation de la longueur de Correlation par minimisation de la log-vraisemblance\n');
    %minimisation de la log-vraisemblance
    switch meta.para.method
        case 'simplex'  %methode du simplexe
            
        case 'fmincon'
            %definition des bornes de l'espace de recherche
            lb=meta.para.min;ub=meta.para.max;
            %definition valeur de depart de la variable
            x0=meta.para.min;
            %declaration de la fonction à minimiser
            fun=@(theta)bloc_krg(tiragesn,ns,fc,y,meta,std_e,theta);
            %declaration des options de la strategie de minimisation
            options = optimset(...
               'Display', 'iter',...        %affichage évolution
               'Algorithm','sqp',... %choix du type d'algorithme
               'OutputFcn',@stop_estim,...
               'FunValCheck','off','UseParallel','always');      %fonction assurant l'arrêt de la procedure de minimisation et les traces des iterations de la minimisation
           
            %minimisation
            [x,fval,exitflag,output,lambda] = fmincon(fun,x0,[],[],[],[],lb,ub,[],options);
            meta.theta=x;
            fprintf('Valeur de la longueur de correlation %6.4f\n',x);
        otherwise
            error('Stratégie de minimisation non prise en charge');
    end
end

%construction des blocs de krigeage finaux
[lilog,krg]=bloc_krg(tiragesn,ns,fc,y,meta,std_e);


%sauvegarde informations
krg=mergestruct(nkrg,krg);
krg.reg=fct;
krg.con=tai_conc;
krg.ter_reg=nb_termes;

tps_stop=toc;
fprintf('\nExecution construction Krigeage: %6.4d s\n',tps_stop-tps_start);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Validation croisee
%%%%%Calcul des differentes erreurs
if meta.cv
    [krg.cv]=cross_validate_krg(krg,tirages,eval);  
    %les tirages et evaluations ne sont pas normalises (elles le seront
    %plus tard lors de la CV)

    tps_cv=toc;
    fprintf('Execution validation croisee Krigeage: %6.4d s\n\n',tps_cv-tps_stop);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end