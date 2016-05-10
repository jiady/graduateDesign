function [ Wt ] = GlobalPurne( iteration ,Wt, Ut,Vt)
kk=iteration
% Summary of this function goes here
%   Detailed explanation goes here
global matrix_data_row_num matrix_data_col_num;
M_col=zeros(matrix_data_row_num*matrix_data_col_num,kk);


o0=zeros(1,iteration);
obj_history=[o0];
time =[o0];
timeVal=tic;
[dLoss,choose,single_loss] = gdtLoss(Wt);
U0=zeros(matrix_data_row_num,1);
V0=zeros(matrix_data_col_num,1);
dLoss=reshape(dLoss,matrix_data_row_num,matrix_data_col_num);
[u,s,v] =randomsvd(-dLoss, U0, V0, matrix_data_row_num, matrix_data_col_num, kk, zeros(0,0), 3);  
sing_vals=diag(s);  
mu=10000;
tmp=max(sing_vals-mu,0);
Ug = u(:,tmp>0); 
Vg = v(:,tmp>0); 
Ua = qr([Ug ]);
Va = qr([Vg ]);

for i =1:kk
   M=Ua(:,i)*Va(:,i)';
   M_col(:,i)=M(:);
end
disp 'global purne gen basis'
toc


tic
for q=1:kk
         [dLoss,choose,single_loss] = gdtLoss(Wt);
         [weight]=lpGetThetaByCalculate(Wt,dLoss,M_col(:,q),choose,single_loss);
         Wt= Wt+ weight .* M_col(:,q);
         obj_history(q)=objective_value_sing(Wt);
         time(q)=toc;
end

end