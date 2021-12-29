%% 语谱图画图函数
% 输入：
%     data_in：单通道音频文件路径或单通道音频数据，若为多通道，则默认显示第一个通道
%     fs:data_in为音频数据时，需要额外输入采样率
function myfig(data_in, fs)
    % --------------- 输入参数检查 ---------------
    if nargin == 1
        [data, fs] = audioread(data_in);
    else
        data = data_in;
    end
    data = data(:, 1); % 默认取第一个通道数据
    
    % --------------- stft参数准备 ---------------
    nLen = length(data);
    Fs = 8000;
    wLen = 256 * fs / Fs;
    win = sqrt(hanning(wLen));
    overlap = 0.5;
    len1          = floor(wLen*overlap);
    len2          = wLen - len1;                            % Step shift
    nFrame        = floor((nLen-wLen)/len2);
    nFFT          = wLen;
    nFreq         = wLen/2+1;
    ySpecBuff     = zeros(nFreq, nFrame);
    
    % --------------- stft ---------------
    nStart = 1;
    for iFrame = 1 : nFrame
        yOneFrame = data(nStart : nStart + wLen - 1, :);
        ySpec = fft(yOneFrame.*win, wLen);
        ySpecBuff(:, iFrame) = ySpec(1 : nFreq);
        
        nStart = nStart + len2;
    end
    
    % --------------- 画图 ---------------
    %=====================================================%
    % 画出语音信号的语谱图  
    %=====================================================%
    figure;
    frameTime = (((1:nFrame)-1)*len2+wLen/2)/fs; % 计算每帧对应的时间
    n2 = 1:nFreq;
    freq = (n2-1)*fs/wLen;                % 计算FFT后的频率刻度
    set(gcf,'Position',[20 100 1500 800]);    
    % axes的前两个参数表示子图像左下顶点相对这个图像左下顶点的水平偏移和垂直偏移程度
    % 后两个参数则是这个图像长和宽的程度
    axes('Position',[0.1 0.1 0.8 0.6]);  
    %imagesc(frameTime,freq,abs(Y(n2,:))); % 画出Y的图像  
    imagesc(frameTime,freq, 20 * log10(abs(ySpecBuff))); % 画出Y的图像  
    axis xy; ylabel('频率/Hz');xlabel('时间/s');
    title('语谱图');
    colormap parula
    colorbar('Location', 'northoutside'); % 将colorbar放在上方
    %=====================================================%
    % 画出语音信号的时间波形  
    %=====================================================%
    time=(0:nLen-1)/fs;       % 计算时间
    axes('Position',[0.1 0.72 0.8 0.22]);
    plot(time,data,'k');
    xlim([0 max(time)]); % 限制plot绘制范围
    xlabel('时间/s'); ylabel('幅值');
    title('语音信号波形');

    pos = get(gcf, 'position');
    set(gcf, 'position', [(1920-pos(3))/2, (1080-pos(4))/2, pos(3), pos(4)]); % 根据自己分辨率修改数字
    
end