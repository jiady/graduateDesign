function [ dLoss,choose,single_loss] = gdtLoss( Wt )
%GDTLOSS Summary of this function goes here
%   Detailed explanation goes here

global C lamda;
global DataX DataY;
global matrix_data_row_num matrix_data_col_num;

%timerVal = tic;
single_loss=1-(DataX*Wt);
%disp 'single loss ';
%toc(timerVal)
    
%timerVal = tic;   
choose = single_loss>0;
%disp 'single loss>0 ';
%toc(timerVal)

%timerVal = tic; 
%gdt = DataX(choose,:)'*DataY(choose) ;
gdt = (DataX)'*choose;
%disp 'choose select ';
%toc(timerVal)

dLoss= Wt-C*gdt;


end

