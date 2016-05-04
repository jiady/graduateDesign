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