%% Building of the KRG/GKRG matrix and computation of the log-likelihood
% L. LAURENT -- 05/01/2011 -- luc.laurent@lecnam.net

% the kernel matrix K can be also designetd as the correlation matrix

function [lilog,ret]=KRGBloc(dataIn,metaData,paraValIn)

%coefficient for reconditionning (co)kriging matrix
coefRecond=(10+size(dataIn.build.fct,1))*eps;
% chosen factorization for (G)KRG matrix
if strcmp(metaData.type,'CKRG')
    factKK='LU';
else
    factKK='LU' ; %LU %QR %LL %None
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load useful variables
ns=dataIn.in.nb_val;
np=dataIn.in.nb_var;
fctKern=metaData.kern;
ret=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if the hyperparameter is defined
final=false;
if nargin==3
    paraVal=paraValIn;
else
    paraVal=metaData.para.val;
    final=true;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Build of the KRG/GRKG matrix
if dataIn.used.availGrad
    [KK,KKa,KKi]=KernMatrix(fctKern,dataIn,paraVal);
    KK=[KK KKa;KKa' KKi];
else
    [KK]=KernMatrix(fctKern,dataIn,paraVal);
end
%in the case of missing data
%responses
if metaData.miss.resp.on
    KK(metaData.miss.resp.ix_miss,:)=[];
    KK(:,metaData.miss.resp.ix_miss)=[];
end
%gradients
if dataIn.used.availGrad
    if metaData.miss.grad.on
        rep_ev=ns-metaData.miss.resp.nb;
        KK(rep_ev+metaData.miss.grad.ixt_miss_line,:)=[];
        KK(:,rep_ev+metaData.miss.grad.ixt_miss_line)=[];
    end
end

% if dataIn.in.pres_grad
%     %si parallelisme actif ou non
%     if metaData.worker_parallel>=2
%         %%%%%% PARALLEL %%%%%%
%         %morceaux de la matrice GKRG
%         rc=zeros(ns,ns);
%         rca=cell(1,ns);
%         rci=cell(1,ns);
%         parfor ii=1:ns
%             %distance 1 tirages aux autres (construction par colonne)
%             one_tir=tiragesn(ii,:);
%             dist=one_tir(ones(1,ns),:)-tiragesn;
%             % evaluation de la fonction de correlation
%             [ev,dev,ddev]=feval(fctKern,dist,paraVal);
%             %morceau de la matrice issue du modele KRG classique
%             rc(:,ii)=ev;
%             %morceau des derivees premieres
%             rca{ii}=dev;
%             %matrice des derivees secondes
%             rci{ii}=-reshape(ddev,np,ns*np);
%         end
%         %%construction des matrices completes
%         rcaC=horzcat(rca{:});
%         rciC=vertcat(rci{:});
%         %Matrice de complete
%         rcc=[rc rcaC;rcaC' rciC];
%     else
%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %evaluation de la fonction de correlation pour les differents
%         %intersites
%         [ev,dev,ddev]=feval(fctKern,dataIn.in.dist,paraVal);
%
%         %morceau de la matrice issu du krigeage
%         rc=zeros(ns,ns);
%         rca=zeros(ns,np*ns);
%         rci=zeros(ns*np,ns*np);
%
%         rc(dataIn.ind.matrix)=ev;
%         rc=rc+rc'-eye(dataIn.in.nb_val);
%
%         rca(dataIn.ind.matrixA)=dev(dataIn.ind.dev);
%         rca(dataIn.ind.matrixAb)=-dev(dataIn.ind.devb);
%         rci(dataIn.ind.matrixI)=-ddev(:);
%         %extraction de la diagonale (procedure pour eviter les doublons)
%         diago=0;   % //!!\\ corrections envisageables ici
%         val_diag=spdiags(rci,diago);
%         rci=rci+rci'-spdiags(val_diag,diago,zeros(size(rci))); %correction termes diagonaux pour eviter les doublons
%
%         %Matrice de correlation du Cokrigeage
%         rcc=[rc rca;rca' rci];
%     end
%     %si donnees manquantes
%     if dataIn.manq.eval.on
%         rcc(dataIn.manq.eval.ix_manq,:)=[];
%         rcc(:,dataIn.manq.eval.ix_manq)=[];
%     end
%
%     %si donnees manquantes
%     if dataIn.manq.grad.on
%         rep_ev=ns-dataIn.manq.eval.nb;
%         rcc(rep_ev+dataIn.manq.grad.ixt_manq_line,:)=[];
%         rcc(:,rep_ev+dataIn.manq.grad.ixt_manq_line)=[];
%     end
% else
%
%     if metaData.worker_parallel>=2
%         %%%%%% PARALLEL %%%%%%
%         %matrice de KRG classique par bloc
%         rcc=zeros(ns,ns);
%         parfor ii=1:ns
%             %distance 1 tirages aux autres (construction par colonne)
%             one_tir=tiragesn(ii,:);
%             dist=one_tir(ones(1,ns),:)-tiragesn;
%             % evaluation de la fonction de correlation
%             [ev]=feval(fctKern,dist,paraVal);
%             %morceau de la matrice issue du modele RBF classique
%             rcc(:,ii)=ev;
%         end
%     else
%         %matrice de correlation du Krigeage par matrice triangulaire inferieure
%         %sans diagonale
%         rcc=zeros(ns,ns);
%         % evaluation de la fonction de correlation
%         [ev]=feval(fctKern,dataIn.in.dist,paraVal);
%         rcc(dataIn.ind.matrix)=ev;
%         %Construction matrice complete
%         rcc=rcc+rcc'+eye(ns);
%     end
%     %toc
%     %si donnees manquantes
%     if dataIn.manq.eval.on
%         rcc(dataIn.manq.eval.ix_manq,:)=[];
%         rcc(:,dataIn.manq.eval.ix_manq)=[];
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Improve condition number of the RBF/GRBF Matrix
if metaData.recond
    %origCond=condest(rcc);
    KK=KK+coefRecond*speye(size(KK));
    %newCond=condest(rcc);
    %fprintf('>>> Improving of the condition number: \n%g >> %g  <<<\n',...
    %    origCond,newCond);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%condition number of the KRG/GKRG Matrix
if final   % in the phase of building
    newCond=condest(KK);
    fprintf('Condition number KRG/GKRG matrix: %4.2e\n',newCond)
    if newCond>1e16
        fprintf('+++ //!\\ Bad condition number\n');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Factorization of the matrix
switch factKK
    case 'QR'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %QR factorization
        [QK,RK,PK]=qr(KK);
        QtK=QK';
        yQ=QtK*dataIn.build.y;
        fctQ=QtK*dataIn.build.fct;
        fcK=dataIn.build.fc*PK/RK;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute beta coefficient
        fcCfct=fcK*fctQ;
        block2=fcK*yQ;
        beta=fcCfct\block2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute gamma coefficient
        gamma=PK*(RK\(yQ-fctQ*beta));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %save variables
        buildData.yQ=yQ;
        buildData.fctQ=fctQ;
        buildData.fcK=fcK;
        buildData.fcCfct=fcCfct;
        buildData.RK=RK;
        buildData.QK=QK;
        buildData.QtK=QtK;
        buildData.PK=PK;
        
    case 'LU'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %LU factorization
        [LK,UK,PK]=lu(KK,'vector');
        yP=dataIn.build.y(PK,:);
        fctP=dataIn.build.fct(PK,:);
        yL=LK\yP;
        fctL=LK\fctP;
        fcU=dataIn.build.fc/UK;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute beta coefficient
        fcCfct=fcU*fctL;
        block2=fcU*yL;
        beta=fcCfct\block2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute gamma coefficient
        gamma=UK\(yL-fctL*beta);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %save variables
        buildData.yL=yL;
        buildData.fcU=fcU;
        buildData.fctL=fctL;
        buildData.fcCfct=fcCfct;
        buildData.LL=LK;
        buildData.UK=UK;
        buildData.PK=PK;
    case 'LL'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Cholesky's fatorization
        %%% to be degugged
        LK=chol(KK,'lower');
        LtK=LK';
        yL=LK\dataIn.build.y;
        fctL=LK\dataIn.build.fct;
        fcL=dataIn.build.fc/LtK;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute beta coefficient
        fcCfct=fcL*fctL;
        block2=fcL*yL;
        beta=fcCfct\block2;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute gamma coefficient
        gamma=LtK\(yL-fctL*beta);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %save variables
        buildData.yL=yL;
        buildData.fcL=fcL;
        buildData.fctL=fctL;
        buildData.fcCfct=fcCfct;
        buildData.LtK=LtK;
        buildData.LK=LK;
    otherwise
        %classical approach
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %compute gamma and beta coefficients
        fcC=dataIn.build.fc/KK;
        fcCfct=fcC*dataIn.build.fct;
        block2=((dataIn.build.fc/KK)*dataIn.build.y);
        beta=fcCfct\block2;
        gamma=KK\(dataIn.build.y-dataIn.build.fct*beta);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %save variables
        buildData.fcC=fcC;
        buildData.fcCfct=fcCfct;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%store variables
if exist('origCond','var');buildData.origCond=origCond;end
if exist('newCond','var');buildData.newCond=newCond;end

buildData.beta=beta;
buildData.gamma=gamma;
buildData.KK=KK;
buildData.polyOrder=metaData.polyOrder;
buildData.para=metaData.para;
buildData.kern=metaData.kern;
buildData.factKK=factKK;
ret.build=buildData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%variance of the Gaussian process
ret.build.sig2=1/size(KK,1)*...
    ((dataIn.build.y-dataIn.build.fct*ret.build.beta)'*ret.build.gamma);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute of the Likelihood (and log-likelihood)
[lilog,ret.li]=KRGLikelihood(ret);
ret.lilog=lilog;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%denormalisation sigma^2
if metaData.normOn&&~isempty(dataIn.norm.resp.std)
    ret.build.sig2=ret.build.sig2*dataIn.norm.resp.std^2;
else
    ret.build.sig2=ret.build.sig2;
end
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%