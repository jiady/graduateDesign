function Wt = ABSS(offlineData, labelInfo)       
   % Input:
   %   offlineData: the whole matrix
   %   labelinfo: 0-1 matrix marking known data
  
   % Output:
   %   Wt: resulting matrix

    lambda =100;
    tmax = 100;
    Ut = [];
    Vt = [];
    Wt=zeros(size(offlineData));
    
    for t = 1:tmax
        
       dR =labelInfo.* (Wt-offlineData);
       %compute the basis
       [u,~,v] = topsvd(-dR, 20);
       ut = u(:,1);
       vt = v(:,1);  
       Ut = [Ut ut];
       Vt = [Vt;vt'];                  
       uvt = ut*vt';
       vec = uvt(:);
       data = -dR(:);
       %compute the weights
       weight = (vec'*vec)\(vec'*data);
       Wt = Wt + weight.*uvt;   

    end 
  
    bas=40; 
    mu=15;
    for aaa=1:2
    %compute number of main basis
    
        kk=1;
       [m,n] = size(offlineData);
       U=Ut;
       V=Vt';
       R=Wt-labelInfo.* (Wt-offlineData);
       oldV = V;
       [u,s,v] =randomsvd(R, U, V, m, n, kk, oldV, 3);  
       sing_vals=diag(s);  
       tmp=max(sing_vals-mu,0);
       Ug = u(:,tmp>0); 
       Vg = v(:,tmp>0); 
       Ua = qr([Ug U]);
       Va = qr([Vg V]);
       size(Ua)
       S = ComputeSubspaceMinimize(offlineData, labelInfo, Ug, Vg', lambda);
       Wt= Ug*diag(S)*Vg';
  

    
    %compute the tail basis
      for t = kk:bas
 
       dR =labelInfo.* (Wt-offlineData);
    %compute the basis
       [u,~,v] = topsvd(-dR, 20);
       ut = u(:,1);
       vt = v(:,1);  
       Ut = [Ut ut];
       Vt = [Vt;vt'];                  
       uvt = ut*vt';
       vec = uvt(:);   
       data = -dR(:);
    %compute the weights
       weight = (vec'*vec)\(vec'*data);
       Wt = Wt + weight.*uvt;   
         
     
      end 
      bas=bas+50;
  
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
function [loss] = Computeloss(X, L, W)
     loss = norm(L.*(X-W),'fro');
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
     loss = Computeloss(X, L, W);
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
         RG(i) = sum(sum(dR.*j)) + rPar.lossCo*lambda;
     end
end   
 
%written by zheng wang @ASU 
function [u, s, v] = topsvd(A, round)
% calculate the top svd of matrix A using round iterations
     stopeps = 1e-3;
     [m, n]  = size(A);
     u       = ones(m,1);
     vo      = 0;
     for i=1:round
         v = u'*A/(norm(u))^2;
         u = A*v'/(norm(v))^2;
         if norm(v-vo) < stopeps
             break
         end
         vo = v;
     end
     nu = norm(u);
     nv = norm(v);
     u  = u/nu;
     v  = v'/nv;
     s  = nu*nv;
end