% 对分帧处理得到的结果做istft，方便仿真，与my_STFT配合使用
% 输入:
%     Spec: stft后处理得到的频谱矩阵
%     params: 设置参数
%             wLen: 分帧长度
%             win: 窗函数
%             nhop: 帧移
% 输出:
%     audio: 时域数据

function audio = my_InverseSTFT(Spec, params)
    if nargin < 2
        params = struct();
    end
    [nFFT, nFrame] = size(Spec);
    nFFT = 2*(nFFT-1);
    params = initParams(params, nFFT);
    wLen = params.wLen;
    win = params.win;
    nhop = params.nhop;
    
    audio = zeros(nFrame * nhop + wLen, 1);
    
    nStart = 1;
    for iFrame = 1 : nFrame
        res = Spec(:,iFrame);
        audio(nStart:nStart+wLen-1)=audio(nStart:nStart+wLen-1)+  win.*real(ifft( [res;conj(res(end-1:-1:2))]));

        nStart = nStart + nhop;
    end
    
    
    
end


function pout = initParams(p, nFFT)
    pout = p;
    if ~isfield(pout, 'wLen')       pout.wLen = nFFT;                 end
    if ~isfield(pout, 'win')        pout.win = sqrt(hanning(pout.wLen));      end
    if ~isfield(pout, 'nhop')       pout.nhop = round(pout.wLen/2);     end
end