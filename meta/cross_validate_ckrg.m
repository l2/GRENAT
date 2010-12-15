%Fonction assurant le calcul des diverses erreurs par validation crois�e
%dans le cas du CoKrigeage
%L. LAURENT -- 14/12/2010 -- laurent@lmt.ens-cachan.fr

function [cv]=cross_validate_ckrg(ckrg,tirages,eval)

%stockage des �valuations du metamod�le au point enleve
cv_z=zeros(ckrg.dim,1);
cv_var=zeros(ckrg.dim,1);
cv_gz=zeros(ckrg.dim,ckrg.con);

%%On parcourt l'ensemble des tirages
for tir=1:ckrg.dim
   %%On construit le m�tamod�le de CoKrigeage avec un site en moins
   %Traitement des matrices et vecteurs en supprimant les lignes et
   %colonnes correspondant 
   
   %positions des element � retirer
   pos=[tir ckrg.dim+(tir:tir+ckrg.con-1)];
   cv_fc=ckrg.fc;
   cv_fc(pos)=[];
   cv_rcc=ckrg.rcc;
   cv_rcc(pos,:)=[];
   cv_rcc(:,pos)=[];
   cv_y=ckrg.y;
   cv_y(pos)=[];
   cv_tirages=tirages;
   cv_tirages(tir,:)=[];
   
   %passage des param�tres
   ckrg_cv=ckrg;
   ckrg_cv.dim=ckrg_cv.dim-1;  %retrait d'un site
   ckrg_cv.rcc=cv_rcc;
   
   %calcul de beta
   cv_ft=cv_fc';
   block1=((cv_ft/cv_rcc)*cv_fc);
   block2=((cv_ft/cv_rcc)*cv_y);
   ckrg_cv.beta=block1\block2;
   
   ckrg_cv.ft=cv_ft;
   
   %creation de la matrice des facteurs de correlation
   ckrg_cv.gamma=cv_rcc\(cv_y-cv_fc*ckrg_cv.beta);
   
   %%Evaluation du m�tamod�le au point supprime de la construction
   [cv_z(tir),cv_gz(tir,:),cv_var(tir)]=eval_ckrg([tirages(tir,1) tirages(tir,2)],cv_tirages,ckrg_cv);
end


%%Calcul des differentes erreurs
%differences entre les evaluations vraies et celle obtenues en retranchant
%le site associe
diff=cv_z-eval;
%Biais moyen
cv.bm=1/ckrg.dim*sum(diff);
%MSE
diffc=diff.^2;
cv.msep=1/ckrg.dim*sum(diffc);
%PRESS
cv.press=sum(diffc);
%crit�re d'adequation
diffa=diff./cv_var;
cv.adequ=1/ckrg.dim*sum(diffa);

