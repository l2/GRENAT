%% Fonction assurant l'estimation des parametres (longueur de correlation)
% L. LAURENT -- 14/12/2011 -- luc.laurent@lecnam.net

function para_estim=estim_para_krg_ckrg(donnees,meta)
% affichages warning ou non
aff_warning=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition des parametres de minimisation
% Nombre de parametres a estimer
%anisotropie
if meta.para.aniso
    nb_para=donnees.in.nb_var;
    nb_para_optim=nb_para;
else
    nb_para=1;
    nb_para_optim=nb_para;
end

%critere arret minimisation
crit_opti=meta.para.crit_opti;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
fprintf('      > Estimation parametres <\n');
fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
[tMesu,tInit]=mesu_time;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% traitement des cas particuliers (fonctions de correlation exponentielles
% generalisees)
switch meta.corr
    case 'corr_expg'
        %definition des bornes de l'espace de recherche
        lb=[meta.para.l_min*ones(1,nb_para) meta.para.p_min];
        ub=[meta.para.l_max*ones(1,nb_para) meta.para.p_max];
        nb_para_optim=nb_para+1;
    case 'corr_expgg'
        %definition des bornes de l'espace de recherche
        lb=[meta.para.l_min*ones(1,nb_para) meta.para.p_min*ones(1,nb_para)];
        ub=[meta.para.l_max*ones(1,nb_para) meta.para.p_max*ones(1,nb_para)];
        nb_para_optim=2*nb_para;
    otherwise
        %definition des bornes de l'espace de recherche
        lb=meta.para.l_min*ones(1,nb_para);ub=meta.para.l_max*ones(1,nb_para);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%on recherche si le motif tir_min_ est present dans le nom de strategie
motif='tir_min_';
[motfind]=strfind(meta.para.method,motif);

if isempty(motfind)
    method_optim=meta.para.method;
    tir_min_ok=false;
else
    method_optim=meta.para.method((motfind+numel(motif)):end);
    tir_min_ok=true;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Definition manuelle de la population initiale par LHS/IHS (Ga)
popInitManu=meta.para.popManu;
if popInitManu
    nbpopspecif=false;
    if isfield(meta.para,'nbPopInit');if ~isempty(meta.para.nbPopInit);nbpopspecif=false;end, end
    if nbpopspecif;nbPopInit=meta.para.nbPopInit;else nbPopInit=10*nb_para_optim; end
end

%definition valeur de depart de la variable
x0=lb+1/5*(ub-lb);
% Definition de la function a minimiser
fun=@(para)bloc_krg_ckrg(donnees,meta,para);
%Options algo pour chaque fonction de minimisation
%declaration des options de la strategie de minimisation
options_fmincon = optimset(...
    'Display', 'iter',...        %affichage evolution
    'Algorithm','interior-point',... %choix du type d'algorithme
    'OutputFcn',@stop_estim,...      %fonction assurant l'arret de la procedure de minimisation et les traces des iterations de la minimisation
    'FunValCheck','off',...      %test valeur fonction (Nan,Inf)
    'UseParallel','never',...
    'PlotFcns','',...   %{@optimplotx,@optimplotfunccount,@optimplotstepsize,@optimplotfirstorderopt,@optimplotconstrviolation,@optimplotfval}
    'TolFun',crit_opti);
options_sqp = optimset(...
    'Display', 'iter',...        %affichage evolution
    'Algorithm','sqp',... %choix du type d'algorithme
    'OutputFcn',@stop_estim,...      %fonction assurant l'arret de la procedure de minimisation et les traces des iterations de la minimisation
    'FunValCheck','off',...      %test valeur fonction (Nan,Inf)
    'UseParallel','never',...
    'PlotFcns','',...   %{@optimplotx,@optimplotfunccount,@optimplotstepsize,@optimplotfirstorderopt,@optimplotconstrviolation,@optimplotfval}
    'TolFun',crit_opti,...
    'MaxFunEvals',2000,... %nombre maxi d'iterations (3000 pour interior-point)
    'TolX',1e-8);
options_fminbnd = optimset(...
    'Display', 'iter',...        %affichage evolution
    'OutputFcn',@stop_estim,...      %fonction assurant l'arret de la procedure de minimisation et les traces des iterations de la minimisation
    'FunValCheck','off',...      %test valeur fonction (Nan,Inf)
    'UseParallel','never',...
    'PlotFcns','');
options_ga = gaoptimset(...
    'Display', 'iter',...        %affichage evolution
    'OutputFcn',@stop_estim,...      %fonction assurant l'arret de la procedure de minimisation et les traces des iterations de la minimisation
    'PopInitRange',[lb(:)';ub(:)'],...  %zone de d�finition de la population initiale
    'UseParallel','always',...
    'PlotFcns','',...
    'TolFun',crit_opti,...
    'StallGenLimit',50);
options_fminsearch = optimset(...
    'Display', 'iter',...        %affichage evolution
    'OutputFcn',@stop_estim,...      %fonction assurant l'arret de la procedure de minimisation et les traces des iterations de la minimisation
    'FunValCheck','off',...      %test valeur fonction (Nan,Inf)
    'TolFun',crit_opti,...
    'PlotFcns','');
%%%%% PSOt
%options algo PSO de la toolbox PSOt
ac      = [2.1,2.1];% acceleration constants, only used for modl=0
Iwt     = [0.9,0.6];  % intertia weights, only used for modl=0
epoch   = 2000; % max iterations
wt_end  = 100; % iterations it takes to go from Iwt(1) to Iwt(2), only for modl=0
errgrad = 1e-25;   % lowest error gradient tolerance
errgraditer=150; % max # of epochs without error change >= errgrad
PSOseed = 0;    % if=1 then can input particle starting positions, if= 0 then all random
% starting particle positions (first 20 at zero, just for an example)
PSOT_plot=[];
PSOT_tirage = [];
PSOT_mv=4; %vitesse maxi des particules (=4 def)
shw=0;      %MAJ affichage a chque iteration (0 sinon)
ps=nbPopInit; %nb de particules
errgoal=NaN;    %cible minimisation
modl=3;         %type de PSO
%                   0 = Common PSO w/intertia (default)
%                 1,2 = Trelea types 1,2
%                 3   = Clerc's Constricted PSO, Type 1"

PSOT_options=...
    [shw epoch ps ac(1) ac(2) Iwt(1) Iwt(2) ...
    wt_end errgrad errgraditer errgoal modl PSOseed];
%variation des parametres
PSOT_varrange=[lb(:) ub(:)];
%minimisation
PSOT_minmax=0;

%%%%%

%affichage des iterations
if ~meta.para.aff_iter_graph
    options_fmincon=optimset(options_fmincon,'OutputFcn','');
    options_sqp=optimset(options_sqp,'OutputFcn','');
    options_fminbnd=optimset(options_fminbnd,'OutputFcn','');
    options_fminsearch=optimset(options_fminbnd,'OutputFcn','');
    options_ga=gaoptimset(options_ga,'OutputFcn','');
else
    figure
end
if ~meta.para.aff_iter_cmd
    options_fmincon=optimset(options_fmincon,'Display', 'final');
    options_sqp=optimset(options_sqp,'Display', 'final');
    options_fminbnd=optimset(options_fminbnd,'Display', 'final');
    options_fminsearch=optimset(options_fminbnd,'Display', 'final');
    options_ga=gaoptimset(options_ga,'Display', 'final');
end

%affichage informations interations algo (sous forme de plot)
if meta.para.aff_plot_algo
    options_fmincon=optimset(options_fmincon,'PlotFcns',{@optimplotx,@optimplotfunccount,...
        @optimplotstepsize,@optimplotfirstorderopt,@optimplotconstrviolation,@optimplotfval});
    options_sqp=optimset(options_sqp,'PlotFcns',{@optimplotx,@optimplotfunccount,...
        @optimplotstepsize,@optimplotfirstorderopt,@optimplotconstrviolation,@optimplotfval});
    options_ga=gaoptimset(options_ga,'PlotFcns',{@gaplotbestf,@gaplotbestindiv,@gaplotdistance,...
        @gaplotexpectation,@gaplotmaxconstr,@gaplotrange,@gaplotselection,...
        @gaplotscorediversity,@gaplotscores,@gaplotstopping});
    %%PSOT
    PSOT_plot='goplotpso_perso1';
    PSOT_options(1)=10;
end

%specification manuelle de la population initiale (Ga ou PSOt)
if ~isempty(popInitManu)&&~tir_min_ok
    %si la toolbox LMTir est disponible, on l'utilise sinon on fait avec ce
    %qu'on a...
    if exist('gene_doe','file')
        doePop.Xmin=lb;doePop.Xmax=ub;doePop.nb_samples=nbPopInit;doePop.aff=false;doePop.type=meta.para.popManu;
        tir=gene_doe(doePop);
        tir_pop=tir.tri;
        %on tente d'utiliser lhsdesign si la toolbox Statistics est dispo
    elseif exist('lhsdesign','file')
        fprintf('>> Toolbox LMTir indisponible: usage de lhsdesign\n')
        tir_pop=lhsdesign(nbPopInit,nb_para_optim);
        tir_pop=tir_pop.*repmat(ub(:)'-lb(:)',prod(nbPopInit(:)),1)+...
            repmat(lb(:)',prod(nbPopInit(:)),1);
        %sinon on realise un tirage aleatoire avec rand
    else
        fprintf('>> Toolbox LMTir et lhsdesign indisponibles: usage de rand\n')
        tir_pop=rand(nbPopInit,nb_para_optim);
        tir_pop=tir_pop.*repmat(ub(:)'-lb(:)',prod(nbPopInit(:)),1)+...
            repmat(lb(:)',prod(nbPopInit(:)),1);
    end
    options_ga=gaoptimset(options_ga,'PopulationSize',nbPopInit,'InitialPopulation',tir_pop);
    %PSOt
    PSOT_tirage=tir_pop;
    PSOT_options(13)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% traitement des strategie de type tir_min_xxxx

% si tir_min alors on fait un tirage pour rechercher un point
% d'initialisation de l'algorithme
if tir_min_ok
    nb_pts=nb_para*10;
    type_tir='LHS_O1';
    fprintf('||Tir_min + opti||  Tirage %s de %i points\n',type_tir,nb_pts);
    %si la toolbox LMTir est disponible, on l'utilise sinon on fait avec ce
    %qu'on a...
    if exist('gene_doe','file')
        doePop.Xmin=lb;doePop.Xmax=ub;doePop.nb_samples=nbPopInit;doePop.aff=false;doePop.type=meta.para.popManu;
        tir=gene_doe(doePop);
        tir_pop=tir.tri;
        %on tente d'utiliser lhsdesign si la toolbox Statistics est dispo
    elseif exist('lhsdesign','file')
        fprintf('>> Toolbox LMTir indisponible: usage de lhsdesign\n')
        tir_pop=lhsdesign(nbPopInit,nb_para_optim);
        tir_pop=tir_pop.*repmat(ub(:)'-lb(:)',prod(nbPopInit(:)),1)+...
            repmat(lb(:)',prod(nbPopInit(:)),1);
        %sinon on realise un tirage aleatoire avec rand
    else
        fprintf('>> Toolbox LMTir et lhsdesign indisponibles: usage de rand\n')
        tir_pop=rand(nbPopInit,nb_para_optim);
        tir_pop=tir_pop.*repmat(ub(:)'-lb(:)',prod(nbPopInit(:)),1)+...
            repmat(lb(:)',prod(nbPopInit(:)),1);
    end
    crit=zeros(1,nb_pts);
    parfor tir=1:nb_pts
        crit(tir)=fun(tir_pop(tir,:));
    end
    [fval1,IX]=min(crit);
    x0=tir_pop(IX,:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%minimisation de la log-vraisemblance suivant l'algorithme choisi
switch method_optim
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'simplex'  %methode du simplexe
        fprintf('||Simplex|| Initialisation au point:\n');
        fprintf('%g ',x0); fprintf('\n');
        if ~aff_warning;warning off all;end
        [x, fmax, nf] = nmsmax(fun, x0, [], []);
        %stockage retour algo
        para_estim.out_algo.fmax=fmax;
        para_estim.out_algo.nf=nf;
        if ~aff_warning;warning on all;end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'tir_min'
        nb_pts=nb_para*50;
        type_tir='LHS_O1';
        fprintf('||Tir_min||  Tirage %s de %i points\n',type_tir,nb_pts);
        doePop.Xmin=lb;doePop.Xmax=ub;doePop.nb_samples=nb_pts;doePop.aff=false;doePop.type=type_tir;
        tir_pop=gene_doe(doePop);
        crit=zeros(1,nb_pts);
        parfor tir=1:nb_pts
            crit(tir)=fun(tir_pop(tir,:));
        end
        [fval,IX]=min(crit);
        x=tir_pop(IX,:);
        
        %stockage retour algo
        para_estim.out_algo.fval=fval;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'sqp'
        fprintf('||Fmincon (SQP)|| Initialisation au point:\n');
        fprintf('%g ',x0); fprintf('\n');
        %minimisation avec traitement de point de depart non defini
        if ~aff_warning;warning off all;end
        %pas de recherche d'initialisation
        [x,fval,exitflag,output] = fmincon(fun,x0,[],[],[],[],lb,ub,[],options_sqp);
        %arret minimisation
        if exitflag==1||exitflag==0||exitflag==2
            disp('Arret')
            para_estim.out_algo=output;
            para_estim.out_algo.fval=fval;
            para_estim.out_algo.exitflag=exitflag;
            if exist('fval1','var');para_estim.out_algo.fval1=fval1;end
        elseif exitflag==-2
            fprintf('Bug arret SQP\n');
        end
        if ~aff_warning;warning on all;end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'fminbnd'
        fprintf('||Fminbnd|| Initialisation au point:\n');
        fprintf('%g ',x0); fprintf('\n');
        %minimisation
        if ~aff_warning;warning off all;end
        [x,fval,exitflag,output] = fminbnd(fun,lb,ub,options_fminbnd);
        if ~aff_warning;warning on all;end
        %arret minimisation
        if exitflag==1||exitflag==0||exitflag==2
            disp('Arret')
            para_estim.out_algo=output;
            para_estim.out_algo.fval=fval;
            para_estim.out_algo.exitflag=exitflag;
            if exist('fval1','var');para_estim.out_algo.fval1=fval1;end
        elseif exitflag==-2
            fprintf('Bug arret SQP\n');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'fminsearch'
        fprintf('||Fminsearch|| Initialisation au point:\n');
        fprintf('%g ',x0); fprintf('\n');
        %minimisation
        [x,fval,exitflag,output] = fminsearch(fun,x0,options_fminsearch);
        %arret minimisation
        if exitflag==1||exitflag==0||exitflag==2
            disp('Arret')
            para_estim.out_algo=output;
            para_estim.out_algo.fval=fval;
            para_estim.out_algo.exitflag=exitflag;
            if exist('fval1','var');para_estim.out_algo.fval1=fval1;end
        elseif exitflag==-2
            fprintf('Bug arret Fminsearch\n');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'fmincon'
        fprintf('||Fmincon|| Initialisation au point:\n');
        fprintf('%g ',x0); fprintf('\n');
        %minimisation avec traitement de point de depart non defini
        if ~aff_warning;warning off all;end
        %pas de recherche d'initialisation
        [x,fval,exitflag,output] = fmincon(fun,x0,[],[],[],[],lb,ub,[],options_fmincon);
        %arret minimisation
        if exitflag==1||exitflag==0||exitflag==2
            disp('Arret')
            para_estim.out_algo=output;
            para_estim.out_algo.fval=fval;
            para_estim.out_algo.exitflag=exitflag;
            if exist('fval1','var');para_estim.out_algo.fval1=fval1;end
        elseif exitflag==-2
            fprintf('Bug arret Fmincon\n');
        end
        if ~aff_warning;warning on all;end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'ga'
        fprintf('||Ga|| Initialisation par tirages %s:\n',popInitManu);
        if ~aff_warning;warning off all;end
        [x,fval,exitflag,output] = ga(fun,nb_para_optim,[],[],[],[],lb,ub,[],options_ga);
        %arret minimisation
        if exitflag==1||exitflag==0||exitflag==2
            disp('Arret')
            para_estim.out_algo=output;
            para_estim.out_algo.fval=fval;
            para_estim.out_algo.exitflag=exitflag;
            if exist('fval1','var');para_estim.out_algo.fval1=fval1;end
        elseif exitflag==-2
            fprintf('Bug arret Ga\n');
        end
        
        if ~aff_warning;warning on all;end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'pso'
        fprintf('||PSOt|| Initialisation par tirages %s:\n',popInitManu);
        if ~aff_warning;warning off all;end
        %PSOt version vectorisee
        [pso_out,...    %pt minimum et reponse associee
            tr,...      %pt minimum a chaque iteration
            te...       %epoch? iterations
            ]=pso_Trelea_mod(...
            fun,...             %fonction
            nb_para,...         %nombre variables
            PSOT_mv,...         %vitesse maxi particules (def. 4)
            PSOT_varrange,...   %matrice des plages de variation des parametres
            PSOT_minmax,...     %minimisation (=0 def), maximisation (=1) ou autre (=2)
            PSOT_options,...    %vecteur options
            PSOT_plot,...       %fonction de tracee (optionnelle)
            PSOT_tirage);       %tirage initial aleatoire (=0) ou utilisateur (=1)
        
        %extraction infos
        Xmin=pso_out(1:end-1)';
        Zmin=pso_out(end);
        exitflag=[];
        output.tr=tr;
        output.te=te;
        disp('Arret')
        para_estim.out_algo=output;
        para_estim.out_algo.xval=Xmin;
        para_estim.out_algo.fval=Zmin;
        para_estim.out_algo.exitflag=exitflag;
        x=Xmin;
        if ~aff_warning;warning on all;end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    otherwise
        error('Strategie de minimisation non prise en charge');
end
mesu_time(tMesu,tInit);
fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
%stockage valeur parametres obtenue par minimisation
if nb_para_optim>nb_para
    para_estim.l_val=x(1:nb_para);
    para_estim.p_val=x(nb_para+1:end);
else
    para_estim.l_val=x;
end

if meta.norm
    para_estim.l_val_denorm=para_estim.l_val.*donnees.norm.std_tirages+donnees.norm.moy_tirages;
    fprintf('\nValeur(s) longueur(s) de correlation');
    fprintf(' %6.4f',para_estim.l_val_denorm);
    fprintf('\n');
end
fprintf('Valeur(s) longueur(s) de correlation (brut)');
fprintf(' %6.4f',para_estim.l_val);
fprintf('\n\n');
if nb_para_optim>nb_para
    fprintf('Valeur(s) longueur(s) puissance(s)');
    fprintf(' %6.4f',para_estim.p_val);
    fprintf('\n\n');
end
fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
end
