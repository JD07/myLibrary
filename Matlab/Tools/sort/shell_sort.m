% 希尔排序
% 输入待排序数据序列，返回排序后序列以及各个元素在原始序列中的位置
function [data_sorted, idx] = shell_sort(data)
    lenc = length(data);
    data_sorted = data;
    idx = 1 : lenc;
    
    step = floor(lenc / 2);
    while step >= 1
        for i = step + 1 : lenc
            for j = i : -step : step + 1
                if data_sorted(j) > data_sorted(j - step)
                    tmp = data_sorted(j);
                    data_sorted(j) = data_sorted(j - step);
                    data_sorted(j - step) = tmp;

                    tmp = idx(j);
                    idx(j) = idx(j - step);
                    idx(j - step) = tmp;
                end
            end
        end
        step = floor(step / 2);
    end
end