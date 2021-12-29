%% 循序读取当前目录下所有文件并执行需要的修改
clc; clear; close;

%% 获取文件名
targetPath = 'D:\\Project\\rockchip_babycry_detection\\Resample16K\\5Music\\';
fileFolder=fullfile(targetPath);
dirOutput=dir(fullfile(fileFolder,'*.wav'));
fileNames={dirOutput.name};
[~, lenc] = size(fileNames);


%% 顺序读取文件
for ilen = 1 : lenc
    fileName = fileNames(ilen);
    filePath = [targetPath, fileName{1}];
    [audio, fs] = audioread(filePath);
    
    % 确保单通道
    audio = audio(:, 1); 
    % 确保采样率
    if 16000 ~= fs
        audio = resample(audio, 16000, fs);
        fs = 16000;
    end
    % 去除首尾无用部分
    audio = audio(10*fs + 1 : end - 10*fs);
    
    audiowrite(filePath, audio, fs);
    % 进度打印
    sprintf("%d/%d", ilen, lenc)
end