%Fichier d'étude et de mise en oeuvre des démarche de la biblio
%L LAURENT   --  31/01/2010   --  luc.laurent@ens-cachan.fr
clf;clc;close all; clear all;
addpath('doe/lhs');addpath('dace');addpath('doe');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Définition de l'espace de conception
esp.type='auto';   %gestion automatique de l'espace de conception pour fonction étudiée standards
xmin=-2;
xmax=2;
ymin=-1;
ymax=3;
%Fonction utilisée
fct='rosen';    %fonction utilisée (rosenbrock: 'rosen' / peaks: 'peaks')
%pas du tracé
pas=0.1;

%%Métamodèle
%type d'interpolation
%PRG: regression polynomiale
meta.type='KRG';
%degré de linterpolation/regression (si nécessaire)
meta.deg=2;
%paramètre Krigeage
meta.theta=0.5;
meta.regr='regpoly2';
meta.corr='correxp';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%définition du domaine d'étude
switch esp.type
    case 'auto'
        disp('Définition auto du domaine de conception');
        switch fct
            case 'rosen'
                xmin=-2;
                xmax=2;
                ymin=-1;
                ymax=3;
            case 'peaks'
                xmin=-3;
                xmax=3;
                ymin=-3;
                ymax=3;
        end
    case 'manu'
        disp('Définition manu du domaine de conception');
end



%Tracé de la fonction de la fonction étudiée
x=xmin:pas:xmax;
y=ymin:pas:ymax;
[X,Y]=meshgrid(x,y);

switch fct
    case 'rosen'
        Z=rosenbrock(X,Y);
    case 'peaks'
        Z=peaks(X,Y);
end

figure;
surfc(X,Y,Z)

hlight=light;              % activ. éclairage
lighting('gouraud')        % type de rendu
lightangle(hlight,48,70) % dir. éclairage
%shading interp


%% Tirages: plan d'expérience
disp('===== DOE =====');
%nb d'échantillons
nb_samples=10;
%LHS uniform
Xmin=[xmin,ymin];
Xmax=[xmax,ymax];
tirages=factorial_design(nb_samples,nb_samples,xmin,xmax,ymin,ymax);
%tirages=lhsu(Xmin,Xmax,nb_samples);
%évaluations aux points
switch fct
    case 'rosen'
        eval=rosenbrock(tirages(:,1),tirages(:,2));
    case 'peaks'
        eval=peaks(tirages(:,1),tirages(:,2));
end


%% Génération du métamodèle
disp('===== METAMODELE =====');



switch meta.type
    case 'PRG'

[coef,MSE]=meta_prg(tirages,eval,meta.deg);
disp(MSE)
ZRG=polyrg(coef,X,Y,meta.deg);






%%%affichage des surfaces
figure;
hold on
surfc(X,Y,ZRG)
hlight=light;
lighting('gouraud')
lightangle(hlight,48,70) % dir. éclairage
hold on
plot3(tirages(:,1),tirages(:,2),eval,'.','MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',30)
title('Surface obtenue par regression polynomiale');
view(3)

figure;
hold on
surf(X,Y,Z,'FaceColor','white','EdgeColor','blue')
hold on
surf(X,Y,ZRG,'FaceColor','white','EdgeColor','red')
hlight=light;
lighting('gouraud')
lightangle(hlight,48,70) % dir. éclairage
view(3)


figure;
for ii=2
    meta.deg=ii;

[coef,MSE]=meta_prg(tirages,eval,meta.deg);
disp(MSE)
ZRG=polyrg(coef,X,Y,meta.deg);

hold on
surf(X,Y,ZRG)
%colormap hsv
end
%hlight=light;
%lighting('gouraud')
%lightangle(hlight,48,70) % dir. éclairage
%hold on
%plot3(tirages(:,1),tirages(:,2),eval,'.','MarkerEdgeColor','g',...
%                'MarkerFaceColor','g',...
%                'MarkerSize',30)
%title('Surface obtenue par regression polynomiale');
xlabel('x_{1}')
ylabel('x_{2}')
zlabel('F')

view(3)

figure;
for ii=4
    meta.deg=ii;

[coef,MSE]=meta_prg(tirages,eval,meta.deg);
disp(MSE)
ZRG=polyrg(coef,X,Y,meta.deg);

hold on
surf(X,Y,ZRG)
%colormap hsv
end
%hlight=light;
%lighting('gouraud')
%lightangle(hlight,48,70) % dir. éclairage
%hold on
%plot3(tirages(:,1),tirages(:,2),eval,'.','MarkerEdgeColor','g',...
%                'MarkerFaceColor','g',...
%                'MarkerSize',30)
%title('Surface obtenue par regression polynomiale');
xlabel('x_{1}')
ylabel('x_{2}')
zlabel('F')
view(3)

    case 'KRG' %utilisation de la Toolbox DACE
        [model,perf]=dacefit(tirages,eval,meta.regr,meta.corr,meta.theta);
        Zk=zeros(size(X));
        for ii=1:size(X,1)
            for jj=1:size(X,2)
                ZK(ii,jj)=predictor([X(ii,jj) Y(ii,jj)],model);
            end
        end
            %%%affichage des surfaces
        figure;
        hold on
        mesh(x,y,ZK)
        hlight=light;
        lighting('gouraud')
        lightangle(hlight,48,70) % dir. éclairage
        hold on
        plot3(tirages(:,1),tirages(:,2),eval,'.','MarkerEdgeColor','g',...
                        'MarkerFaceColor','g',...
                        'MarkerSize',30)
        title('Surface obtenue par regression polynomiale');
        view(3)

        figure;
        hold on
        surf(X,Y,Z,'FaceColor','white','EdgeColor','blue')
        hold on
        surf(X,Y,ZK,'FaceColor','white','EdgeColor','red')
        hlight=light;
        lighting('gouraud')
        lightangle(hlight,48,70) % dir. éclairage
        view(3)
        
        figure;
        surf(X,Y,ZK)
        xlabel('x_{1}')
ylabel('x_{2}')
zlabel('F')
view(3)
end
        

   