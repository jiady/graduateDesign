clear 
load ./Utility/raw_list.mat
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM/libqp/matlab')
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM')

global DataX DataY;
global matrix_data_row_num matrix_data_col_num;
global C lamda;
global stepcoef;
C=1;
lamda=1;

matrix_data_row_num=134;
matrix_data_col_num=70;
train_num=length(train_neg_list)+length(train_pos_list);
DataX=zeros(train_num, matrix_data_row_num*matrix_data_col_num);
DataY=zeros(train_num,1);

targetstep=100;
labniz=floor(sqrt(matrix_data_row_num*matrix_data_col_num))*C*train_num*255;
stepcoef = targetstep *64 / (labniz * labniz);

test_num=length(test_neg_list)+length(test_pos_list);
tX=zeros(test_num, matrix_data_row_num*matrix_data_col_num);
tY=zeros(test_num,1);

base_folder='../data/Data/';

for i= 1:length(train_neg_list)
    A=imread([ base_folder train_neg_list{i}]);
    DataX(i,:)=A(:);% one line per sample
    DataY(i,1)=-1;
end


for i= 1:length(train_pos_list)
    ix= i+ length(train_neg_list);
    A=imread([ base_folder train_pos_list{i}]);
    DataX(ix,:)=A(:);
    DataY(ix,1)=1;
end

for i= 1:length(test_neg_list)
    A=imread([ base_folder test_neg_list{i}]);
    tX(i,:)=A(:);
    tY(i,1)=-1;
end


for i= 1:length(test_pos_list)
    ix= i+ length(test_neg_list);
    A=imread([ base_folder test_pos_list{i}]);
    tX(ix,:)=A(:);
    tY(ix,1)=1;
end
%% reduce train number
reduced_train_number=300;
if reduced_train_number>train_num
    ix= randperm(train_num,reduced_train_number);
    DataX=DataX(ix,:);
    DataY=DataY(ix,:);
end


%%
CC=[0.001, 0.01,  0.1, 1, 10];
tau=[1];
result=[];
time=[];
for t= tau
    t
%[W,b,rk,stop_init,obj_history,time]= fastADMM(DataX,DataY,matrix_data_row_num,matrix_data_col_num,1,t);
tic
[W,obj_history,time] = ABSS();
%[W,b,rk,stop_init]= fastADMM(DataX,DataY,matrix_data_row_num,matrix_data_col_num,1,t);
time_cost = toc;
fprintf('time(%.1fs)\n ',time_cost);
b=0
iY=tX*W+b;


resultY=iY>0;
targetY=tY>0;

right = sum((resultY-targetY)==0)
%result(end+1)=right;
plot(time,obj_history)
end