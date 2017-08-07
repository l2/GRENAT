%% function for building kriging and cokriging surrogate model
% KRG: kriging
% GKRG: cokriging w/- gradients
% L. LAURENT -- 12/12/2011 -- luc.laurent@lecnam.net

%     GRENAT - GRadient ENhanced Approximation Toolbox 
%     A toolbox for generating and exploiting gradient-enhanced surrogate models
%     Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [ret]=KRGBuild(samplingIn,respIn,gradIn,metaData,missData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Building information
textd='++ Type: ';
textf='';
Gfprintf('\n%s\n',[textd 'Kriging ((G)KRG)' textf]);
%
Gfprintf('>>> Building : ');
dispTxtOnOff(~isempty(gradIn),'GKRG','KRG',true);
Gfprintf('>> Kernel function: %s\n',metaData.kern);
Gfprintf('>> Deg : %i ',metaData.polyOrder);
dispTxtOnOff(metaData.para.polyOrder==0,'(Ordinary)','(Universal)',true);
%
if dispTxtOnOff(metaData.cv.on,'>> CV: ',[],true)
    dispTxtOnOff(metaData.cv.full,'>> Computation all CV criteria: ',[],true);
    dispTxtOnOff(metaData.cv.disp,'>> Show CV: ',[],true);
end
%
dispTxtOnOff(metaData.recond,'>> Correction of matrix condition:',[],true);
if dispTxtOnOff(metaData.estim.on,'>> Estimation of the hyperparameters: ',[],true)
    Gfprintf('>> Algorithm for estimation: %s\n',metaData.estim.method);
    Gfprintf('>> Bounds: [%d , %d]\n',metaData.para.l.Min,metaData.para.l.Max);
    switch metaData.kern
        case {'expg','expgg'}
            Gfprintf('>> Bounds for exponent: [%d , %d]\n',metaData.para.p.Min,metaData.para.p.Max);
        case 'matern'
            Gfprintf('>> Bounds for nu (Matern): [%d , %d]\n',metaData.para.nu.Min,metaData.para.nu.Max);
    end
    dispTxtOnOff(metaData.estim.aniso,'>> Anisotropy: ',[],true);
    dispTxtOnOff(metaData.estim.dispIterCmd,'>> Show estimation steps in console: ',[],true);
    dispTxtOnOff(metaData.estim.dispIterGraph,'>> Plot estimation steps: ',[],true);
else
    Gfprintf('>> Value(s) hyperparameter(s):');
    fprintf('%d',metaData.para.l.Val);
    fprintf('\n');
    switch metaData.kern
        case {'expg','expgg'}
            Gfprintf('>> Value of the exponent:');
            fprintf(' %d',metaData.para.p.Val);
            fprintf('\n');
        case {'matern'}
            Gfprintf('>> Value of nu (Matern): %d \n',metaData.para.nu.Val);
    end
end
%
Gfprintf('\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load global variables
global dispData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialisation of the variables
%number of sample points
ns=size(respIn,1);
%number of design variables
np=size(samplingIn,2);

%check availability of the gradients
availGrad=~isempty(gradIn);
%check missing data
if isfield(metaData,'miss')
    missResp=metaData.miss.resp.on;
    missGrad=metaData.miss.grad.on;
    availGrad=(~metaData.miss.grad.all&&metaData.miss.grad.on)||(availGrad&&~metaData.miss.grad.on);
else
    metaData.miss.resp.on=false;
    metaData.miss.grad.on=false;
    missResp=missData.miss.resp.on;
    missGrad=metaData.miss.grad.on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Responses and gradients at sample points
YY=respIn;
%remove missing response(s)
if missResp
    YY=YY(metaData.miss.resp.ixAvail);
end

if availGrad
    tmp=gradIn';
    der=tmp(:);
    %remove missing gradient(s)
    if missGrad
        der=der(missData.grad.ixAvailLine);
    end
    YY=vertcat(YY,der);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building indexes system for building KRG/GKRG matrices
if availGrad
    
    sizeMatRc=(ns^2+ns)/2;
    sizeMatRa=np*(ns^2+ns)/2;
    sizeMatRi=np^2*(ns^2+ns)/2;
    iXmatrix=zeros(sizeMatRc,1);
    iXmatrixA=zeros(sizeMatRa,1);
    iXmatrixAb=zeros(sizeMatRa,1);
    iXmatrixI=zeros(sizeMatRi,1);
    iXdev=zeros(sizeMatRa,1);
    iXsampling=zeros(sizeMatRc,2);
    
    tmpList=zeros(sizeMatRc,np);
    tmpList(:)=1:sizeMatRc*np;
    
    ite=0;
    iteA=0;
    iteAb=0;
    pres=0;
    %table of indexes for inter-lengths (1), responses (1) and 1st
    %derivatives (2)
    for ii=1:ns
        
        ite=ite(end)+(1:(ns-ii+1));
        iXmatrix(ite)=(ns+1)*ii-ns:ii*ns;
        iXsampling(ite,:)=[ii(ones(ns-ii+1,1)) (ii:ns)'];
        iteAb=iteAb(end)+(1:((ns-ii+1)*np));
        
        debb=(ii-1)*np*ns+ii;
        finb=ns^2*np-(ns-ii);
        lib=debb:ns:finb;
        
        iXmatrixAb(iteAb)=lib;
        
        for jj=1:np
            iteA=iteA(end)+(1:(ns-ii+1));
            decal=(ii-1);
            deb=pres+decal;
            li=deb + (1:(ns-ii+1));
            iXmatrixA(iteA)=li;
            pres=li(end);
            liste_tmpB=reshape(tmpList',[],1);
            iXdev(iteA)=tmpList(ite,jj);
            iXdevb=liste_tmpB;
        end
    end
    %table of indexes for second derivatives
    a=zeros(ns*np,np);
    decal=0;
    precI=0;
    iteI=0;
    for ii=1:ns
        li=1:ns*np^2;
        a(:)=decal+li;
        decal=a(end);
        b=a';
        
        iteI=precI+(1:(np^2*(ns-(ii-1))));
        
        debb=(ii-1)*np^2+1;
        finb=np^2*ns;
        iteb=debb:finb;
        iXmatrixI(iteI)=b(iteb);
        precI=iteI(end);
    end
else
    %table of indexes for inter-lenghts  (1), responses (1)
    bmax=ns-1;
    iXmatrix=zeros(ns*(ns-1)/2,1);
    iXsampling=zeros(ns*(ns-1)/2,2);
    ite=0;
    for ii=1:bmax
        ite=ite(end)+(1:(ns-ii));
        iXmatrix(ite)=(ns+1)*ii-ns+1:ii*ns;
        iXsampling(ite,:)=[ii(ones(ns-ii,1)) (ii+1:ns)'];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute distances between sample points
distC=samplingIn(iXsampling(:,1),:)-samplingIn(iXsampling(:,2),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build regression matrix (for the trend model)

%depending on the availability of the gradients
if ~availGrad
    valFunPoly=MultiMono(samplingIn,metaData.polyOrder);
    if missResp
        %remove missing response(s)
        valFunPoly=valFunPoly(metaData.miss.resp.ixAvail,:);
    end
else
    %gradient-based
    [MatX,MatDX]=MultiMono(samplingIn,metaData.polyOrder);
    nbMonomialTerms=size(MatX,2);
    if missResp||missGrad
        sizeResp=ns-missData.resp.nb;
        sizeGrad=ns*np-missData.grad.nb;
        sizeTotal=sizeResp+sizeGrad;
    else
        sizeResp=ns;
        sizeGrad=ns*np;
        sizeTotal=sizeResp+sizeGrad;
    end
    %initialize regression matrix
    valFunPoly=zeros(sizeTotal,nbMonomialTerms);
    if missResp
        %remove missing response(s)
        MatX=MatX(metaData.miss.resp.ixAvail,:);
    end
    %load monomial terms of the polynomial regression
    valFunPoly(1:sizeResp,:)=MatX;
    %load derivatives of the monomial terms
    if iscell(MatDX)
        tmp=horzcat(MatDX{:})';
        tmp=reshape(tmp,nbMonomialTerms,[])';
    else
        tmp=MatDX';
        tmp=tmp(:);
    end
    
    if missGrad
        %remove missing gradient(s)
        tmp=tmp(missData.grad.ixt_dispo_line,:);
    end
    %add derivatives to the regression matrix
    valFunPoly(sizeResp+1:end,:)=tmp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%store variables
ret.used.sampling=samplingIn;
ret.used.dist=distC;
ret.used.resp=respIn;
ret.used.availGrad=availGrad;
ret.used.grad=gradIn;
ret.used.np=np;
ret.used.ns=ns;
ret.ix.matrix=iXmatrix;
ret.ix.sampling=iXsampling;
if availGrad
    ret.ix.matrixA=iXmatrixA;
    ret.ix.matrixAb=iXmatrixAb;
    ret.ix.matrixI=iXmatrixI;
    ret.ix.dev=iXdev;
    ret.ix.devb=iXdevb;
end
ret.build.fct=valFunPoly;
ret.build.fc=valFunPoly';
ret.build.sizeFc=size(valFunPoly,2);
ret.build.y=YY;
ret.build.kern=metaData.kern;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute log-likelihood for estimating parameters
if metaData.estim.on&&metaData.estim.disp
    valPara=linspace(metaData.para.l.Min,metaData.para.l.Max,100);
    % load progress bar
    cpb = ConsoleProgressBar();
    minVal = 0;
    maxVal = 100;
    cpb.setMinimum(minVal);
    cpb.setMaximum(maxVal);
    cpb.setLength(20);
    cpb.setRemainedTimeVisible(1);
    cpb.setRemainedTimePosition('left');
    cpb.start();
    %for anisotropy (with 2 design variables)
    if metaData.estim.aniso&&np==2
        %building of the studied grid
        [valX,valY]=meshgrid(valPara,valPara);
        %initialize matrix for storing log-likelihood
        valLik=zeros(size(valX));
        for itli=1:numel(valX)
            %compute log-likelihood and storage
            valLik(itli)=KRGBloc(ret,metaData,[valX(itli) valY(itli)]);
            %show progress and time
            cpb.setValue(itli/numel(valX)*100);
        end
        Gfprintf('\n');
        cpb.stop();
        %plot log-vraisemblance
        figure;
        [C,h]=contourf(valX,valY,valLik);
        text_handle = clabel(C,h);
        set(text_handle,'BackgroundColor',[1 1 .6],...
            'Edgecolor',[.7 .7 .7])
        set(h,'LineWidth',2)
        %store figure in TeX/Tikz file
        if metaData.estim.save
            matlab2tikz([dispData.directory '/KRGlogli.tex'])
        end
        
    elseif ~metaData.estim.aniso||np==1
        %initialize matrix for storing log-likelihood
        valLik=zeros(1,length(valPara));
        for itli=1:length(valPara)
            %compute log-likelihood and storage
            valLik(itli)=KRGBloc(ret,metaData,valPara(itli));
            cpb.setValue(itli/numel(valPara)*100);
        end
        Gfprintf('\n');
        cpb.stop();
        
        %store in .dat file
        if metaData.estim.save
            ss=[valPara' valLik'];
            save([dispData.directory '/KRGlogli.dat'],'ss','-ascii');
        end
        
        %plot log-vraisemblance
        figure;
        plot(valPara,valLik);
        title('Evolution of the log-likelihood');
    end
    
    %store graphs (if active)
    if dispData.save&&(ns<=2)
        fileStore=saveDisp('fig_likelihood',dispData.directory);
        if dispData.tex
            fid=fopen([dispData.directory '/fig.tex'],'a+');
            fprintf(fid,'\\figcen{%2.1f}{../%s}{%s}{%s}\n',0.7,fileStore,'Log-Likelihood',fileStore);
            %fprintf(fid,'\\verb{%s}\n',fich);
            fclose(fid);
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Building of the various elements with and without estimation of the
% hyperparameters
if metaData.estim.on
    paraEstim=EstimPara(ret,metaData,'KRGBloc');
    ret.build.paraEstim=paraEstim;
    metaData.para.l.Val=paraEstim.l.Val;
    metaData.para.Val=paraEstim.Val;
    if isfield(paraEstim,'p')
        metaData.para.p.Val=paraEstim.p.Val;
    end
    if isfield(paraEstim,'nu')
        metaData.para.nu.Val=paraEstim.nu.Val;
    end
else
    %w/o estimation, the initial values of hyperparameters are chosen
    switch metaData.kern
        case {'expg','expgg'}
            metaData.para.Val=[metaData.para.l.Val metaData.para.p.Val];
        case {'matern'}
            metaData.para.Val=[metaData.para.l.Val metaData.para.nu.Val];
        otherwise
            metaData.para.Val=metaData.para.l.Val;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Building final elements of the KRG surrogate model (matrices, coefficients & log-likelihood)
% by taking into account the values of hyperparameters obtained previously
[lilog,blocKRG]=KRGBloc(ret,metaData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%store informations
tmp=mergestruct(ret.build,blocKRG.build);
ret.build=tmp;
ret.build.lilog=lilog;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cross-validation (compute various errors)
if metaData.cv.on
    %countTime=mesuTime;
    Gfprintf(' > Computation CV\n');
    [ret.build.cv]=KRGCV(ret,metaData);
    %countTime.stop;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if availGrad;txt='GKRG';else txt='KRG';end
Gfprintf('\n >> END Building %s\n',txt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


%% function for display information
function boolOut=dispTxtOnOff(boolIn,txtInTrue,txtInFalse,returnLine)
boolOut=boolIn;
if nargin==2
    txtInFalse=[];
    returnLine=false;
elseif nargin==3
    returnLine=false;
end
if isempty(txtInFalse)
    Gfprintf('%s',txtInTrue);if boolIn; fprintf('Yes');else, fprintf('No');end
else
    if boolIn; fprintf('%s',txtInTrue);else, fprintf('%s',txtInFalse);end
end
if returnLine
    fprintf('\n');
end
end

