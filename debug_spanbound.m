% Example of use of GRENAT without the sampling toolbox
% L. LAURENT -- 16/05/2016 -- luc.laurent@lecnam.net

initDirGRENAT();
%customClean;

%display the date
dispDate;

%initialization of display variables
dispData=initDisp();

fprintf('++++++++++++++++++++++++++++++++++++++++++\n')
fprintf('  >>>   Building surrogate model    <<<\n');
[tMesu,tInit]=mesuTime;

%parallel execution (options and starting of the workers)
parallel.on=false;
parallel.workers='auto';
execParallel('start',parallel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Load of a set of 2D data

%sampling points
sampling=[-1 0.3 4 4.5 5 7.5 7.6 10 12.5 14]';
sampling=linspace(-2,15,20)';
nns=6;


sampling=linspace(0,15,nns)';
%responses and gradients at sample points
[resp,grad]=funManu(sampling);


%%for displaying and comparing with the actual function
%regular grid
gridRef=linspace(-2,15,300)';
%responses at the grid points
[respRef,gradRef]=funManu(gridRef);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load surrogate model parameters
metaData=initMeta;
metaData.type='GSVR';
metaData.kern='matern32';
metaData.cv.disp=true;
metaData.para.estim=false;
metaData.para.nu.val=3;
metaData.para.l.val=1/0.8;
metaData.para.dispPlotAlgo=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%building of the surrogate model
paraV=logspace(-2,4,100);
for ii=1:numel(paraV)
    metaData.para.l.val=1/paraV(ii);
    [approx]=BuildMeta(sampling,resp,grad,metaData);
    sp(ii)=approx.build.spanBound;
end
sp
figure;plot(paraV,sp)
figure;loglog(paraV,sp)
stop

%evaluation of the surrogate model at the grid points
[K]=EvalMeta(gridRef,approx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%computation of the confidence intervals
if isfield(K,'var');[ci68,ci95,ci99]=BuildCI(K.Z,K.var);end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display
% default values
dispData.on=true;
dispData.newFig=false;
dispData.ci.on=true; % display confidence intervals
dispData.render=false;
dispData.d3=true;
dispData.samplePts=true;
dispData.xlabel='x_1';
dispData.ylabel='x_2';

figure
subplot(2,3,1)
dispData.title='Reference function';
displaySurrogate(gridRef,respRef,sampling,resp,grad,dispData);
subplot(2,3,2)
dispData.title='Approximate function';
displaySurrogate(gridRef,K.Z,sampling,resp,grad,dispData);
subplot(2,3,4)
dispData.title='';
dispData.render=false;
dispData.d3=false;
dispData.d2=true;
dispData.contour=true;
dispData.gridGrad=true;
ref.Z=respRef;
ref.GZ=gradRef;
displaySurrogate(gridRef,ref,sampling,resp,grad,dispData);
subplot(2,3,5)
displaySurrogate(gridRef,K,sampling,resp,grad,dispData);
subplot(2,3,3)
dispData.d3=true;
dispData.d2=false;
dispData.contour=false;
dispData.gridGrad=false;
dispData.render=false;
dispData.title='Variance';
dispData.samplePts=false;
displaySurrogate(gridRef,K.var,sampling,resp,grad,dispData);
subplot(2,3,6)
dispData.title='95% confidence interval';
dispData.trans=true;
dispData.uni=true;
displaySurrogateCI(gridRef,ci95,dispData,K.Z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Computation and display of the errors
err=critErrDisp(K.Z,respRef,approx.build);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Stop workers
execParallel('stop',parallel);

mesuTime(tMesu,tInit);
