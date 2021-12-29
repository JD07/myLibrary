function filterCoeffSave(SOSMatrix, ScaleValues, filename)
    fp = fopen(filename, 'w');
    [num, ~] = size(SOSMatrix);
    for i = 1 : num
        fprintf(fp, '//SOS_bank %d\n',i);
        fprintf(fp, '{');
        for j = 1 : 5
            if j <= 3
                coeff = SOSMatrix(i, j) * ScaleValues(i);
            else
                coeff = SOSMatrix(i, j);
            end
            fprintf(fp, '%f, ', coeff);
        end
        fprintf(fp, '%f},\n', SOSMatrix(i, 6));
    end
    fprintf(fp, '\n');

    fclose(fp);
end