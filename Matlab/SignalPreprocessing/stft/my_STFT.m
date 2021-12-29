% 对音频数据进行分帧并加窗做stft，方便仿真
% 输入:
%     audio: 单通道音频数据
%     fs: 采样率，用于计算每一帧对应的时间
%     params: 设置参数
%             wLen: 分帧长度
%             win: 窗函数
%             nhop: 帧移
%             truncate: 是否把fft结果的后半部分截断
% 输出:
%     Specs: 由音频stft结果组成的矩阵，矩阵每一列是一帧数据stft的结果
%     Tdata: 数据分帧结果，未加窗
%     frameTime: 每一帧数据对应的时间，方便画图
function [Specs, Tdata, frameTime] = my_STFT(audio, fs, params)
    if nargin<3 
        params = struct();
    end
    params = initParams(params, fs);
    wLen = params.wLen;
    win = params.win;
    nhop = params.nhop;
    truncate = params.truncate;
    
    [nLen, ~] = size(audio);
    nFrame        = floor((nLen - wLen)/nhop);
    if truncate
        nFreq         = wLen/2+1;
    else
        nFreq         = wLen;
    end
    Tdata = zeros(wLen, nFrame);
    Specs = zeros(nFreq, nFrame);
    frameTime = (((1:nFrame)-1)*nhop+wLen/2)/fs; % 计算每帧对应的时间
    
    nStart = 1;
    for iFrame = 1 : nFrame
        yOneFrame = audio(nStart : nStart + wLen - 1, :);
        ySpec = fft(yOneFrame.*win, wLen);
        
        Tdata(:, iFrame) = yOneFrame;
        Specs(:, iFrame) = ySpec(1:nFreq);

        nStart = nStart + nhop;
    end
end



function pout = initParams(p, fs)
    pout = p;
    pout.fs = fs;
    if ~isfield(pout, 'wLen');       pout.wLen = 512;                       end
    if ~isfield(pout, 'win');        pout.win = sqrt(hanning(pout.wLen));   end
    if ~isfield(pout, 'nhop');       pout.nhop = round(pout.wLen/2);        end
    if ~isfield(pout, 'truncate');   pout.truncate = 0;        end
end