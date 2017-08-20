%% Method of execParallel class
% L. LAURENT -- 01/10/2012 -- luc.laurent@lecnam.net

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


%% Build a correlation (kernel) vector depending on the distance between existing sample points and specific points
% INPUTS:
% - samplePts: sample points on which the vector will be calculated
% - paraV: values of the hyperparameters used for kernel computation
% (optional)
% OUTPUTS:
% - V,Vd,Vdd: kernel vectors (V: responses, Vd: gradients and Vdd:
% hessians)                

%% Stop parallel workers
        function stop(obj)
            %load current cluster
            currentConf(obj);
            %close it if available
            if obj.currentParallel.NumWorkers>0
                Gfprintf(' >>> Stop parallel workers <<<\n');
                delete(gcp('nocreate'));
            else
                Gfprintf(' >>> Workers already stopped\n');
            end
        end