 function obj = objective_value_f(w, p, q, b, X, y, C, tau)
        obj = 0.5 * (w') * w + C * sum(max(0, 1 - y .* (X * w + b))) + tau * sum(svd(reshape(w,p,q)));
 end

