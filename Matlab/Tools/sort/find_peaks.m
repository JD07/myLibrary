% 寻找一段数据中的最大的复数个峰值以及对应的序号位置
% 输入：
%     x：寻找峰值的数据
%     params：
%            numpeaks：返回的峰值数目
%            lmin：峰值寻找的范围下限
%            lmax：峰值寻找的范围上限
% 输出：
%     peaks：峰值大小
%     idxs：峰值对应序号位置
function [peaks, idxs] = find_peaks(x, params)
    % 初始化
    if nargin < 2
        params = struct();
    end
    wLen = length(x);
    peaks = zeros(floor(wLen/2) + 1, 1);
    idxs = zeros(floor(wLen/2) + 1, 1);
    params = initParams(params, wLen);
    
    % 寻找极大值以及对应坐标
    counter = 1;
    diff = x(2 : end) - x(1 : end-1);
    
    lmin = max(1, params.lmin - 1);
    lmax = max(1, params.lmax - 2);
    
    for k = lmin : lmax
        if diff(k) > 0 && diff(k+1) < 0
            idxs(counter) = k + 1;
            peaks(counter) = x(k + 1);
            counter = counter + 1;
        end
    end
    
    % 降序排序
    counter = counter - 1;
    for j = 1 : counter
        for i = 1 : counter - j
            if peaks(i) < peaks(i + 1)
                tmp1 = peaks(i);
                peaks(i) = peaks(i + 1);
                peaks(i + 1) = tmp1;
                tmp2 = idxs(i);
                idxs(i) = idxs(i + 1);
                idxs(i + 1) = tmp2;
            end
        end
    end
    
    peaks = peaks(1 : params.numpeaks);
    idxs = idxs(1 : params.numpeaks);
end


function pout = initParams(p, wLen)
    pout = p;
    if ~isfield(pout, 'numpeaks');  pout.numpeaks = 4;     end
    if ~isfield(pout, 'lmin');  pout.lmin = 1;    end
    if ~isfield(pout, 'lmax');  pout.lmax = wLen;    end 
end