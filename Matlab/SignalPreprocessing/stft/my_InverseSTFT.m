% �Է�֡����õ��Ľ����istft��������棬��my_STFT���ʹ��
% ����:
%     Spec: stft����õ���Ƶ�׾���
%     params: ���ò���
%             wLen: ��֡����
%             win: ������
%             nhop: ֡��
% ���:
%     audio: ʱ������

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