% Normalized_cross_correlation(NCFF)
% 主要用于协助求信号基频
% 输入：
%     x：求相干性的时域数据
%     fs：采样率
%     params：
%            f0min：基频最小值
%            f0max：基频最大值
%            clipping：是否削波
% 输出：
%     R：归一化互相干系数
%
function R = my_ncff(x, fs, params)
    if nargin < 3
        params = struct();
    end
    params = initParams(params, fs);
    lmin = floor(fs / params.f0max);
    lmax = floor(fs / params.f0min);
    wLen = length(x);
    
    N = wLen - lmax;
    
    % Remove DC level
    x = x - mean(x);
    
    % 计算第一个正则化系数
    x_1 = x(1 : N);
    p = x_1' * x_1;
    
    R = zeros(wLen, 1);
    
    for k = lmin : lmax
        x_2 = x(k : k+N-1);
        numerator = x_1' * x_2;
        
        % 计算第二个正则化系数
        q = x_2' * x_2;
        
        denumerator = sqrt(p*q + eps);
        
        R(k) = numerator / denumerator;
    end
end


function pout = initParams(p, fs)
    pout = p;
    pout.fs = fs;
    if ~isfield(pout, 'f0min');  pout.f0min = 60;     end
    if ~isfield(pout, 'f0max');  pout.f0max = 600;    end
    if ~isfield(pout, 'clipping');  pout.clipping = true;    end 
end
