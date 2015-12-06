classdef LWR
    methods (Static)
        function r  = get_r(x, train_x, tao)
            x = repmat(x, length(train_x), 1) - train_x;
            %x = x';
            r =arrayfun(@(z) exp(- sum(x(z,:).* x(z,:)) / (2 * tao * tao)), 1:length(x), 'UniformOutput',false);
            r = reshape(cell2mat(r),length(train_x),[]).';
            r = diag(r);
        end
        
        function coef = CFS(x, train_y, train_x, tao)
            r = LWR.get_r(x, train_x, tao);
            a = transpose(train_x) * r * train_x;
            coef = a \(transpose(train_x) * r * train_y);
        end 
        
    end
end