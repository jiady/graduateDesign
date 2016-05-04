function [ Wt,obj_history ,time] = LocalPursuit( iteration ,Wt, Ut,Vt,obj_history,time)
%LOCALPURSUIT Summary of this function goes here
%   Detailed explanation goes here
global matrix_data_row_num matrix_data_col_num;
[~,n]=size(Ut);
U0=zeros(matrix_data_row_num,iteration);
V0=zeros(matrix_data_col_num,iteration);
o0=zeros(1,iteration);
obj_history=[obj_history o0];
time =[time o0];
Ut=[Ut U0];
Vt=[Vt V0];
M_col=zeros(matrix_data_row_num*matrix_data_col_num,iteration);
%mid=[];

for t= n+1:n+iteration
    time(t)=toc;
    %timerVal = tic;
    obj_history(t)=objective_value_sing(Wt);
    %disp 'obj eval ';
    %toc(timerVal)
    
    %timerVal = tic;
    [dLoss,choose,single_loss] = gdtLoss(Wt);
    %disp 'gdt ';
    %toc(timerVal)
    
    %timerVal = tic;
    dLoss=reshape(dLoss,matrix_data_row_num,matrix_data_col_num);
    [u,~,v]= topsvd(-dLoss,20);
    Ut(:,t) = u(:,1);
    Vt(:,t) = v(:,1);
    M=u(:,1)*v(:,1)';
    M=M(:);
    %disp 'top svd';
    %toc(timerVal)
    
    %[weight]=lpGetTheta(Wt,dLoss,M,choose);
    %timerVal = tic;
    [weight]=lpGetThetaByCalculate(Wt,dLoss,M,choose,single_loss);
    Wt= Wt+ weight .* M;
    %disp 'weight calculation';
    %toc(timerVal)
    
    %M_col(:,t-n)=M;
    %for q=t:-1:n+1
    %    [weight]=lpGetThetaByCalculate(Wt,dLoss,M_col(:,q-n),choose,single_loss);
    %    Wt= Wt+ weight .* M;
    %    [dLoss,choose,single_loss] = gdtLoss(Wt);
    %end

    %mid =[ mid objective_value(Wt)];
end



end

