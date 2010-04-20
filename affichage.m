%%fonction réalisant l'affichage des surfaces de réponse
%%L. LAURENT   --  22/03/2010   --  luc.laurent@ens-cachan.fr


function status=affichage(X,Y,Z,tirages,eval,aff)

global cofast resultats;

if aff.on
    if aff.newfig
        figure;
    else
        hold on
    end

    if aff.d3
        if aff.contour3
            if aff.uni          
                surfc(X,Y,Z.Z,'FaceColor',aff.color,'EdgeColor',aff.color)
            else
                surfc(X,Y,Z.Z)
            end
        else
            if aff.uni          
                surf(X,Y,Z.Z,'FaceColor',aff.color,'EdgeColor',aff.color)
            else
                surf(X,Y,Z.Z)
            end
        end
        if aff.pts
        hold on
        plot3(tirages(:,1),tirages(:,2),eval,'.','MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',15)
     
    end
    end
    
    if aff.d2
        if aff.contour2
           [C,h]=contourf(X,Y,Z.Z);       
           set(h,'LineWidth',2)
           if aff.grad
                hold on;
                quiver(X,Y,Z.GR1,Z.GR2);
           end
            if aff.pts
                hold on
                plot(tirages(:,1),tirages(:,2),'.','MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',15)     
            end
            if cofast.grad
                hold on;
                quiver(tirages(:,1),tirages(:,2),resultats.grad.gradients(:,1),resultats.grad.gradients(:,2),'LineWidth',2);
            end
           
           text_handle = clabel(C,h);
            set(text_handle,'BackgroundColor',[1 1 .6],...
            'Edgecolor',[.7 .7 .7])
        end
    end

    if aff.rendu
        hlight=light;              % activ. éclairage
        lighting('gouraud')        % type de rendu
        lightangle(hlight,48,70) % dir. éclairage
    end

    
    title(aff.titre);
    xlabel(aff.xlabel);
    ylabel(aff.ylabel);
    if aff.d3
        zlabel(aff.zlabel);    
        view(3)
    end
    
    
end
end
