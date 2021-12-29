function filterCoeffPrintfNew(SOSMatrix, ScaleValues)
    % SOS矩阵一定为6列，因为每一行实际上表示了一个双二阶滤波器
    [num, ~] = size(SOSMatrix); 
    for i = 1 : num
        SOS = SOSMatrix(i, :);

        res = num2str(ScaleValues(i)) + " * ( 1";    
        if SOS(2) > 0
            res = res + " + " + num2str(SOS(2)) + "z^-1 ";
        elseif SOS(2) < 0
            res = res + " - " + num2str(-SOS(2)) + "z^-1 ";
        end

        if SOS(3) > 0
            res = res + " + " + num2str(SOS(3)) + "z^-2 ";
        elseif SOS(3) < 0
            res = res + " - " + num2str(-SOS(3)) + "z^-2 ";
        end
        
        res = res +  ") / ( 1";
        
        if SOS(5) > 0
            res = res + " + " + num2str(SOS(5)) + "z^-1 ";
        elseif SOS(5) < 0
            res = res + " - " + num2str(-SOS(5)) + "z^-1 ";
        end
        
        if SOS(6) > 0
            res = res + " + " + num2str(SOS(6)) + "z^-2 ";
        elseif SOS(6) < 0
            res = res + " - " + num2str(-SOS(6)) + "z^-2 ";
        end
        
        if i ~= num
            res = res + ") * \n";
        else
            res = res + ") * " + num2str(ScaleValues(end)) + "\n";
        end
        
        fprintf(res);
    end
end