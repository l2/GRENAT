%% Calcul critere EI/WEI/LCB
%% L. LAURENt -- 04/05/2012 -- laurent@lmt.ens-cachan.fr

function [EI,WEI,GEI,LCB,exploit_EI,explor_EI]=crit_enrich(eval_min,Z,variance,enrich)

%reponse mini
diff_ei=(eval_min-Z);
if variance~=0
    u=diff_ei/variance;
end
%pour calcul Expected Improvement (Schonlau 1997/Jones 1999/Bompard
%2011/Sobester 2005...)
%exploration (densite probabilite)
if variance~=0
    densprob=1/sqrt(2*pi)*exp(-0.5*u^2); %normpdf
    explor_EI=variance*densprob;
else
    explor_EI=0;
end

%exploitation (fonction repartition loi normale centree reduite)
if variance~=0
    fctrep=0.5*(1+erf(u/sqrt(2))); %cdf
    exploit_EI=diff_ei*fctrep;
else
    exploit_EI=0;
end
%critere Weigthed Expected Improvement (Sobester 2005)
WEI=enrich.para_wei*exploit_EI+(1-enrich.para_wei)*explor_EI;
%critere Expected Improvement (Schonlau 1997)
EI=exploit_EI+explor_EI;
%critere Lower Confidence Bound (Cox et John 1997)
LCB=Z-enrich.para_lcb*variance;
%critere Generalized Expected Improvement (Schonlau 1997)
g=max(enrich.para_gei);
t=zeros(1,g);
GEI=zeros(1,g+1);
if variance~=0
    if g>=0
        t(1)=densprob;
    end
    if g>=1 
        t(2)=-fctrep;
    end
    if g>=2
        for kk=3:g+1
            t(kk)=u^(kk-1)*t(1)+(kk-1)*t(kk-2);
        end
    end
    %calcul des differents termes du calcul de GEI
    for cg=0:g
        k_ite=0:cg;
        coef=(-1).^k_ite;
        varg=variance^cg;
        comb=factorial(cg)./(factorial(k_ite).*factorial(cg-k_ite)); %plus rapide que nchoosek (10 fois plus rapide)
        ueg=u.^(k_ite);
        %calcul de la valeur du critere GEI
        GEI(cg+1)=varg*sum(coef.*comb.*ueg.*t([1:cg+1]));        
    end    
end
