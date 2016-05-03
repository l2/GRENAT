%% Function for building Radial Basis Function surrogate model
% RBF: w/o gradient
% GRBF: avec gradients
% L. LAURENT -- 15/03/2010 -- luc.laurent@lecnam.net
% change on 12/04/2010 and on 15/01/2012

function ret=RBFBuild(samplingIn,respIn,gradIn,metaData,missData)

[tMesu,tInit]=mesuTime;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Building information
textd='++ Type: ';
textf='';
fprintf('\n%s\n',[textd 'Radial Basis Function (RBF)' textf]);
%
fprintf('>>> Building : ');
if ~isempty(gradIn);fprintf('GRBF \n');else fprintf('RBF \n');end
fprintf('>>> Kernel function: %s\n',metaData.kern);
%
fprintf('>>> CV: ');if metaData.cv.on; fprintf('Yes\n');else fprintf('No\n');end
fprintf('>> Computation all CV criteria: ');if metaData.cv.full; fprintf('Yes\n');else fprintf('No\n');end
fprintf('>> Show CV: ');if metaData.cv.disp; fprintf('Yes\n');else fprintf('No\n');end
%
fprintf('>>> Estimation of the hyperparameters: ');if metaData.para.estim; fprintf('Yes\n');else fprintf('No\n');end
if metaData.para.estim
    fprintf('>> Algorithm for estimation: %s\n',metaData.para.method);
    fprintf('>> Bounds: [%d , %d]\n',metaData.para.l.min,metaData.para.l.max);
    switch metaData.kern
        case {'expg','expgg'}
            fprintf('>> Bounds for exponent: [%d , %d]\n',metaData.para.p.min,metaData.para.p.max);
        case 'matern'
            fprintf('>> Bounds for nu (Matern): [%d , %d]\n',metaData.para.nu.min,metaData.para.nu.max);
    end
    fprintf('>> Anisotropy: ');if metaData.para.aniso; fprintf('Yes\n');else fprintf('No\n');end
    fprintf('>> Show estimation steps in console: ');if metaData.para.dispIterCmd; fprintf('Yes\n');else fprintf('No\n');end
    fprintf('>> Plot estimation steps: ');if metaData.para.dispIterGraph; fprintf('Yes\n');else fprintf('No\n');end
else
    fprintf('>> Value hyperparameter: %d\n',metaData.para.l.val);
    switch metaData.kern
        case {'expg','expgg'}
            fprintf('>> Value of the exponent: [%d , %d]\n',metaData.para.p.val);
        case {'matern'}
            fprintf('>> Value of nu (Matern): [%d , %d]\n',metaData.para.nu.val);
    end
end
fprintf('>>> Infill criteria:');
if metaData.infill.on;
    fprintf('%s\n','Yes');
    fprintf('>> Balancing WEI: ')
    fprintf('%d ',metaData.infill.paraWEI);
    fprintf('\n')
    fprintf('>> Balancing GEI: ')
    fprintf('%d ',metaData.infill.paraGEI);
    fprintf('\n')
    fprintf('>> Balancing LCB: %d\n',metaData.infill.paraLCB);
else
    fprintf('%s\n','No');
end
fprintf('\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load global variables
global aff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialisation of the variables
%number of sample points
ns=size(respIn,1);
%number of design variables
np=size(samplingIn,2);

%check availability of the gradients
gradAvail=~isempty(gradIn);
%check missing data
if nargin==5
    missResp=missData.resp.on;
    missGrad=missData.grad.on;
    gradAvail=(~missData.grad.all&&missData.grad.on)||(gradAvail&&~missData.grad.on);
else
    missData.resp.on=false;
    missData.grad.on=false;
    missResp=missData.resp.on;
    missGrad=missData.grad.on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Responses and gradients at sample points
YY=respIn;
%remove missing response(s)
if missResp
    YY=YY(missData.eval.ixAvail);
end
if gradAvail
    tmp=gradn';
    der=tmp(:);
    %remove missing gradient(s)
    if missGrad
        der=der(missData.grad.ixtAvailLine);
    end
    YY=vertcat(YY,der);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building indexes system for building RBF/GRBF matrices
if gradAvail
    size_matRc=(ns^2+ns)/2;
    size_matRa=np*(ns^2+ns)/2;
    size_matRi=np^2*(ns^2+ns)/2;
    iXmat=zeros(size_matRc,1);
    iXmatA=zeros(size_matRa,1);
    iXmatAb=zeros(size_matRa,1);
    iXmatI=zeros(size_matRi,1);
    iXdev=zeros(size_matRa,1);
    iXsampling=zeros(size_matRc,2);
    
    tmpList=zeros(size_matRc,np);
    tmpList(:)=1:size_matRc*np;
    
    ite=0;
    iteA=0;
    iteAb=0;
    pres=0;
    %table of indexes for inter-lengths (1), responses (1) and 1st
    %derivatives (2)
    for ii=1:ns
        
        ite=ite(end)+(1:(ns-ii+1));
        iXmat(ite)=(ns+1)*ii-ns:ii*ns;
        iXsampling(ite,:)=[ii(ones(ns-ii+1,1)) (ii:ns)'];
        iteAb=iteAb(end)+(1:((ns-ii+1)*np));
        
        debb=(ii-1)*np*ns+ii;
        finb=ns^2*np-(ns-ii);
        lib=debb:ns:finb;
        
        iXmatAb(iteAb)=lib;
        
        for jj=1:np
            iteA=iteA(end)+(1:(ns-ii+1));
            shiftA=(ii-1);
            deb=pres+shiftA;
            li=deb + (1:(ns-ii+1));
            iXmatA(iteA)=li;
            pres=li(end);
            liste_tmpB=reshape(tmpList',[],1);
            iXdev(iteA)=tmpList(ite,jj);
            iXdevb=liste_tmpB;
        end
    end
    %table of indexes for second derivatives
    a=zeros(ns*np,np);
    shiftA=0;
    precI=0;
    iteI=0;
    for ii=1:ns
        li=1:ns*np^2;
        a(:)=shiftA+li;
        shiftA=a(end);
        b=a';
        
        iteI=precI+(1:(np^2*(ns-(ii-1))));
        
        debb=(ii-1)*np^2+1;
        finb=np^2*ns;
        iteb=debb:finb;
        iXmatI(iteI)=b(iteb);
        precI=iteI(end);
    end
else
    %table of indexes for inter-lenghts  (1), responses (1)
    bmax=ns-1;
    iXmat=zeros(ns*(ns-1)/2,1);
    iXsampling=zeros(ns*(ns-1)/2,2);
    ite=0;
    for ii=1:bmax
        ite=ite(end)+(1:(ns-ii));
        iXmat(ite)=(ns+1)*ii-ns+1:ii*ns;
        iXsampling(ite,:)=[ii(ones(ns-ii,1)) (ii+1:ns)'];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%computation of the inter-distances
distC=samplingIn(iXsampling(:,1),:)-samplingIn(iXsampling(:,2),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%store varibales des grandeurs
ret.in.sampling=samplingIn;
ret.in.dist=distC;
ret.in.eval=respIn;
ret.in.pres_grad=gradAvail;
ret.in.grad=gradIn;
ret.in.np=np;
ret.in.ns=ns;
ret.ix.matrix=iXmat;
ret.ix.sampling=iXsampling;
if gradAvail
    ret.ix.matrixA=iXmatA;
    ret.ix.matrixAb=iXmatAb;
    ret.ix.matrixI=iXmatI;
    ret.ix.dev=iXdev;
    ret.ix.devb=iXdevb;
end
ret.build.y=YY;
ret.manq=missData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation of the MSE of the  Cross-Validation
%display CV is required
CvOld=metaData.cv;
dispCvOld=metaData.cv.disp;
metaData.cv.disp=false;

if metaData.para.estim&&metaData.para.dispEstim
    valPara=linspace(metaData.para.l.min,metaData.para.l.max,gene_nbele(np));
    % load progress bar
    cpb = ConsoleProgressBar();
    minVal = 0;
    maxVal = 100;
    cpb.setMinimum(minVal);
    cpb.setMaximum(maxVal);
    cpb.setLength(20);
    cpb.setRemainedTimeVisible(1);
    cpb.setRemainedTimePosition('left');
    %for anisotropy (with 2 design variables)
    if metaData.para.aniso&&np==2
        %building of the studied grid
        [valX,valY]=meshgrid(valPara,valPara);
        %initialize matrix for storing MSE
        valMSEp=zeros(size(valX));
        for itli=1:numel(valX)
            %computation of the MSE and storage
            valMSEp(itli)=RBFBloc(ret,metaData,[valX(itli) valY(itli)]);
            %show progress and time
            cpb.setValue(itli/numel(valX));
        end
        cpb.stop();
        %display MSE
        figure;
        [C,h]=contourf(valX,valY,valMSEp);
        text_handle = clabel(C,h);
        set(text_handle,'BackgroundColor',[1 1 .6],...
            'Edgecolor',[.7 .7 .7])
        set(h,'LineWidth',2)
        %store figure in TeX/Tikz file
        if metaData.save
            matlab2tikz([aff.doss '/RBFmse.tex'])
        end
        
    elseif ~metaData.para.aniso||np==1
        %initialize matrix for storing MSE
        valMSEp=zeros(1,length(valPara));
        cvRippa=valMSEp;
        cvCustom=valMSEp;
        for itli=1:length(valPara)
            %computation of the MSE and storage
            [~,buildRBF]=RBFbloc(ret,metaData,valPara(itli),'etud');
            cvRippa(itli)=buildRBF.cv.and.eloot;
            cvCustom(itli)=buildRBF.cv.then.eloot;
            %show progress and time
            cpb.setValue(itli/numel(valPara));
        end
        cpb.stop();
        
        %store in .dat file
        if metaData.save
            ss=[valPara' valMSEp'];
            save([aff.doss '/RBFmse.dat'],'ss','-ascii');
        end
        
        %display MSE
        figure;
        semilogy(valPara,cvRippa,'r');
        hold on
        semilogy(valPara,cvCustom,'k');
        legend('Rippa (Bompard)','Custom');
        title('CV');
    end
    
    %store graphs (if active)
    if aff.save&&(ns<=2)
        fileStore=save_aff('fig_mse_cv',aff.doss);
        if aff.tex
            fid=fopen([aff.doss '/fig.tex'],'a+');
            fprintf(fid,'\\figcen{%2.1f}{../%s}{%s}{%s}\n',0.7,fileStore,'MSE',fileStore);
            %fprintf(fid,'\\verb{%s}\n',fich);
            fclose(fid);
        end
    end
end
%reload initial configurations
metaData.cv_aff=dispCvOld;
metaData.cv=CvOld;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Building of the various elements with and without estimation of the
%%hyperparameters if no estimation the values of the hyperparameters are
%%chosen using empirical choice of  Hardy/Franke
if metaData.para.estim
    paraEstim=EstimPara(ret,metaData,'RBFBloc');
    ret.build.para_estim=paraEstim;
    metaData.para.l.val=paraEstim.l.val;
    metaData.para.val=paraEstim.l.val;
    if isfield(paraEstim,'p')
        metaData.para.p.val=paraEstim.p.val;
        metaData.para.val=[metaData.para.val metaData.para.p.val];
    end
else
    metaData.para.l.val=RBFComputePara(samplingIn,metaData);
    switch metaData.kern
        case {'expg','expgg'}
            metaData.para.val=[metaData.para.l.val metaData.para.p.val];
        case {'matern'}
            metaData.para.val=[metaData.para.l.val metaData.para.nu.val];
        otherwise
            metaData.para.val=metaData.para.l.val;
    end
    fprintf('Values of the hyperparameters (%s):',metaData.para.type);
    fprintf(' %d',metaData.para.val);
    fprintf('\n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building final elements of the RBF surrogate model (matrices, coefficients & CV)
% by taking into account the values of hyperparameters obtained previously
[~,block]=RBFBloc(ret,metaData);
%save information
tmp=mergestruct(ret.build,block.build);
ret.build=tmp;
ret.cv=block.cv;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if gradAvail;txt='GRBF';else txt='RBF';end
fprintf('\nBuilding %s\n',txt);
mesuTime(tMesu,tInit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


