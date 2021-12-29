%% 滤波器设计
clc; clear all; close all;

%% 低通滤波器
% 设置参数
fs = 16000; % 采样频率
fc = 3000; % 低通滤波3dB截止频率
fnorm = fc / (fs / 2); % 归一化3dB截止频率
D = fdesign.lowpass('N,F3dB', 5, fnorm);
lpFilter = design(D,'butter','SystemObject',true);
fvtool(lpFilter)
% 滤波器系数保留指定位数
% 如果滤波器系数出现分子全为0的情况，则需要调大保留位数
SOSMatrix = roundn(lpFilter.SOSMatrix, -6); 
ScaleValues = roundn(lpFilter.ScaleValues, -6);

% 显示系数
%filterCoeffPrintf(SOSMatrix, ScaleValues);

% 保存系数
filterCoeffSave(SOSMatrix, ScaleValues, 'lpFilterCoeff.cpp');

%% 高通滤波器
fs = 48000; % 采样频率
fc = 400; % 高通滤波3dB截止频率
fnorm = fc / (fs / 2); % 归一化3dB截止频率
D = fdesign.highpass('N,F3dB', 5, fnorm);
hpFilter = design(D, 'butter', 'SystemObject',true);
fvtool(hpFilter)
SOSMatrix = roundn(hpFilter.SOSMatrix, -6);
ScaleValues = roundn(hpFilter.ScaleValues, -6);

% 显示系数
%filterCoeffPrintf(SOSMatrix, ScaleValues);

% 保存系数
filterCoeffSave(SOSMatrix, ScaleValues, 'hpFilterCoeff.cpp');

%% 带通滤波器
fs = 16000;
flow = 60 / (fs / 2);
fhigh = 600 / (fs / 2);
bandpassSpecs = fdesign.bandpass('N,F3dB1,F3dB2', 6, flow, fhigh);
bpFilter = design(bandpassSpecs,'butter','SystemObject',true);
fvtool(bpFilter)

% 显示系数
SOSMatrix = roundn(bpFilter.SOSMatrix, -6);
ScaleValues = roundn(bpFilter.ScaleValues, -6);
filterCoeffPrintf(SOSMatrix, ScaleValues);

% 保存系数
filterCoeffSave(SOSMatrix, ScaleValues, 'bpFilterCoeff.cpp');














