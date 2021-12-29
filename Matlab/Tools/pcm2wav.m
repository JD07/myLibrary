%% 读取当前目录下的pcm文件，并输出为wav
% 以数据流的方式读写，从而可以处理较大的数据
% wav头中的固定标识为大端存储，参数为下端存储，具体参考以下博文：
% https://blog.csdn.net/imxiangzi/article/details/80265978

% ============= 2020/10/21  0.1版本：基础函数搭建 ==================
% 支持切片，通过sIndex和eIndex参数设置处理范围
% 支持只保留特定通道，在inChannel中填入需要保留的通道序号

clc;clear all; 

%% wav基本参数
fs = 16000;
inChannelNum = 6; % 语音通道数目
reChannelNum = 0; % 回采通道数目
inChannel = [1, 2, 3, 4, 5, 6]; % 语音通道序号
totalChannelNum = inChannelNum + reChannelNum; % 总共的通道数目
fileName = "src_file_bq.pcm";
newFileName = "src_0302.wav";
sIndex = 0; % 开始标志
eIndex = -1; % 结束标志，设为-1将其无效

%% wav文件头
audiowrite(newFileName, 0, fs); % 产生空wav文件，生成wav头
outFid = fopen(newFileName, 'rb+'); % 修改该wav文件
fseek(outFid, 44, 'bof'); % 定位到数据区域
fileLen = 0; % 记录已转wav的文件长度

%% 数据流读取数据
inFid = fopen(fileName, 'rb'); % 打开pcm文件
fileSize = 100; % 每次读取数据的帧数
index = 0; 
while 1
    [data] = fread(inFid, fileSize * totalChannelNum, 'int16');
    if length(data) < fileSize * totalChannelNum % 读到文件末尾，长度不足的部分直接舍弃
        break;
    end
    if (eIndex ~= -1) && (index > eIndex) % 读到结束标志，退出
        break;
    end
    if index >= sIndex % 读到开始标志，开始数据流写入数据
        data = data.';
        Data = reshape(data, totalChannelNum, []);
        tmpData = Data(inChannel, :); % 只保留数据通道，回采通道舍弃
        newdata = reshape(tmpData, 1, []);
        fileLen = fileLen + 2 * fileSize * inChannelNum; % 文件长度（每个float数据16位，占2个字节）
        fwrite(outFid, newdata, 'int16');
    end
    index = index + 1;
end
%% wav头
% wav文件头参数计算
bitsPerSmple = 16; % 每个数据大小，一般16位
BytesPerSec = fs * (bitsPerSmple/8) * inChannelNum; % 音频数传送速率
BlockAlign = bitsPerSmple * inChannelNum / 8; % 每次采样大小

% 修改wav头
fseek(outFid,4,'bof'); % 指针重新定位
fwrite(outFid, fileLen+36, 'ubit32');
fseek(outFid,22,'bof'); % 指针重新定位
fwrite(outFid, inChannelNum, 'ubit16');
fwrite(outFid, fs, 'ubit32');
fseek(outFid,28,'bof'); % 指针重新定位
fwrite(outFid, BytesPerSec, 'ubit32');
fwrite(outFid, BlockAlign, 'ubit16');
fseek(outFid,40,'bof'); % 指针重新定位
fwrite(outFid, fileLen, 'ubit32');

fclose(inFid);
fclose(outFid);