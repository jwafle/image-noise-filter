%% Signals Final Project
clear all
close all
clc
% Image Load & Prep
% Please place BRAINBMP.bmp image directory in the line below.
BRAINBMP = imread('C:\Users\jwoelfel\OneDrive - University of Northwestern - St. Paul\Documents\MATLAB\Signals & Systems\BRAINBMP.bmp');
image(BRAINBMP);
BRAINBMP = rgb2gray(BRAINBMP);
BRAINBMPdbl = im2double(BRAINBMP);
range = max(BRAINBMPdbl(:,:))-min(BRAINBMPdbl(:,:));

%% Standard PSD
psd = 10*log10(abs(fftshift(fft2(BRAINBMP))).^2 );
figure; clf
mesh(psd);
figure
imshow(uint8(psd));

%% Noise Addition
noise = uint8(0.3*255*rand(length(BRAINBMP),length(BRAINBMP)));
noisyBRAINBMP = BRAINBMP + noise;
figure
imshow(noisyBRAINBMP);
UnfilterSNR = 20*log10(mean(BRAINBMP(:)./noise(:)))

%% Noise PSD
noisypsd = 10*log10(abs(fftshift(fft2(BRAINBMP))).^2 );
figure
mesh(noisypsd)
figure
imshow(uint8(noisypsd))

%% Ideal Lowpass FIR Filter Design
wn = (420-315)/315
order = 30;
[f1,f2] = freqspace(order,'meshgrid');
Hd = zeros(order,order); d1 = sqrt(f1.^2 + f2.^2) < wn;
Hd(d1) = 1;
Hd = Hd./sum(sum(Hd));
figure
mesh(f1,f2,Hd)
filterOut1 = filter2(Hd,noisyBRAINBMP);
filterOut1 = uint8(filterOut1);
figure
imshow(filterOut1);
LPFilterSNR = 20*log10(mean(BRAINBMP(:)./(filterOut1(:)-BRAINBMP(:))))

% Ideal LPF Filter PSD
psd = 10*log10(abs(fftshift(fft2(filterOut1))).^2 );
figure; clf
mesh(psd);
figure
imshow(uint8(psd));
%% Unique FIR Filter Design
wnl = (350-315)/315
wnh = (450-315)/315
order = 30;
[f1,f2] = freqspace(order,'meshgrid');
Hd = zeros(order,order); d1 = sqrt(f1.^2 + f2.^2) < wnl;
d2 = sqrt(f1.^2 + f2.^2) < wnh;
Hd(:) = 0.01;
Hd(d2) = 0.05;
Hd(d1) = 1;
Hd = Hd./sum(sum(Hd));
figure
mesh(f1,f2,Hd)
filterOut2 = filter2(Hd,noisyBRAINBMP);
filterOut2 = uint8(filterOut2);
figure
imshow(filterOut2);
UniqueFilterSNR = 20*log10(mean(BRAINBMP(:)./(filterOut2(:)-BRAINBMP(:))))

% Unique Filter PSD
psd = 10*log10(abs(fftshift(fft2(filterOut2))).^2 );
figure; clf
mesh(psd);
figure
imshow(uint8(psd));




