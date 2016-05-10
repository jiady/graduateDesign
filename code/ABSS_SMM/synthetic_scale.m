clear;
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM/libqp/matlab')
addpath('/UserData/Course/graduateDesign/code/ABSS_SMM/ADMM')

global DataX DataY;
global matrix_data_row_num matrix_data_col_num;
global C lamda;
global stepcoef;
C=1;
lamda=1;

matrix_data_row_num=80;
matrix_data_col_num=100;
train_neg_num= 500;
train_pos_num= 500;

train_num=train_neg_num+train_pos_num;
OriginDataX=zeros(train_num, matrix_data_row_num*matrix_data_col_num);
DataY=zeros(train_num,1);

A=rand([train_num,train_num]);
[Va,Ua]=qr(A);
for i=1:matrix_data_row_num*matrix_data_col_num
   OriginDataX(:,i)=Va(:,ceil(i/(0.2*matrix_data_col_num*matrix_data_row_num)))';
end

W = zeros( matrix_data_row_num, matrix_data_col_num);
for i=1:matrix_data_col_num/5
    W =W+ rand(matrix_data_row_num,1)*rand(1,matrix_data_col_num);
end
%%

error=[0,0.0001,0.001,0.01,0.1];



for index=1:1
    for i=1:matrix_data_row_num*matrix_data_col_num
        DataX(:,i)=OriginDataX(:,i)+normrnd(0,error(index),[train_num,1]);
    end
    ADMMData=DataX;

    for i= 1:train_neg_num + train_pos_num
        if(DataX(i,:)*W(:)>0)
            DataY(i,1)=1;
        else
            DataY(i,1)=-1;
            DataX(i,:)=DataX(i,:)*(-1);
        end
    end

 
    tic
    [Ww,b,rk,stop_init,obj_history,time]= fastADMM(ADMMData,DataY,matrix_data_row_num,matrix_data_col_num,1,1,300);
    tic
    
    [Wt,obj_history2,time2] = ABSS();
    
    SVMmodel=fitcsvm(ADMMData,DataY);
    ws=reshape(SVMmodel.Beta,matrix_data_row_num,matrix_data_col_num);

    Wadmm=reshape(Ww,matrix_data_row_num,matrix_data_col_num);
    Wabss=reshape(Wt,matrix_data_row_num,matrix_data_col_num);
 
    figuresvm=figure;
    imagesc(ws);
    colorbar;
    saveas(figuresvm,['groupsvm',int2str(index),'.jpg']); 
    
    figureabss=figure;
    imagesc(Wadmm);
    colorbar;
    saveas(figureabss,['groupabss',int2str(index),'.jpg']); 

    figureadmm=figure;
    imagesc(Wabss);
    colorbar;
    saveas(figureadmm,['groupadmm',int2str(index),'.jpg']); 

    figure1 = figure;

    % Create axes
    axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');

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
    saveas(figure1,['group',int2str(index),'.jpg']); 
end

