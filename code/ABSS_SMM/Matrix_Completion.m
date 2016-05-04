clear;
clear all;
global offlineData labelInfo;
global matrix_data_row_num matrix_data_col_num;
global C lamda;

C=1;
lamda=1;

pic_list={'image/re1.jpg','image/re2.jpg','image/re3.jpg'};

imagenum =1;
pic_name = pic_list{imagenum};
Xfull = double(imread(pic_name));
[matrix_data_row_num, matrix_data_col_num, ~] = size(Xfull);

% 2011 is seed
ind = randint(matrix_data_row_num,matrix_data_col_num,10,2011);

kk = 6; % smaller than 5

ind = (ind < kk);   % 50% entries are missing, controlled by kk.

%%
mask(:,:,1)=ind;
mask(:,:,2)=ind;
mask(:,:,3)=ind;

Xmiss = Xfull.*mask;
labelInfo = Xmiss(:,:,1) > 0;
Xrecover = zeros(matrix_data_row_num,matrix_data_col_num,3);

fullpsnr=[];
figure;
imshow(Xmiss/255); % show the missing image.
xlabel('image with missing pixels');
%%
tic;
%run ABSS 
for i = 1:3
     fprintf('channel(rgb) %1d\n',i);
     offlineData=Xmiss(:,:,i);
     Xrecover(:,:,i) = ABSS();
     
end  
time_cost = toc;
% stat error
Psnr = PSNR(Xfull,Xrecover,ones(size(mask))-mask);
% show the recovered image.
figure;
Xrecover=max(Xrecover(:,:,:),0);
Xrecover = min(Xrecover,255);
imshow(Xrecover/255);
xlabel('recovered image by ABSS');


fprintf('Recovered by ABSS: psnr(%.3f), time(%.1fs)\n ',Psnr,time_cost);