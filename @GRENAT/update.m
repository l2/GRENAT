%% Method of GRENAT class
% L. LAURENT -- 26/06/2016 -- luc.laurent@lecnam.net

%     GRENAT - GRadient ENhanced Approximation Toolbox
%     A toolbox for generating and exploiting gradient-enhanced surrogate models
%     Copyright (C) 2016-2017  Luc LAURENT <luc.laurent@lecnam.net>
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

%% Update the metamodel by adding sample points and associated
% responses and gradients
% INPUTS:
% - samplingIn: new sample points
% - respIn: new responses
% - gradIn: new gradients
% - paraFind: flag for actiavting or not the estimation of the
% hyperparameters
% - varargin: update some properties or the metamodel configuration
% OUTPUTS:
% - none


function update(obj,samplingIn,respIn,gradIn,paraFind,varargin)
%add data
if ~isempty(samplingIn)
    obj.sampling=samplingIn;
    obj.resp=respIn;
    obj.grad=gradIn;
    %initialize flags
    initRunTrain(obj,true);
    initRunEval(obj,true);
    %change status of the estimation of the parameters
    if nargin>4;
        obj.confMeta.conf('estimOn',paraFind);
    end
    %deal with additional options
    if nargin>5;
        obj.confMeta.conf(varargin{:});
    end
    %update options
    obj.dataTrain.manageOpt(obj.confMeta);
    %train the metamodel
    obj.dataTrain.update(samplingIn,respIn,gradIn);
end
end
