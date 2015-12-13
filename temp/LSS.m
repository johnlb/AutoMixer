classdef LSS
    methods(Static)
        
        function coef = CFS(f, y)
            a = transpose(f) * f;
            coef = a \(transpose(f) * y);
        end
        
        
        function Ew = SS(f, coef, y)
            Ew = transpose(f * coef - y) * (f * coef - y) / 2;
        end
        
        function r = RMS(f, coef, y)
            r = sqrt(2 * LSS.SS(f, coef, y) /size(y,1));
        end
    end    
end