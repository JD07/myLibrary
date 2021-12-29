% 时域基频估算函数-基于自相干
% 输入:
%     x: 单通道音频数据
%     fs: 采样率，用于计算每一帧对应的时间
%     params: 设置参数
%             f0min: 基频最小值
%             f0max: 基频最大值
%             clipping: 是否进行削波处理
% 输出:
%     f0: 基频

function f0 = pitch_estimate_corr(x, fs, params)
    if nargin<3 
        params = struct();
    end
    params = initParams(params, fs);
    lmin = floor(fs / params.f0max);
    lmax = floor(fs / params.f0min);
    wLen = length(x);
    
    % 削波处理
    if params.clipping
        [x_center, x_threeLv] = clipping(x);
    else
        x_center = x;
        x_threeLv = x;
    end
    
    % 短时归一化自相关
    R_norm = 0;
    for t = 1 : wLen
        R_norm = R_norm + x_center(t)*x_threeLv(t);
    end
    R = zeros(wLen, 1);
    R(1) = 1;
    for t1 = 2 : wLen
        R(t1) = 0;
        for t2 = t1 : wLen
            R(t1) = R(t1) + x_center(t2)*x_threeLv(t2-t1+1);
        end
        R(t1) = R(t1) / R_norm;
    end 
    
    % 估算基频
    [Rmax, Rloc] = max(R(lmin : lmax));
    if Rmax > 0.25
        period = lmin + Rloc - 1;
        f0 = fs / period;
    else
        f0 = 0;
    end
    
end


function pout = initParams(p, fs)
    pout = p;
    pout.fs = fs;
    if ~isfield(pout, 'f0min');  pout.f0min = 60;     end
    if ~isfield(pout, 'f0max');  pout.f0max = 600;    end
    if ~isfield(pout, 'clipping');  pout.clipping = true;    end 
end



% 削波函数，实现中心削波和三电平削波
% 输入：
%     x: 待处理的单通道数据
% 输出：
%     x_center: 中心削波结果
%     x_threeLvd: 三电平削波结果
function [x_center, x_threeLv] = clipping(x)
    wLen = length(x);
    x_threeLv = zeros(wLen, 1);
    x_center = zeros(wLen, 1);
    
    th0 = 0.5* max(abs(x));
    
    for i = 1 : wLen
        if x(i) > th0
            x_center(i) = x(i) - th0;
            x_threeLv(i) = 1;
        elseif x(i) < - th0
            x_center(i) = x(i) + th0;
            x_threeLv(i) = -1;
        else
            x_center(i) = 0;
            x_threeLv(i) = 0;
        end
    end

end