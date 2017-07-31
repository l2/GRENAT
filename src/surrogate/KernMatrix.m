%% Class for building Kernel Matrix for classical and gradient-enhanced kernel-based surrogate model
% L. LAURENT -- 27/04/2016 -- luc.laurent@lecnam.net
% class version - 18/07/2017

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

classdef KernMatrix < handle
    properties
        KK=[];              % matrix of kernel
        KKd=[];             % matrix of first derivatives
        KKdd=[];            % matrix of second derivatives
        %
        paraVal=[];         % values of the internal parameters
        sampling=[];        % sampling points
        newSample=[];       % in the cas of adding new sample points
        distC=[];           % vector of inter-points distances
        distN=[];           % vector of inter-points distances for new sample points
        distNO=[];          % vector of inter-points distances for new sample points (distance to the old ones)
        fctKern='sexp';     % chosen kernel function
    end
    properties (Dependent)
        
    end
    
    properties (Access = private)
        computeD=false;      % flag for computing matrices with gradients
        parallelW=1;         % number of workers for using parallel version
        %
        iX;                  % structure of indices
        NiX;                 % structure of indices for new sampling points
        requireRun=true;     % flag if a full building is required
        requireUpdate=false; % flag if an update is required
        requireIndices=true; % flag if an update of indices is required
        forceGrad=false;     % flag for forcing the computation of 1st and �nd derivatives of the kernel matrix
        %
        nbParaOk=[];         %number of acceptable internal parameters
        listKernel={'sexp','matern','matern32','matern52'};  %list of available kernel functions
        listKernelTxt={'Squared exponential','Matern','Matern 3/2','Matern 5/2'};  %list of available kernel functions
    end
    properties (Dependent,Access = private)
        NnS;               % number of new sample point
        nS;               % number of sample point
        nP;               % dimension of the problem
        parallelOk=false;    % flag for using parallel version
        %
    end
    %
    methods
        %%constructor
        function obj=KernMatrix(fct,sampling,val,parallel)
            %load arguments
            obj.fctKern=fct;
            obj.paraVal=val;
            obj.sampling=sampling;
            if nargin>3;obj.parallelW=parallel;end
        end
        %% setter and getter
        %setter for kernel function
        function set.fctKern(obj,fct)
            checkKernel=any(ismember(obj.loadKern,fct));
            if checkKernel
                obj.fctKern=fct;
            else
                fprintf('Kernel function %s not available (maintain %s)\n',fct,obj.fctKern);
                obj.showKernel;
            end
        end
        %setter for gradients calculations
        function set.computeD(obj,bool)
            oldFlag=obj.computeD;
            if ~oldFlag&&bool
                obj.fRun;
            end
            obj.computeD=bool;
        end
        %setter for internal parameter
        function set.paraVal(obj,pV)
            oldpV=obj.paraVal;
            if ~all(oldpV==pV)
                obj.fRun;
            end
            obj.paraVal=pV;
        end
        %setter for the flag to force gradient-matrix computation
        function set.forceGrad(obj,boolIn)
            oldFG=obj.forceGrad;
            if ~oldFG&&boolIn
                obj.fRun;
            end
            obj.forceGrad=boolIn;
        end
        
        %getter for the number of acceptable internal parameters
        function nb=get.nbParaOk(obj)
            nb=obj.computeNbPara;
        end
        %getter for the number of sample points
        function nS=get.nS(obj)
            nS=size(obj.sampling,1);
        end
        %getter for the number of new sample points
        function nS=get.NnS(obj)
            nS=size(obj.newSample,1);
        end
        %getter for the dimension
        function nP=get.nP(obj)
            nP=size(obj.sampling,2);
        end
        %getter for the flag for parallel
        function pO=get.parallelOk(obj)
            pO=(obj.parallelW>1);
        end
        
        
        %% other methods
        %initialize all flag
        function init(obj)
            obj.requireRun=true;     % flag if a full building is required
            obj.requireUpdate=false; % flag if an update is required
            obj.requireIndices=true; % flag if an update of indices is required
        end
        %check matrices
        function f=checkMatrix(obj)
            %check symetry
            fS=all(all(obj.KK==obj.KK'));
            %check eye
            fE=all(diag(obj.KK)==1);
            %check the adding process
            KKold=obj.KK;
            obj.sampling=[obj.sampling;obj.newSample];
            obj.requireRun=true;
            obj.requireIndices=true;
            KKnew=obj.buildMatrix();
            fA=all(all(KKold==KKnew));
            %
            f=(fS&&fE&&fA);
            %
            fprintf('Matrix ');
            if f; fprintf('OK'); else, fprintf('NOK');end
            fprintf('\n');
            if ~f;keyboard;end
        end
        %load list Kernel functions
        function l=loadKern(obj)
            l=obj.listKernel;
        end
        %compute indices
        function iX=computeIX(obj)
            if obj.requireIndices
                ns=obj.nS;
                np=obj.nP;
                % Building indices system
                %table of indices for inter-lenghts  (1), responses (1)
                tmpIX=allcomb(1:ns,1:ns);
                iXsampling=tmpIX(tmpIX(:,1)<=tmpIX(:,2),:);
                iXmatrix=(iXsampling(:,1)-1)*ns+iXsampling(:,2);
                %
                iX.iXsampling=iXsampling;
                iX.matrix=iXmatrix;
                %for gradients
                if obj.computeD
                    %
                    sizeMatRc=(ns^2+ns)/2;
                    sizeMatRa=np*sizeMatRc;
                    sizeMatRi=np^2*sizeMatRc;
                    iXmatrixAb=zeros(sizeMatRa,1);
                    iXmatrixI=zeros(sizeMatRi,1);
                    %
                    ite=0;
                    iteAb=0;
                    %table of indices for 1st derivatives (2)
                    for ii=1:ns
                        %
                        ite=ite(end)+(1:(ns-ii+1));
                        iteAb=iteAb(end)+(1:((ns-ii+1)*np));
                        %
                        debb=(ii-1)*np*ns+ii;
                        finb=ns^2*np-(ns-ii);
                        lib=debb:ns:finb;
                        %
                        iXmatrixAb(iteAb)=lib;
                    end
                    %table of indices for second derivatives
                    a=zeros(ns*np,np);
                    decal=0;
                    precI=0;
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
                    %store indices
                    iX.matrixAb=iXmatrixAb;
                    iX.matrixI=iXmatrixI;
                end
                %
                obj.iX=iX;
                %
                obj.requireIndices=false;
            else
                iX=obj.iX;
            end
            
        end
        %compute new indices (after adding new sample points)
        function iX=computeNewIX(obj)
            oldNs=obj.nS;
            newNs=obj.NnS;
            np=obj.nP;
            % Building indices system
            if obj.computeD
                %
                sizeMatRc=(newNs^2+newNs)/2;
                sizeMatRa=np*sizeMatRc;
                sizeMatRi=np^2*sizeMatRc;
                iXmatrixAb=zeros(sizeMatRa,1);
                iXmatrixI=zeros(sizeMatRi,1);
                %
                iteAb=0;
                %table of indices for inter-lengths (1), responses (1) and 1st
                %derivatives (2)
                if newNs>1
                    for ii=1:newNs
                        %
                        iteAb=iteAb(end)+(1:((newNs-ii+1)*np));
                        %
                        debb=(ii-1)*newNs*np+ii;
                        finb=newNs*(newNs*np-1)+ii;
                        lib=debb:newNs:finb;
                        iXmatrixAb(iteAb)=lib;
                    end
                    %table of indices for second derivatives
                    a=zeros(newNs*np,np);
                    decal=0;
                    precI=0;
                    for ii=1:newNs
                        li=1:newNs*np^2;
                        a(:)=decal+li;
                        decal=a(end);
                        b=a';
                        %
                        iteI=precI+(1:(np^2*(newNs-(ii-1))));
                        %
                        debb=(ii-1)*np^2+1;
                        finb=np^2*newNs;
                        iteb=debb:finb;
                        iXmatrixI(iteI)=b(iteb);
                        precI=iteI(end);
                    end
                end
            end
            %table of indices for inter-lenghts  (1), responses (1)
            iXsamplingNO=allcomb(1:newNs,1:oldNs);      %old and new
            tmpIX=allcomb(1:newNs,1:newNs);
            iXsamplingN=tmpIX(tmpIX(:,1)<=tmpIX(:,2),:); %new only
            %linear indices
            iXmatrixNO=(iXsamplingNO(:,1)-1)*oldNs+iXsamplingNO(:,2);
            iXmatrixN=(iXsamplingN(:,1)-1)*newNs+iXsamplingN(:,2);
            %keyboard
            %
            iX.iXsamplingNO=iXsamplingNO;
            iX.iXsamplingN=iXsamplingN;
            iX.matrixNO=iXmatrixNO;
            iX.matrixN=iXmatrixN;
            %iXmatrixAb
            iX.matrixAb=iXmatrixAb;
            iX.matrixI=iXmatrixI;
            obj.NiX=iX;
        end
        
        %compute inter-points distances
        function distC=computeDist(obj)
            distC=obj.sampling(obj.iX.iXsampling(:,1),:)-obj.sampling(obj.iX.iXsampling(:,2),:);
            obj.distC=distC;
        end
        %compute new inter-points distances (since new sample points are
        %added)
        function [distN,distNO]=computeNewDist(obj)
            distN=obj.newSample(obj.NiX.iXsamplingN(:,1),:)-obj.newSample(obj.NiX.iXsamplingN(:,2),:);
            distNO=obj.newSample(obj.NiX.iXsamplingNO(:,1),:)-obj.sampling(obj.NiX.iXsamplingNO(:,2),:);
            obj.distN=distN;
            obj.distNO=distNO;
        end
        %new run required
        function fRun(obj);obj.requireRun=true;end
        %force gradients matrices computation
        function fGrad(obj);obj.forceGrad=true;end
        %force indices computation
        function fIX(obj);obj.requireIndices=true;end
        %compute number of required internal parameters
        function nbP=computeNbPara(obj)
            switch obj.fctKern
                case {'sexp','matern32','matern52'}
                    nbP=unique([1,obj.nP]);
                case {'matern'}
                    nbP=[1,obj.nP]+1;
            end
        end
        %
        function [KK,KKd,KKdd]=buildMatrix(obj,paraV)
            %obj.init;
            %changing the values of the internal parameters
            if nargin>1;obj.paraVal=paraV;end
            %depending on the number of output arguments
            if nargout>1||obj.forceGrad;obj.computeD=true;end
            %if already computed, then load it otherwise calculate it
            if obj.requireRun
                %compute indices and distances
                obj.computeIX;
                obj.computeDist;
                %
                ns=obj.nS;
                np=obj.nP;
                %
                fctK=obj.fctKern;
                dC=obj.distC;
                pVl=obj.paraVal;
                %if derivatives required
                if obj.computeD
                    %if parallel workers are available
                    if obj.parallelOk
                        %%REWRITE
                        %                         %%%%%% PARALLEL %%%%%%
                        %                         %various parts of the Kernel Matrix
                        %                         KK=zeros(ns,ns);
                        %                         KKa=cell(1,ns);
                        %                         KKi=cell(1,ns);
                        %                         %
                        %                         parfor ii=1:ns
                        %                             %Building by column & evaluation of the Kernel function
                        %                             [ev,dev,ddev]=multiKernel(fctK,dC(:,ii),pVl);
                        %                             %classical part
                        %                             KK(:,ii)=ev;
                        %                             %part of the first derivatives
                        %                             KKa{ii}=dev;
                        %                             %part of the second derivatives
                        %                             KKi{ii}=reshape(ddev,np,ns*np);
                        %                         end
                        %                         %Reordering matrices
                        %                         KKd=horzcat(KKa{:});
                        %                         KKdd=vertcat(KKi{:});
                    else
                        %evaluation of the kernel function for all inter-points
                        %keyboard
                        [ev,dev,ddev]=multiKernel(fctK,dC,pVl);
                        %various parts of the kernel Matrix
                        KK=zeros(ns,ns);
                        KKd=zeros(ns,np*ns);
                        KKdd=zeros(ns*np,ns*np);
                        %classical part
                        KK(obj.iX.matrix)=ev;
                        %correction of the duplicated terms on the diagonal
                        KK=KK+KK'-eye(ns);
                        %first and second derivatives of the kernel function
                        devT=dev';
                        %KKd(obj.iX.matrixA)=-dev(obj.iX.dev);
                        KKd(obj.iX.matrixAb)=devT(:);%dev(obj.iX.devb);
                        %keyboard
                        
                        KKdT=reshape(permute(reshape(KKd',[np,ns,ns]),[2,1,3]),[ns ns*np 1]);
                        KKd=KKd-KKdT;
                        %
                        KKdd(obj.iX.matrixI)=ddev(:);
                        %extract diagonal (process for avoiding duplicate terms)
                        diago=0;   % //!!\\ possible corrections here
                        val_diag=spdiags(KKdd,diago);
                        KKdd=KKdd+KKdd'-spdiags(val_diag,diago,zeros(size(KKdd))); %correction of the duplicated terms on the diagonal
                        %keyboard
                    end
                    obj.KK=KK;
                    obj.KKd=KKd;
                    obj.KKdd=KKdd;
                else
                    if obj.parallelOk
                        %REWRITE
                        %                         %%%%%% PARALLEL %%%%%%
                        %                         %classical kernel matrix by column
                        %                         KK=zeros(ns,ns);
                        %                         parfor ii=1:ns
                        %                             % evaluate kernel function
                        %                             [ev]=multiKernel(fctK,dC(:,ii),pVl);
                        %                             % kernel matrix by column
                        %                             KK(:,ii)=ev;
                        %                         end
                    else
                        %classical kernel matrix (lower triangular matrix)
                        %without diagonal
                        KK=zeros(ns,ns);
                        % evaluate kernel function
                        [ev]=multiKernel(fctK,dC,pVl);
                        %keyboard
                        KK(obj.iX.matrix)=ev;
                        %Build full kernel matrix
                        KK=KK+KK'-eye(ns);
                    end
                    obj.KK=KK;
                end
                obj.requireRun=false;
            else
                %if already computed then load it
                KK=obj.KK;
                KKd=obj.KKd;
                KKdd=obj.KKdd;
            end
        end
        %add new sample points
        function flag=addSample(obj,newS)
            flag=false;
            %remove dulicate
            [~,l,~]=unique(newS,'rows');
            newS=newS(sort(l),:);
            %flag at true if duplicate sample points are removed
            if size(newS,1)==numel(l);flag=true;end
            %check if new sample point already exists
            [~,Ln]=ismember(obj.sampling,newS,'rows');
            %
            Ln=Ln(Ln>0);
            if ~isempty(Ln)
                fprintf(' >> Duplicate sample points detected: remove it\n');
                newS(Ln,:)=[];
            end
            obj.newSample=newS;
            %%keyboard
            if ~isempty(obj.newSample)
                obj.requireUpdate=true;
            end
        end
        
        %function for updating the
        function [KK,KKd,KKdd]=updateMatrix(obj,newS)
            %store the new sample points
            if nargin>1;if ~isempty(newS);obj.addSample(newS); end, end
            %if nothing have been already built
            if obj.requireRun
                obj.requireUpdate=false;
                obj.sampling=[obj.sampling;obj.newSample];
                obj.newSample=[];
                if nargout==1
                    KK=obj.buildMatrix;
                else
                    [KK,KKd,KKdd]=obj.buildMatrix;
                end
            end
            if obj.requireUpdate
                %calculation of the new distances and indices
                obj.computeNewIX();
                obj.computeNewDist();
                %
                oldNs=obj.nS;
                newNs=obj.NnS;
                np=obj.nP;
                %
                dN=obj.distN;
                dNO=obj.distNO;
                distM=[dNO;dN];
                nbNO=size(dNO,1);
                nbN=size(dN,1);
                %
                fctK=obj.fctKern;
                pVl=obj.paraVal;
                %depending on the number of output arguments
                if nargout>1
                    obj.computeD=true;
                    %if the first and second derivatives matrices have not been
                    %calculated before, we calculate it yet
                    if isempty(obj.KKd)
                        obj.sampling=[obj.sampling;newS];
                        obj.requireRun=true;
                        obj.requireIndices=true;
                        [KK,KKd,KKdd]=obj.buildMatrix;
                    else
                        if obj.parallelOk
                            %%REWRITE
                            %                         %%%%%% PARALLEL %%%%%%
                            %                         %various parts of the Kernel Matrix
                            %                         KKON=zeros(oldNs,newNs);
                            %                         KKN=zeros(newNs,newNs);
                            %                         KKUa=cell(1,ns);
                            %                         KKUi=cell(1,ns);
                            %                         %%
                            %                         %
                            %                         parfor ii=1:ns
                            %                             %Building by column & evaluation of the Kernel function
                            %                             [ev,dev,ddev]=multiKernel(fctK,distM(:,ii),pVl);
                            %                             %classical part
                            %                             KK(:,ii)=ev;
                            %                             %part of the first derivatives
                            %                             KKa{ii}=dev;
                            %                             %part of the second derivatives
                            %                             KKi{ii}=reshape(ddev,np,ns*np);
                            %                         end
                            %                         %Reordering matrices
                            %                         KKd=horzcat(KKa{:});
                            %                         KKdd=vertcat(KKi{:});
                        else
                            %evaluation of the kernel function for all inter-points
                            [ev,dev,ddev]=multiKernel(fctK,distM,pVl);
                            %various parts of the kernel Matrix
                            KKNO=zeros(oldNs,newNs);
                            KKN=zeros(newNs,newNs);
                            %classical part
                            KKNO(obj.NiX.matrixNO)=ev(1:nbNO);
                            KKN(obj.NiX.matrixN)=ev(nbNO+(1:nbN));
                            %correction of the new sample point kernel matrix
                            KKN=KKN+KKN'-eye(newNs);
                            %assembly of the updated kernel matrix
                            KK=[obj.KK KKNO;KKNO' KKN];
                            obj.KK=KK;
                            %
                            %build the new cross kernel matrix (1st
                            %derivatives)
                            KKdN=zeros(newNs,newNs*np);
                            %depending on the number of new sample points
                            if newNs==1
                                %old-new part
                                KKdON=-dev(1:end-1,:);
                                %new part
                                KKdN=-dev(end,:);
                            else
                                %old-new part
                                KKdON=-cell2mat(mat2cell(dev(1:newNs*oldNs,:),oldNs*ones(1,newNs),np)');
                                %new part by "triangular" matrix
                                devT=dev(newNs*oldNs+1:end,:)';
                                KKdN(obj.NiX.matrixAb)=devT(:);
                                KKdNT=reshape(permute(reshape(KKdN',[np,newNs,newNs]),[2,1,3]),[newNs newNs*np 1]);
                                %
                                KKdN=KKdN-KKdNT;
                            end
                            %new-old part
                            KKdNO=-reshape(permute(reshape(KKdON',[np,newNs,oldNs]),[2,1,3]),[newNs,oldNs*np,1]);
                            %build the full new cross kernel matrix (1st
                            %derivatives)
                            KKd=[obj.KKd KKdON;KKdNO KKdN];
                            obj.KKd=KKd;
                            %
                            %build the new cross kernel matrix of second
                            %derivatives
                            %old-new part
                            rD=reshape(ddev(:,:,1:oldNs*newNs),np,np,oldNs,newNs);
                            cellD=mat2cell(rD,np,np,ones(1,oldNs),ones(1,newNs));
                            KKddNO=cell2mat(reshape(cellD,oldNs,newNs));
                            %new part by "triangular" matrix
                            ddevT=ddev(:,:,oldNs*newNs+1:end);
                            %depending on the number of new sample points
                            if newNs==1
                                KKddN=ddevT;
                            else
                                KKddN=zeros(newNs*np,newNs*np);
                                KKddN(obj.NiX.matrixI)=ddevT(:);
                                %extract diagonal (process for avoiding duplicate terms)
                                diago=0;   % //!!\\ corrections possible here
                                valDiag=spdiags(KKddN,diago);
                                KKddN=KKddN+KKddN'-spdiags(valDiag,diago,zeros(size(KKddN))); %correction of the duplicated terms on the diagonal
                            end
                            %build the full new cross kernel matrix (2nd
                            %derivatives)
                            KKdd=[obj.KKdd KKddNO;KKddNO' KKddN];
                            obj.KKdd=KKdd;
                        end
                    end
                else
                    if obj.parallelOk
                        %REWRITE
                        %                         %%%%%% PARALLEL %%%%%%
                        %                         %classical kernel matrix by column
                        %                         KK=zeros(ns,ns);
                        %                         parfor ii=1:ns
                        %                             % evaluate kernel function
                        %                             [ev]=multiKernel(fctK,dC(:,ii),pVl);
                        %                             % kernel matrix by column
                        %                             KK(:,ii)=ev;
                        %                         end
                    else
                        %classical kernel matrix (lower triangular matrix)
                        %without diagonal
                        KKNO=zeros(oldNs,newNs);
                        KKN=zeros(newNs,newNs);
                        % evaluate kernel function
                        [ev]=multiKernel(fctK,distM,pVl);
                        %classical part
                        KKNO(obj.NiX.iXmatrixNO)=ev(1:nbNO);
                        KKN(obj.NiX.iXmatrixN)=ev(nbNO+(1:nbN));
                        %correction of the new sample point kernel matrix
                        KKN=KKN+KKN'-eye(newNs);
                        %assembly of the updated kernel matrix
                        KK=[obj.KK KKNO;KKNO' KKN];
                        obj.KK=KK;
                    end
                end
                obj.requireUpdate=false;
                obj.sampling=[obj.sampling;obj.newSample];
                obj.newSample=[];
            else
                %if already computed then load it
                KK=obj.KK;
                KKd=obj.KKd;
                KKdd=obj.KKdd;
            end
        end
        %manual getters for matrices
        function K=getKK(obj)
            if isempty(obj.KK)||obj.requireRun||obj.requireUpdate
                K=obj.updateMatrix();
            else
                K=obj.KK;
            end
        end
        function K=getKKd(obj)
            obj.fGrad;
            obj.fIX;
            if isempty(obj.KKd)||obj.requireRun||obj.requireUpdate
                [~,K,~]=obj.updateMatrix();
            else
                K=obj.KKd;
            end
        end
        function K=getKKdd(obj)
            obj.fGrad;
            obj.fIX;
            if isempty(obj.KKd)||obj.requireRun||obj.requireUpdate
                [~,~,K]=obj.updateMatrix();
            else
                K=obj.KKdd;
            end
        end
        %show the list of available kernel functions
        function showKernel(obj)
            fprintf('List of available kernel functions\n');
            dispTableTwoColumns(obj.listKernel,obj.listKernelTxt)
        end
    end
end



%% function display table with two columns of text
function dispTableTwoColumnsStruct(tableFieldIn,structIn)
%size of every components in tableA
sizeA=cellfun(@numel,tableFieldIn);
maxA=max(sizeA);
%space after each component
spaceA=maxA-sizeA+3;
spaceTxt=' ';
%display table
for itT=1:numel(tableFieldIn)
    if isfield(structIn,tableFieldIn{itT})
        fprintf('%s%s%s\n',tableFieldIn{itT},spaceTxt(ones(1,spaceA(itT))),structIn.(tableFieldIn{itT}));
    end
end
end

%% function display table with two columns of text
function dispTableTwoColumns(tableA,tableB)
%size of every components in tableA
sizeA=cellfun(@numel,tableA);
maxA=max(sizeA);
%space after each component
spaceA=maxA-sizeA+3;
spaceTxt=' ';
%display table
for itT=1:numel(tableA)
    fprintf('%s%s%s\n',tableA{itT},spaceTxt(ones(1,spaceA(itT))),tableB{itT});
end
end

