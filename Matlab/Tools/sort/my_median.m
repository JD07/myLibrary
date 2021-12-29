% 自己编写的中值滤波，方便改写为C代码，暂时只考虑滤波长度为奇数的情况
% 输入:
%     x: 待滤波数据
%     order: 滤波器长度
% 输出:
%     y: 中值滤波后的数据
function y = my_median(x, order)
    half = floor(order / 2);
    x_new = [zeros(1,half), x, zeros(1, half)];
    y = x;
    
    for t = 1 : length(x)
        x_clip = x_new(t : t + order - 1);
        
        % 排序
        x_clip = shell_sort(x_clip);
        y(t) = x_clip(floor(order/2)+1);
    end
end


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