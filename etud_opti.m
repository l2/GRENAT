%Fichier d'étude et de mise en oeuvre des démarche de la biblio
%L LAURENT   --  31/01/2010   --  luc.laurent@ens-cachan.fr
clf;clc;close all; clear all;
addpath('doe/lhs');

%%Définition de l'espace de conception
xmin=-2;
xmax=2;
ymin=-1;
ymax=3;


%Tracé de la fonction de la fonction étudiée
pas=0.1;
x=xmin:pas:xmax;
y=ymin:pas:ymax;
[X,Y]=meshgrid(x,y);
Z=rosenbrock(X,Y);
figure;
surfc(X,Y,Z)
shading interp

%% Tirages: plan d'expérience
disp('===== DOE =====');
%nb d'échantillons
nb_samples=25;
%LHS uniform
xmin=[xmin,ymin];
xmax=[xmax,ymax];
tirages=lhsu(xmin,xmax,nb_samples);

%% Génération du métamodèle
disp('===== METAMODELE =====');
%type d'interpolation
%PRG: regression polynomiale

meta.type='PRG';
