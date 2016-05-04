function [ dLoss,choose,single_loss] = gdtLoss( Wt )
%GDTLOSS Summary of this function goes here
%   Detailed explanation goes here

global C lamda;
global DataX DataY;
global matrix_data_row_num matrix_data_col_num;

single_loss=1- DataY.*(DataX*Wt);
choose = single_loss>0;
gdt = DataX(choose,:)'*DataY(choose) ;
dLoss= Wt-C*sum(gdt,2);


end

