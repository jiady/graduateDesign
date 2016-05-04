function [ weight ] = lpGetTheta( Wt,dLoss,M,choose )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global C lamda;
global DataX DataY;
global stepcoef;

loss = DataY(choose).*(DataX(choose,:)*M);
losspart = -M'*Wt + C*sum(loss);

step = losspart * stepcoef;

level=0;
laststep=0;
while(1)
    yi=calLossSign(Wt,M,step);
    if(yi)
        weight =laststep + innerSearch(Wt+laststep*M,M,step/4,level);
        return;
    else
        laststep=step;
        level=level+1;
        step=step*2;
    end
end

end


function theta = innerSearch(Wt,M, step , level)
    if(level==0)
        theta=0;
        return;
    end
    level=level-1;
    y=calLossSign(Wt,M,step);
    if(y)
        theta = innerSearch(Wt,M,step/2, level);
    else
        theta = innerSearch(Wt + M*step,M,step/2,level) + step;
    end
end


function yi = calLossSign(Wt,M,step)
    global DataX DataY C;
    W=Wt + M*step;
    ch =1- DataY.*(DataX*W) >0;
    lossp = -M'*W + C*DataY(ch)'*DataX(ch,:)*M;
    yi = xor ((lossp > 0),(step > 0));
end


