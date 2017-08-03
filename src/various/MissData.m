%% class for checking input data for finding missing information
% L. LAURENT -- 02/08/2017 -- luc.laurent@lecnam.net

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

classdef MissData < handle
    properties
        verbose=true;               % display information or note
        %
        sampling=[];                % sample points
        resp=[];                    % sample responses
        grad=[];                    % sample gradients
        %
        maskResp=[];                % mask of non-nan responses
        nbMissResp=0;               % number of missing responses
        ixMissResp=[];              % indices of the missing responses
        ixAvailResp;                % indices of available responses
        missRespAll=false;          % flag at true if all responses are missing
        %
        maskGrad=[];                % mask of non-nan gradients
        nbMissGrad=0;               % number of missing gradients
        ixMissGrad=[];              % indices of the missing gradients
        ixAvailGrad;                % indices of available gradients
        ixMissGradLine=[];          % linear indices of the missing gradients
        ixAvailGradLine;            % linear indices of available gradients
        missGradAll=false;          % flag at true if all gradients are missing
    end
    properties (Dependent,Access = private)
        NnS;                    % number of new sample points
        nS;                     % number of sample points
        nP;                     % dimension of the problem
        %
        emptyGrad;              % flag for empty gradient matrix
        %
    end
    properties (Dependent)
        on;                     % flag for missing data
        onResp;                 % flag for missing data in responses
        onGrad;                 % flag for missing data in gradients
    end
    methods
        %% constructor
        function obj=MissData(samplingIn,respIn,gradIn)
            %initialize class
            obj.sampling=samplingIn;
            obj.resp=respIn;
            if nargin>2
                obj.grad=gradIn;
            end
            %
            obj.check();
        end
        %% getters
        function n=get.nP(obj)
            n=size(obj.sampling,2);
        end
        function n=get.nS(obj)
            n=size(obj.sampling,1);
        end
        function f=get.emptyGrad(obj)
            f=isempty(obj.grad);
        end
        function f=get.onResp(obj)
            f=(obj.nbMissResp~=0);
        end
        function f=get.onGrad(obj)
            f=(obj.nbMissGrad~=0);
        end
        function f=get.on(obj)
            f=(obj.onResp||obj.onGrad);
        end
        
        %% check missing data
        function check(obj)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Gfprintf(' >> Check missing data \n');
            %
            obj.checkResp();
            obj.checkGrad();
            obj.show();
        end
        %% check responses
        function iX=checkResp(obj,respIn)
            respCheck=obj.resp;
            if nargin>1
                respCheck=respIn;
            end
            %look for missing data in responses
            obj.maskResp=isnan(respCheck);
            obj.nbMissResp=sum(obj.maskResp);
            obj.ixMissResp=find(obj.maskResp==true);
            obj.ixAvailResp=find(obj.maskResp==false);
            %
            iX.maskResp=obj.maskResp;
            iX.nbMissResp=obj.nbMissResp;
            iX.ixMissResp=obj.ixMissResp;
            iX.ixAvailResp=obj.ixAvailResp;
            iX.nbMissResp=obj.nbMissResp;
            %
            if nargin==1
                obj.missRespAll=false;
                if obj.nbMissResp==obj.nS;obj.missRespAll=true;end
                iX.missRespAll=obj.missRespAll;
            end
            
        end
        %% check gradients
        function iX=checkGrad(obj,gradIn)
            %classical version
            gradCheck=obj.grad;
            runGrad=~obj.emptyGrad;
            %version with input data
            if nargin>1
                gradCheck=gradIn;
                runGrad=~isempty(gradCheck);
            end
            if runGrad
                %classical matrix of gradients
                obj.maskGrad=isnan(gradCheck);
                obj.nbMissGrad=sum(obj.maskGrad(:));
                [r,c]=find(obj.maskGrad==true);
                obj.ixMissGrad=[r c];
                [r,c]=find(obj.maskGrad==false);
                obj.ixAvailGrad=[r c];
                [ix]=find(obj.maskGrad'==true);
                obj.ixMissGradLine=ix;
                [ix]=find(obj.maskGrad'==false);
                obj.ixAvailGradLine=ix;
                %
                iX.maskGrad=obj.maskGrad;
                iX.nbMissGrad=obj.nbMissGrad;
                iX.ixMissGrad=obj.ixMissGrad;
                iX.ixAvailGrad=obj.ixAvailGrad;
                iX.ixMissGradLine=obj.ixMissGradLine;
                iX.ixAvailGradLine=obj.ixAvailGradLine;
                %
                if nargin==1
                    obj.missGradAll=false;
                    if obj.nbMissGrad==obj.nS*obj.nP;obj.missGradAll=true;end
                    iX.missGradAll=obj.missGradAll;
                end
            end
        end
        %% show information
        function show(obj)
            if obj.verbose
                if obj.nbMissResp==0&&obj.nbMissGrad==0
                    Gfprintf('>>> No missing data\n');
                end
                %
                if obj.nbMissResp~=0
                    Gfprintf('>>> %i Missing response(s) at point(s):\n',obj.nbMissResp);
                    %
                    for ii=1:obj.nbMissResp
                        numPts=obj.ixMissResp(ii);
                        Gfprintf(' n%s %i (%4.2f',char(176),numPts,obj.sampling(numPts,1));
                        if obj.nP>1;fprintf(',%4.2f',obj.sampling(numPts,2:end));end
                        fprintf(')\n');
                    end
                end
                %
                if ~obj.emptyGrad
                    if obj.nbMissGrad~=0
                        Gfprintf('>>> %i Missing gradient(s) at point(s):\n',obj.nbMissGrad);
                        %sort responses
                        [~,iS]=sort(obj.ixMissGrad(:,1));
                        %
                        for ii=1:obj.nbMissGrad
                            numPts=obj.ixMissGrad(iS(ii),1);
                            component=obj.ixMissGrad(ii,2);
                            Gfprintf(' n%s %i (%4.2f',char(176),numPts,obj.sampling(numPts,1));
                            if obj.nP>1;fprintf(',%4.2f',obj.sampling(numPts,2:end));end
                            fprintf(')');
                            fprintf('  component: %i\n',component);
                        end
                        Gfprintf('----------------\n')
                    end
                end
            end
        end
        %% add new sample points
        function addData(obj,samplingIn,respIn,gradIn)
            %
            obj.sampling=[obj.sampling;samplingIn];
            obj.resp=[obj.resp;respIn];
            obj.grad=[obj.grad;gradIn];
            %
            obj.check();
        end
        %% remove missing data in vector/matrix (responses)
        function VV=removeRV(obj,V,force)
            %size of the input vector
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if sV(1)==obj.nS||force
                VV=V(~obj.maskResp,:);
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input vector\n ++ |%i, expected: %i| (or use force)\n',sV(1),obj.nS);
            end
        end
        function VV=removeRM(obj,V,force)
            %size of the input matrix
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if (sV(1)==obj.nS&&sV(2)==obj.nS)||force
                VV=V;
                VV(obj.ixMissResp,:)=[];
                VV(:,obj.ixMissResp)=[];
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input square matrix\n ++ |(%i,%i), expected: (%i,%i)| (or use force)\n',sV(1),sV(2),obj.nS,obj.nS);
            end
        end
        
        %% remove missing data in vector/matrix (gradients)
        function VV=removeGV(obj,V,force)
            %size of the input vector
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if sV(1)==obj.nS*obj.nP||force
                VV=V(obj.ixAvailGradLine,:);
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input vector\n ++ |%i, expected: %i| (or use force)\n',sV,obj.nS*obj.nP);
            end
        end
        function VV=removeGM(obj,V)
            %size of the input vector
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if (sV(1)==obj.nS*obj.nP&&sV(2)==obj.nS*obj.nP)||force
                VV=V;
                VV(obj.ixMissGradLine,:)=[];
                VV(:,obj.ixMissGradLine)=[];
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input square matrix\n ++ |(%i,%i), expected: (%i,%i)| (or use force)\n',sV(1),sV(2),obj.nS*obj.nP,obj.nS*obj.nP);
            end
        end
        
        %% remove missing data in vector/matrix (responses+gradients)
        function VV=removeGRV(obj,V,force)
            %size of the input vector
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if (sV(1)==obj.nS*(obj.nP+1))||force
                Va=obj.removeRV(V(1:obj.nS,:));
                Vb=obj.removeGV(V(obj.nS+1:end,:));
                VV=[Va;Vb];
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input vector\n ++ |%i, expected: %i|\n',sV(1),obj.nS*(obj.nP+1));
            end
        end
        function VV=removeGRM(obj,V,force)
            %size of the input vector
            sV=size(V);
            %deal with no force parameter
            if nargin<3;force=false;end
            if (sV(1)==obj.nS*(obj.nP+1)&&sV(2)==obj.nS*(obj.nP+1))||force
                %split the matrix in four parts
                Va=V(1:obj.nS,1:obj.nS);
                Vb=V(1:obj.nS,obj.nS+1:end);
                Vbt=V(obj.nS+1:end,1:obj.nS);
                Vc=V(obj.nS+1:end,obj.nS+1:end);
                %
                VaR=obj.removeRM(Va);
                VbR=obj.removeRV(obj.removeGV(Vb')');
                VbtR=obj.removeRV(obj.removeGV(Vbt)')';
                VcR=obj.removeGM(Vc);
                %
                VV=[VaR VbR;VbtR VcR];
            else
                VV=V;
                Gfprintf(' ++ Wrong size of the input matrix\n ++ |(%i,%i), expected: (%i,%i)|\n',sV(1),sV(2),obj.nS*(obj.nP+1),obj.nS*(obj.nP+1));
            end
        end
    end
end