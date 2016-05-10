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
%Wt=GlobalPurne(10,Wt,Ut,Vt);
[Wt,obj_history,time] = LocalPursuit(50,Wt,Ut,Vt,obj_history,time);

scheme_num=0;
main_basis_num=[17,20];
tail_basis_num=[10,30];

for T=1:scheme_num
   Wt=GlobalPurne(main_basis_num(T),Wt,Ut,Vt);
   [Wt,obj_history,time]=LocalPursuit(tail_basis_num(T),Wt,Ut,Vt,obj_history);
end


end



function [resTheta] = ComputeSubspaceMinimize(X, L, U, V, lambda)
     

     t = size(U, 2);
     l = zeros(t,1);
     u = ones(t,1).*inf;
     rpar.X = X;
     rPar.lossCo= 600;
     rpar.L = L;
     rpar.U = U;
     rpar.V = V;
     rpar.lambda = lambda;
     fun = @(Theta)fminunc_wrapper(Theta, @(Theta)RTheta(Theta,rpar), ...
         @(Theta)RThetaGrad(Theta,rpar));
     opts = struct('factr', 1e4, 'pgtol', 1e-8, 'm', 10); 
     opts.printEvery = 5;
     if size(X,1) > 10000
         opts.m = 50;                                                                  
     end
     [resTheta] = lbfgsb(fun, l, u, opts);
  
end
function [loss] = Computeloss(w)
     global DataX
     loss = 0.5 * (w') * w + C * sum(max(0, 1 - (DataX * w )));
     
end

%compute RTheta
function [R] = RTheta(Theta, rpar)
     X = rpar.X;
     L = rpar.L;
     U = rpar.U;
     V = rpar.V;
     lambda = rpar.lambda;
     t = size(U, 2);
     W = U * diag(Theta(1:t)) * V;
     loss = Computeloss(W(:));
     R = lambda.*sum(Theta) + rPar.lossCo*loss;
   
end

%compute RThetaGrad
function [RG] = RThetaGrad(Theta, rpar)
     X = rpar.X;
     L = rpar.L;
     U = rpar.U;
     V = rpar.V;
     lambda = rpar.lambda;

     t = size(U, 2);
     W = U * diag(Theta(1:t)) * V;
     dR = 2*L.*(W-X);
     RG = zeros(t, 1);
     for i = 1 : t
         j = U(:,i) * V(i,:);
         %compute gradient is time consuming
     end
end   
 

