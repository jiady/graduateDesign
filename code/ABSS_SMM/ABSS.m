function [ Wt, obj_history,time ] = ABSS()
%   ABSS Summary of this function goes here
%   Detailed explanation goes here
global matrix_data_row_num matrix_data_col_num;
tic;
time =[];

Wt=zeros(matrix_data_row_num*matrix_data_col_num,1);
Ut=[];Vt=[];
obj_history=[];
% init Wt

[Wt,obj_history,time] = LocalPursuit(50,Wt,Ut,Vt,obj_history,time);

scheme_num=0;
main_basis_num=[17,20];
tail_basis_num=[10,30];

for T=1:scheme_num
   Wt=GlobalPurne(main_basis_num(T),Wt,Ut,Vt);
   [Wt,obj_history,time]=LocalPursuit(tail_basis_num(T),Wt,Ut,Vt,obj_history);
end


end

