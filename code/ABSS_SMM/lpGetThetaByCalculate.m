function [ weight ] = lpGetThetaByCalculate( Wt,dLoss,M,choose,single_loss)

global C ;
global DataX DataY;
%timerVal = tic;


payOffList=(DataX*M);
loss = payOffList'*choose;
gardient_of_theta=Wt'*M - C*sum(loss);

zeroPointList=[single_loss./payOffList;0];
absPayOffList=[abs(payOffList);0]*C;

[sortedZerosList,index]=sort(zeroPointList);
sortedAbsPayOffList=absPayOffList(index);


zero_index=find(index==length(index));

%disp 'find gardient weight prepare';
%toc(timerVal)


%timerVal = tic;
if(gardient_of_theta<0)
valueBigThanZero=cumsum(sortedAbsPayOffList(zero_index:end))+sortedZerosList(zero_index:end);
i=find(valueBigThanZero>-gardient_of_theta,1,'first');
weight=sortedZerosList(zero_index-1+i);
else
valueSmallThanZero=cumsum(sortedAbsPayOffList(1:zero_index),'reverse')+sortedZerosList(1:zero_index);
i=find(valueSmallThanZero>-gardient_of_theta,1,'first');
weight=sortedZerosList(i);
end
%disp 'find gardient weight';
%toc(timerVal)



% if(gardient_of_theta>0)
%     while(start>1 && accu_diff< gardient_of_theta)
%         start=start-1;
%         accu_diff=accu_diff+sortedAbsPayOffList(start)+sortedZerosList(start+1)-sortedZerosList(start);
%     end
%     if(accu_diff-gardient_of_theta>sortedAbsPayOffList(start))
%         weight = sortedZerosList(start)-(accu_diff-gardient_of_theta-sortedAbsPayOffList(start));
%     else
%         weight = sortedZerosList(start);
%     end
% else
%     while(start<high_bound && accu_diff<-gardient_of_theta)
%         start=start+1;
%         accu_diff=accu_diff+sortedAbsPayOffList(start)+sortedZerosList(start)-sortedZerosList(start-1);
%     end
%     if(accu_diff+gardient_of_theta>sortedAbsPayOffList(start))
%         weight = sortedZerosList(start)-(accu_diff+gardient_of_theta-sortedAbsPayOffList(start));
%     else
%         weight = sortedZerosList(start);
%     end
% end 
% end


