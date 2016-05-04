clear;
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM/libqp/matlab')
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM')

global DataX DataY;
global matrix_data_row_num matrix_data_col_num;
global C lamda;
global stepcoef;
C=1;
lamda=1;

matrix_data_row_num=10;
matrix_data_col_num=matrix_data_row_num;
train_neg_num= 100;
train_pos_num= 100;

train_num=train_neg_num+train_pos_num;
DataX=zeros(train_num, matrix_data_row_num*matrix_data_col_num);
DataY=zeros(train_num,1);

targetstep=100;
labniz=floor(sqrt(matrix_data_row_num*matrix_data_col_num))*C*train_num*255;
stepcoef = targetstep *64 / (labniz * labniz);

W = zeros( matrix_data_row_num, matrix_data_col_num);
for i=1:matrix_data_row_num/3
    W =W+ rand(matrix_data_row_num,1)*rand(1,matrix_data_col_num);
end


for i= 1:train_neg_num + train_pos_num
    A= normrnd(0,100,matrix_data_row_num,matrix_data_col_num);
    DataX(i,:)=A(:);
    if(DataX(i,:)*W(:)>0)
        DataY(i,1)=1;
    else
        DataY(i,1)=-1;
    end
end
%%
tic
[Wt,obj_history2,time2] = ABSS();
tic
[Ww,b,rk,stop_init,obj_history,time]= fastADMM(DataX,DataY,matrix_data_row_num,matrix_data_col_num,1,1,300);

%%
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
%% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0 time2(end)*2]);
box(axes1,'on');
hold(axes1,'on');

% Create ylabel
ylabel('error');

% Create xlabel
xlabel('CPU time(s)');

% Create plot
plot(time,obj_history,'DisplayName','ADMM','MarkerSize',0.5,'LineWidth',2);

% Create plot
plot(time2,obj_history2,'DisplayName','Atom decomposition','LineWidth',2);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'FontSize',14);


