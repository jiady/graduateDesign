%Written by Chen Zhao, please contact henryzhao4321@gmail.com
%






clear;
%clc;
%% for experiment use
pic_list = {'re1.jpg','re2.jpg','re3.jpg'};

imagenum =3;
pic_name = pic_list{imagenum};
Xfull = double(imread(pic_name));
[m, n, ~] = size(Xfull);

% 2011 is seed
ind = randint(m,n,10,2011);
% ind = randi([0,10],m,n);
% imshow(ind)

oldind = ind;

kk = 6; % smaller than 5

ind = (oldind < kk);   % 50% entries are missing, controlled by kk.

%%
mask(:,:,1)=ind;
mask(:,:,2)=ind;
mask(:,:,3)=ind;



Xmiss = Xfull.*mask;
known = Xmiss(:,:,1) > 0;
Xrecover = zeros(m,n,3);

fullpsnr=[];
figure;
imshow(Xmiss/255); % show the missing image.
xlabel('image with missing pixels');
%%

tic;
%run ABSS 
for i = 1:3
     fprintf('channel(rgb) %1d\n',i);
     Xrecover(:,:,i) = ABSS(Xmiss(:,:,i),known);
     
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
