% mfcc系数提取类
% 输入频谱，计算对应的mfcc系数

classdef MFCC < handle
    properties(Access = public)
        mfccParameters % 可调整参数结构体
        % --- fs ：采样率
        % --- N ：FFT大小
        % --- n_mfcc ：mfcc系数个数
        % --- M ：mel滤波器个数
        % --- fmin : mel滤波器最小范围
        % --- fmax : mel滤波器最大范围
        dctcoef % DCT系数
        w % 归一化倒谱提升窗口
        bank % mel滤波器系数
    end
    
    methods(Access = public)
        % === 构造函数 ===
        function obj = MFCC()
            % 默认参数
            obj.mfccParameters = struct();
            obj.mfccParameters.fs = 16000;
            obj.mfccParameters.N = 512;
            obj.mfccParameters.n_mfcc = 13;
            obj.mfccParameters.M = 26;
            obj.mfccParameters.fmin = 0;
            obj.mfccParameters.fmax = obj.mfccParameters.fs / 2;
            
            % 计算mel滤波系数
            obj.melCal();
            
            % DCT系数
            obj.dctcoef = zeros(obj.mfccParameters.n_mfcc, obj.mfccParameters.M);
            for k=1:obj.mfccParameters.n_mfcc
              n=0:obj.mfccParameters.M-1;
              obj.dctcoef(k,:)=cos((2*n+1)*k*pi/(2*obj.mfccParameters.M));
            end

            % 归一化倒谱提升窗口
            obj.w = 1 + 6 * sin(pi * (1:obj.mfccParameters.n_mfcc) ./ obj.mfccParameters.n_mfcc);
            obj.w = obj.w/max(obj.w);
            
        end
        
        % === 参数设置函数 ===
        function setParameters(obj, params)
            if isfield(params, 'fs');      obj.mfccParameters.fs = params.fs;          end
            if isfield(params, 'N');       obj.mfccParameters.N = params.N;            end
            if isfield(params, 'n_mfcc');  obj.mfccParameters.n_mfcc = params.n_mfcc;  end
            if isfield(params, 'M');       obj.mfccParameters.M = params.M;            end
            if isfield(params, 'fmin');    obj.mfccParameters.fmin = params.fmin;      end
            if isfield(params, 'fmax');    obj.mfccParameters.fmax = params.fmax;      end

            % 计算mel滤波系数
            obj.melCal();
            
            % DCT系数
            obj.dctcoef = zeros(obj.mfccParameters.n_mfcc, obj.mfccParameters.M);
            for k=1:obj.mfccParameters.n_mfcc
              n=0:obj.mfccParameters.M-1;
              obj.dctcoef(k,:)=cos((2*n+1)*k*pi/(2*obj.mfccParameters.M));
            end

            % 归一化倒谱提升窗口
            obj.w = 1 + 6 * sin(pi * [1:obj.mfccParameters.n_mfcc] ./ obj.mfccParameters.n_mfcc);
            obj.w = obj.w/max(obj.w);
            
        end
        
        % === 执行函数 ===
        % 输入频谱，输出mfcc系数
        function mfcc = process(obj, Spec)
            SpecAbs = abs(Spec);
            x2 = SpecAbs.^2;

            c1=obj.dctcoef * log(obj.bank * x2);
            c2 = c1.*obj.w';
            mfcc = c2;
        end
    end
    
    methods(Access = protected)
        function melCal(obj)
            % mel滤波器系数计算，参考教材实现
            % 但是教材的公式有点问题，所以做了一点修改
            % 注意matlab数组从1开始
            fs = obj.mfccParameters.fs;
            N = obj.mfccParameters.N;
            M = obj.mfccParameters.M;
            fmin = obj.mfccParameters.fmin;
            fmax = obj.mfccParameters.fmax;
            
            mflh_l = frq2mel(fmin);
            mflh_h = frq2mel(fmax);
            
            fm =zeros(M+2, 1);
            for m = 0 : M+1
                tmp = mflh_l + m * (mflh_h - mflh_l)/(M+1);
                fm(m+1) = mel2frq(tmp) * N/fs;
            end
            
            H = zeros(M, N/2+1);

            for m = 1 : M
                for k = 0 : N/2
                    if k <= fm(m)
                        H(m, k+1) = 0;
                    elseif k <= fm(m+1)
                        H(m, k+1) = (k - fm(m))/(fm(m+1) - fm(m));
                    elseif k <= fm(m+2)
                        H(m, k+1) = (fm(m+2) - k)/(fm(m+2) - fm(m+1));
                    else
                        H(m, k+1) = 0;
                    end
                end
            end

            obj.bank = H/max(H(:));
        end
    end
    
end

% === mel频率和标准频率的相互转换 ===
function mel = frq2mel(frq)
    k = 1125;
    mel = k * log(1+frq/700);
end

function frq = mel2frq(mel)
    k = 1125;
    frq=700.*(exp(abs(mel)/k)-1);
end


    