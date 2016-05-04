function obj = objective_value_sing(w)
        global C lamda;
        global DataX DataY;
        b=0;
        global matrix_data_row_num matrix_data_col_num;
        obj = 0.5 * (w') * w + C * sum(max(0, 1 - (DataX * w + b))) + lamda * sum(svd(reshape(w,matrix_data_row_num,matrix_data_col_num)));
        %obj = 0.5 * (w') * w + C * sum( 1 - DataY .* (DataX * w + b));
end
