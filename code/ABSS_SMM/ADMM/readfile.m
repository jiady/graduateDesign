clear 
load ../Utility/raw_list.mat
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM/libqp/matlab')


p=70;
q=134;
train_num=length(train_neg_list)+length(train_pos_list);
X=zeros(train_num,p*q);
Y=zeros(train_num,0);

test_num=length(test_neg_list)+length(test_pos_list);
tX=zeros(test_num,p*q);
tY=zeros(test_num,0);

base_folder='../../data/Data/';

for i= 1:length(train_neg_list)
    A=imread([ base_folder train_neg_list{i}]);
    X(i,:)=A(:);
    Y(i,1)=-1;
end


for i= 1:length(train_pos_list)
    ix= i+ length(train_neg_list);
    A=imread([ base_folder train_pos_list{i}]);
    X(ix,:)=A(:);
    Y(ix,1)=1;
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
    X=X(ix,:);
    Y=Y(ix,:);
end


%%
CC=[0.001, 0.01,  0.1, 1, 10];
tau=[1];
result=[];
time =[];
for t= tau
    t
tic
[W,b,rk,stop_init,obj_history,time]= fastADMM(X,Y,p,q,1,t);
time_cost = toc;
fprintf('time(%.1fs)\n ',time_cost);

iY=tX*W+b;


resultY=iY>0;
targetY=tY>0;

right = sum((resultY-targetY)==0)
result(end+1)=right;
end
