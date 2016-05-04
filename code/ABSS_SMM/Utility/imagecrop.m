clear;

load raw_list.mat;
base_folder='../../data/raw/';
target_folder='../../data/Data/';
width=70;
height=134;

list=train_neg_list;
for ix = 1:size(list)
    %ix
     source= [ base_folder list{ix}];
     target= [ target_folder list{ix}];
     A = imread(source);
     [m,n,~]=size(A);
     scale= m/height;
     if scale < 1
         ix
         continue;
     end
     x= floor(width*scale);
     if x>n
         ix
         continue;
     end
     A=imcrop(A,[randi(n-x),0,x,m]);
   
     A=rgb2gray(A);
   
     
     A=imresize(A,[height,width]);
    
     imwrite(A,target);
end



