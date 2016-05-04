function [ weight ] = lpGetThetaByCalculate( Wt,dLoss,M,choose,single_loss)

global C ;
global DataX DataY;

loss = DataY(choose).*(DataX(choose,:)*M);
gardient_of_theta = Wt'*M - C*sum(loss);

payOffList=(DataY.*(DataX*M));
zeroPointList=[single_loss./payOffList;0];
absPayOffList=[abs(payOffList);0]*C;



[sortedZerosList,index]=sort(zeroPointList);
sortedAbsPayOffList=absPayOffList(index);
step=0;
accu_diff=0;

zero_index=find(index==length(index));
high_bound=length(sortedAbsPayOffList);
start = zero_index;

if(gardient_of_theta<0)
valueBigThanZero=cumsum(sortedAbsPayOffList(zero_index:end))+sortedZerosList(zero_index:end)
else
valueSmallThanZero=cumsum(sortedAbsPayOffList(1:zero_index),'reverse')+sortedZerosList(1:zero_index)
end



if(gardient_of_theta>0)
    while(start>1 && accu_diff< gardient_of_theta)
        start=start-1;
        accu_diff=accu_diff+sortedAbsPayOffList(start)+sortedZerosList(start+1)-sortedZerosList(start);
    end
    if(accu_diff-gardient_of_theta>sortedAbsPayOffList(start))
        weight = sortedZerosList(start)-(accu_diff-gardient_of_theta-sortedAbsPayOffList(start));
    else
        weight = sortedZerosList(start);
    end
else
    while(start<high_bound && accu_diff<-gardient_of_theta)
        start=start+1;
        accu_diff=accu_diff+sortedAbsPayOffList(start)+sortedZerosList(start)-sortedZerosList(start-1);
    end
    if(accu_diff+gardient_of_theta>sortedAbsPayOffList(start))
        weight = sortedZerosList(start)-(accu_diff+gardient_of_theta-sortedAbsPayOffList(start));
    else
        weight = sortedZerosList(start);
    end
end 
end


