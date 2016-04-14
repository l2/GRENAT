%%fonction realisant l'affichage des surfaces de reponse
%%L. LAURENT   --  22/03/2010   --  luc.laurent@ens-cachan.fr


function fig_handle=affichage(grille,Z,tirages,eval,grad,aff)

%% Parametres d'entree:
%       - grille: grille de trace (meshgrid en 2D) sous la forme
%       grille(:,:,1) et grille(:,:,2) en 2D pour respectivement les
%       abscisse et ordonnee. En 1D il s'agit juste d'un vecteur de reels
%       obtenu par exemple avec linspace
%       - Z: structure des donnees a� tracer
%           * vZ: cotes obtenus au points definis par la grille
%           * GR1 et GR2: composant des gradients calcules aux points
%           definis par la gille
%       - tirages: liste des points tires (par strategie quelconque)
%       - eval: evaluations/cotes obtenus aux points du tirage
%       - grad: gradients obtenus aux points de tirage
%       - aff: structure contenant l'ensemble des options gere par la
%       fonction
%           * aff.on: affichage actif ou non (booleen)
%           * aff.newfig: affichage du trace dans une nouvelle figure
%           (booleen)
%           * aff.grad_meta: affichage des gradients calcules aux points de
%           la grille (issus generalement du metamodele)
%           * aff.grad_eval: affichage des gradients calcules aux points du
%           tirages
%           * aff.d3: affichage graphique 3D (surf quiver3...)
%           * aff.d2: affichage graphique 2D (plot quiver...)
%           * aff.contour: affichage des courbes de niveaux
%           * aff.pts: affichage des points d'evaluation
%           * aff.uni: affichage des surfaces en une couleurs (booleen)
%           * aff.color: couleur choisie
%           * aff.rendu: rendu sur graphique 3D
%           * aff.save: sauvegarde figures en eps et png
%           * aff.tikz: sauvegarde au format Tikz
%           * aff.tex: ecriture du fichier TeX associe
%           * aff.opt: option courbes en 1D
%           * aff.titre: titre figure
%           * aff.xlabel: nom axe x
%           * aff.ylabel: nom axe y
%           * aff.zlabel: nom axe z
%           * aff.scale: mise a l'echelle gradients
%           * aff.doss: dossier de sauvegarde figures
%           * aff.pas: pas de la grille d'affichage
%           * aff.bilan_manq: dfinition donnees manquantes pour trace
%           ajuste
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%chargement des options par d�faut
aff_def=init_aff;
%on traite les options manquantes (en les ajoutant)
f_def=fieldnames(aff_def);
f_dispo=fieldnames(aff);
f_manq=setxor(f_def,f_dispo);
%on ajoute les valeurs par d�faut manquantes
if ~isempty(f_manq)
    fprintf('Qques options affichage manquantes (ajout)\n');
    for ii=1:numel(f_manq)
        fprintf('%s ',f_manq{ii});
        aff.(f_manq{ii})=aff_def.(f_manq{ii});
    end
    fprintf('\n')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fig_handle=[];

%traitement des cas 1D ou 2D
esp1d=false;esp2d=false;
if size(tirages,2)==1
    esp1d=true;
elseif size(tirages,2)==2
    esp2d=true;
    if size(grille,3)>1
        grille_X=grille(:,:,1);
        grille_Y=grille(:,:,2);
    else
        grille_X=grille(:,1);
        grille_Y=grille(:,2);
    end
else
    
    aff.bar=true;
end
%Mise en forme grandeur a afficher
if isa(Z,'struct')
    vZ=Z.Z;
else
    vZ=Z;
end

%mise en forme des gradients
if isfield(Z,'GZ')&&esp2d
    GR1=Z.GZ(:,:,1);
    GR2=Z.GZ(:,:,2);
end

if ~isfield(Z,'GZ');aff.grad_eval=false;end

%gradients aux points disponibles
grad_dispo=~isempty(grad);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recherche et tri des manques d'information
liste_pts_ok=1:size(tirages,1);
liste_eval_manq=[];
liste_grad_manq=[];
liste_both_manq=[];
if isfield(aff,'bilan_manq')
    if aff.bilan_manq.eval.on
        liste_eval_manq=unique(aff.bilan_manq.eval.ix_manq(:));
        for ii=1:numel(liste_eval_manq)
            ix= liste_pts_ok==liste_eval_manq(ii);
            liste_pts_ok(ix)=[];
        end
    end
    if aff.bilan_manq.grad.on
        liste_grad_manq=unique(aff.bilan_manq.grad.ix_manq(:,1));
        for ii=1:numel(liste_grad_manq)
            ix= liste_pts_ok==liste_grad_manq(ii);
            liste_pts_ok(ix)=[];
        end
    end
    if aff.bilan_manq.eval.on|| aff.bilan_manq.grad.on
        liste_both_manq=intersect(liste_eval_manq,liste_grad_manq);
        for ii=1:numel(liste_both_manq)
            ix= liste_eval_manq==liste_both_manq(ii);
            liste_eval_manq(ix)=[];
            ix= liste_grad_manq==liste_both_manq(ii);
            liste_grad_manq(ix)=[];
        end
    end
end

%Affichage actif
if aff.on
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %affichage dans une nouvelle fenetre
    if aff.newfig
        fig_handle=figure;
    else
        hold on
    end
    
    %affichage 2D
    if esp2d
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%mise a l'echelle des traces de gradients
        if aff.grad_meta||aff.grad_eval
            %calcul norme gradient
            ngr=zeros(size(GR1));
            for ii=1:size(GR1,1)*size(GR1,2)
                ngr(ii)=norm([GR1(ii) GR2(ii)],2);
            end
            %recherche du maxi de la norme du gradient
            nm=max(max(ngr));
            
            n1=max(max(abs(GR1)));
            n2=max(max(abs(GR2)));
            
            %definition de la taille mini de la grille d'affichage
            gx=grille_X-grille_X(1);
            ind= gx>0;
            tailg(1)=min(min(gx(ind)));
            gy=grille_Y-grille_Y(1);
            ind= gy>0;
            tailg(2)=min(min(gy(ind)));
            
            
            %taille de la plus grande fleche
            para_fl=0.9;
            tailf=para_fl*tailg;
            
            
            %echelle
            % nm
            %  tailf
            ech=tailf./[n1 n2];
            
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %affichage des surfaces 3D
        if aff.d3
            %affichage des contour
            if aff.contour
                %affichage unicolor
                surfc(grille_X,grille_Y,vZ);
                if aff.uni
                    set(h,'FaceColor',aff.color,'EdgeColor',aff.color);
                end
            else
                h=surf(grille_X,grille_Y,vZ);
                if aff.uni                    
                    set(h,'FaceColor',aff.color,'EdgeColor',aff.color);
                end
            end
            
            if aff.pts
                hold on
                
                %affichage des points d'evaluations
                %affichage points ou toutes les infos sont connues
                plot3(tirages(liste_pts_ok,1),tirages(liste_pts_ok,2),eval(liste_pts_ok),...
                    '.','MarkerEdgeColor','k',...
                    'MarkerFaceColor','k',...
                    'MarkerSize',15);
                %affichage points il manque une/des reponse(s)
                plot3(tirages(liste_eval_manq,1),tirages(liste_eval_manq,2),eval(liste_eval_manq),...
                    'rs','MarkerEdgeColor','r',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',7);
                %affichage points il manque un/des gradient(s)
                plot3(tirages(liste_grad_manq,1),tirages(liste_grad_manq,2),eval(liste_grad_manq),...
                    'v','MarkerEdgeColor','g',...
                    'MarkerFaceColor','g',...
                    'MarkerSize',15);
                %affichage points il manque un/des gradient(s) et un/des
                %reponse(s) au m�me point
                plot3(tirages(liste_both_manq,1),tirages(liste_both_manq,2),eval(liste_both_manq),...
                    'd','MarkerEdgeColor','r',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',15);
            end
            
            %Affichage des gradients
            if aff.grad_eval
                %determination des vecteurs de plus grandes pentes (dans le
                %sens de descente du gradient)
                for ii=1:size(GR1,1)*size(GR1,2)
                    vec.X(ii)=-GR1(ii);
                    vec.Y(ii)=-GR2(ii);
                    vec.Z(ii)=-GR1(ii)^2-GR2(ii)^2;
                    %normalisation du vecteur de plus grande pente
                    vec.N(ii)=sqrt(vec.X(ii)^2+vec.Y(ii)^2+vec.Z(ii)^2);
                    vec.Xn(ii)=vec.X(ii)/vec.N(ii);
                    vec.Yn(ii)=vec.Y(ii)/vec.N(ii);
                    vec.Zn(ii)=vec.Z(ii)/vec.N(ii);
                end
                hold on
                
                %hcones =coneplot(X,Y,vZ,vec.X,vec.Y,vec.Z,0.1,'nointerp');
                % hcones=coneplot(X,Y,vZ,GR1,GR2,-ones(size(GR1)),0.1,'nointerp');
                % set(hcones,'FaceColor','red','EdgeColor','none')
                
                %hold on
                %dimension maximale espace de conception
                dimm=max(abs(max(max(grille_X))-min(min(grille_X))),...
                    abs(max(max(grille_Y))-min(min(grille_Y))));
                %dimension espace de reponse
                dimr=abs(max(max(vZ))-min(min(vZ)));
                %norme maxi du gradient
                nmax=max(max(vec.N));
                quiver3(grille_X,grille_Y,vZ,ech*vec.X,ech*vec.Y,ech*vec.Z,...
                    'b','MaxHeadSize',0.1*dimr/nmax,'AutoScale','off')
            end
            %axis([min(grille_X(:)) max(grille_X(:)) min(grille_Y(:)) max(grille_Y(:)) min(vZ(:)) max(vZ(:))])
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %affichage des surfaces 2D (contours)
        if aff.d2
            %affichage des contours
            if aff.contour
                [C,h]=contourf(grille_X,grille_Y,vZ);
                text_handle = clabel(C,h);
                set(text_handle,'BackgroundColor',[1 1 .6],...
                    'Edgecolor',[.7 .7 .7]);
                set(h,'LineWidth',2);
                %affichage des gradients
                if aff.grad_meta
                    hold on;
                    %remise a� l'echelle
                    if aff.scale
                        %quiver(grille_X,grille_Y,ech(1)*GR1,ech(2)*GR2,'AutoScale','off','MaxHeadSize',0.0002);
                        quiver(grille_X,grille_Y,ech(1)*GR1,ech(2)*GR2,'Color','b','AutoScale','off','MaxHeadSize',0);
                        %axis equal
                        %ncquiverref(grille_X,grille_Y,ech(1)*GR1,ech(2)*GR2);
                        %ech(1)*GR1
                        %ech(2)*GR2
                    else
                        quiver(grille_X,grille_Y,GR1,GR2,'Color','b','AutoScale','off');
                    end
                end
                %affichage des points d'evaluation
                if aff.pts
                    hold on
                    %affichage points ou toutes les infos sont connues
                    plot(tirages(liste_pts_ok,1),tirages(liste_pts_ok,2),...
                        'o','LineWidth',2,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','g',...
                        'MarkerSize',15);
                    %affichage points il manque une/des reponse(s)
                    plot(tirages(liste_eval_manq,1),tirages(liste_eval_manq,2),...
                        'rs','LineWidth',2,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','r',...
                        'MarkerSize',7);
                    %affichage points il manque un/des gradient(s)
                    plot(tirages(liste_grad_manq,1),tirages(liste_grad_manq,2),...
                        'v','LineWidth',2,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','r',...
                        'MarkerSize',15);
                    %affichage points il manque un/des gradient(s) et un/des
                    %reponse(s) au m�me point
                    plot(tirages(liste_both_manq,1),tirages(liste_both_manq,2),...
                        'd','LineWidth',2,'MarkerEdgeColor','k',...
                        'MarkerFaceColor','r',...
                        'MarkerSize',15);
                    
                end
                %affichage des gradients
                if aff.grad_eval&&grad_dispo
                    hold on;
                    %remise a� l'echelle
                    if aff.scale
                        quiver(tirages(:,1),tirages(:,2),...
                            ech(1)*grad(:,1),ech(2)*grad(:,2),...
                            'Color','g','LineWidth',2,'AutoScale','off','MaxHeadSize',0);
                        
                    else
                        quiver(tirages(:,1),tirages(:,2),...
                            grad(:,1),grad(:,2),...
                            'Color','g','LineWidth',2,'AutoScale','off');
                    end
                    
                end
                
                
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %rendu
        if aff.rendu
            hlight=light;               % activ. eclairage
            lighting('gouraud')         % type de rendu
            lightangle(hlight,48,70)    % dir. eclairage
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % affichage label
        title(aff.titre);
        xlabel(aff.xlabel);
        ylabel(aff.ylabel);
        if aff.d3
            zlabel(aff.zlabel);
            view(3)
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %affichage 1D
    elseif esp1d
        if aff.grad_meta&&isfield(Z,'GZ')
            if ~isempty(aff.color)
                if ~isempty(aff.opt)
                    plot(grille,Z.GZ,aff.opt,'Color',aff.color);
                else
                    plot(grille,Z.GZ,'Color',aff.color);
                end
            else
                if ~isempty(aff.opt)
                    plot(grille,Z.GZ,aff.opt);
                else
                    plot(grille,Z.GZ);
                end
            end
        else
            if ~isempty(aff.color)
                if ~isempty(aff.opt)
                    plot(grille,vZ,aff.opt,'Color',aff.color);
                else
                    plot(grille,vZ,'Color',aff.color);
                end
            else
                if ~isempty(aff.opt)
                    plot(grille,vZ,aff.opt);
                else
                    plot(grille,vZ);
                end
            end
        end
        %affichage des points d'evaluation
        if aff.pts
            hold on
            if aff.grad_eval;val_trac=grad;else val_trac=eval;end
            %affichage points ou toutes les infos sont connues
            plot(tirages(liste_pts_ok),val_trac(liste_pts_ok),...
                '.','MarkerEdgeColor','k',...
                'MarkerFaceColor','k',...
                'MarkerSize',15);
            %affichage points il manque une/des reponse(s)
            plot(tirages(liste_eval_manq),val_trac(liste_eval_manq),...
                'rs','MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',7);
            %affichage points il manque un/des gradient(s)
            plot(tirages(liste_grad_manq),val_trac(liste_grad_manq),...
                'v','MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',7);
            %affichage points il manque un/des gradient(s) et un/des
            %reponse(s) au m�me point
            plot(tirages(liste_both_manq),val_trac(liste_both_manq),...
                'd','MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',7);
        end
        title(aff.titre);
        xlabel(aff.xlabel);
        ylabel(aff.ylabel);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %sauvegarde traces figure
    if aff.save
        global num
        if isempty(num); num=1; else num=num+1; end
        fich=save_aff(num,aff.doss);
        if aff.tex
            fid=fopen([aff.doss '/fig.tex'],'a+');
            fprintf(fid,'\\figcen{%2.1f}{../%s}{%s}{%s}\n',0.7,fich,aff.titre,fich);
            %fprintf(fid,'\\verb{%s}\n',fich);
            fclose(fid);
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Trace r�ponse nD
    if aff.bar
        Zs=vZ(:);
        nb_eval=numel(Zs);
        if ~isempty(aff.color)
            plot(1:nb_eval,Zs,'o','MarkerEdgeColor',aff.color,'MarkerFaceColor',aff.color,'Markersize',5);
            %line([1:nb_eval;1:nb_eval],[zeros(1,nb_eval);Zs'],'LineWidth',1,'Color',aff.color,'lineStyle','--')
        else
            plot(1:nb_eval,Zs,'o','MarkerEdgeColor','k','MarkerFaceColor','k','Markersize',5);
            %line([1:nb_eval;1:nb_eval],[zeros(1,nb_eval);Zs'],'LineWidth',1,'Color',[0. 0. .8],'lineStyle','--')
        end
        title(aff.titre);
        xlabel(aff.xlabel);
        ylabel(aff.ylabel);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %exportation tikz
    if aff.tikz
        nomfig=[aff.doss '/fig_' num2str(aff.num,'%04.0f') '.tex'];
        matlab2tikz(nomfig);
    end
    
    
    hold off
end
