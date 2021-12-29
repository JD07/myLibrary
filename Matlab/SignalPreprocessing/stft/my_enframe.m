% 对音频数据进行分帧，方便仿真
% 输入:
%     audio: 单通道音频数据
%     fs: 采样率
%     wLen: 分帧长度
%     nhop: 帧移
% 输出:
%     Tdata: 数据分帧结果，未加窗
%     frameTime: 每一帧数据对应的时间，方便画图
function [xDatas, frameTime] = my_enframe(audio, fs, wLen, nhop)
    
    [nLen, ~] = size(audio);
    nFrame = floor((nLen - wLen)/nhop);
    xDatas = zeros(wLen, nFrame);
    frameTime = (((1:nFrame)-1)*nhop+wLen/2)/fs; % 计算每帧对应的时间
    
    nStart = 1;
    for iFrame = 1 : nFrame
        xDatas(:, iFrame) = audio(nStart : nStart + wLen - 1, :);
        nStart = nStart + nhop;
    end
end

