function [ Wt ] = GlobalPurne( iteration ,Wt, Ut,Vt)
% Summary of this function goes here
%   Detailed explanation goes here
global offlineData labelInfo;
% kk=17;
% 
%        [m,n] = size(offlineData);
%        U=Ut;
%        V=Vt;
%        R=Wt-labelInfo.* (Wt-offlineData);
%        oldV = V;
%        [u,s,v] =randomsvd(R, U, V, m, n, kk, oldV, 3);  
%        sing_vals=diag(s);  
%        tmp=max(sing_vals-mu,0);
%        Ug = u(:,tmp>0); 
%        Vg = v(:,tmp>0); 
%        Ua = qr([Ug U]);
%        Va = qr([Vg V]);
%        size(Ua)
%        S = ComputeSubspaceMinimize(offlineData, labelInfo, Ug, Vg', lambda);
%        Wt= Ug*diag(S)*Vg';
  

end