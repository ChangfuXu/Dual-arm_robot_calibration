% Fig boxplot
% data_x = [ 2.7658 2.1839 2.0776 1.2094 0.7958;
%            3.7883 2.0159 1.4572 1.2705 1.0055
% ];
% data_y = [2 2 3 4 5];
% plot(data_y, data_x(1,:),'-xb', data_y, data_x(2,:),'--^r');
% 
% legend('\itd\it_{n1}=0\itmm','\itd\it_{n1}=30\itmm');
% % 坐标轴标注 
% xlabel('The experimental number') 
% ylabel('CE (\itmm))')
% set(gca,'XLim',[1 5]);%X轴的数据显示范围
% set(gca,'XTick', [1:1:5]); %设置要显示坐标刻度
% set(gca,'YLim',[0 10]);%X轴的数据显示范围
% set(gca,'YTick', [0:1:10]); %设置要显示坐标刻度

       
% data_x = [2.0776	1.4792	2.3947	1.9402	1.7088	3.3547;
% 0.7975	0.852	0.9815	1.0054	1.2205	1.3117];
% data_y = [0 10 20 30 40 50];
% plot(data_y, data_x(1,:),'-xr', data_y, data_x(2,:),'--^b');
% 
% legend('\itnumber=3','\itnumber=5');
% % 坐标轴标注 
% xlabel('The forward movement distance of the needle (\itmm)') 
% ylabel('CE (\itmm))')
% set(gca,'XLim',[0 50]);%X轴的数据显示范围
% set(gca,'XTick', [0:10:50]); %设置要显示坐标刻度
% set(gca,'YLim',[0 10]);%X轴的数据显示范围
% set(gca,'YTick', [0:1:10]); %设置要显示坐标刻度

%% figure the impact of the sample points, 'RMSE','Min-AE','Mean-AE','Max-AE'
% input_file_name = 'plot_data';
% data = xlsread(input_file_name,'Sheet2');% read the input data;
% plot(data(:,1), data(:,2),'-.xr', data(:,1), data(:,3),'--^g', data(:,1), data(:,4),'-*b', data(:,1), data(:,5),'--+c');
% 
% legend('RMSE','Min-AE','Mean-AE','Max-AE');
% % 坐标轴标注 
% xlabel('The number of point ') 
% ylabel('Error (mm)')
% set(gca,'XLim',[10 16]);%X轴的数据显示范围
% set(gca,'XTick', [10:1:16]); %设置要显示坐标刻度
% set(gca,'YLim',[0 2]);%X轴的数据显示范围
% set(gca,'YTick', [0:0.2:2]); %设置要显示坐标刻度
% 

%% figure, the impact of the i experiment
input_file_name = 'plot_data_20200522';
data = xlsread(input_file_name,'Sheet5');% read the input data;
disp(data);
% plot(data(:,1),data(:,2),'-.xb');
% legend('Absolute error');
% hist(data(:,2),16);
histogram (data(:,2),[0.1386, 0.2343,0.33,0.4257, 0.5214, 0.6171, 0.7128,0.8085, 0.9042, 0.9999, 1.0956, 1.1913, 1.287, 1.3827, 1.4784, 1.5743, 1.67]);
% histogram (data(:,2),[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7]);
% histogram (data(:,2),16);
% % 坐标轴标注 
xlabel('Error (mm)') 
ylabel('Count')
set(gca,'XLim',[0.1 1.7]);%X轴的数据显示范围
% set(gca,'XTick', [1:3:64]); %设置要显示坐标刻度
set(gca,'YLim',[0 10]);%X轴的数据显示范围
% set(gca,'YTick', [0:0.2:2]); %设置要显示坐标刻度


%% figure the impact of the sample points,'Accuracy','Precision'
% input_file_name = 'plot_data_20200522';
% data = xlsread(input_file_name,'Sheet3');% read the input data;
% plot(data(:,1), data(:,2),'-.*b', data(:,1), data(:,3),'-xr');
% 
% legend('Accuracy','Precision');
% % % 坐标轴标注 
% % xlabel('The number of sample point ') 
% % ylabel('Calibration Error')
% % set(gca,'XLim',[4 64]);%X轴的数据显示范围
% % set(gca,'XTick', [4:3:64]); %设置要显示坐标刻度
% % set(gca,'YLim',[0 3]);%X轴的数据显示范围
% % set(gca,'YTick', [0:0.2:3]); %设置要显示坐标刻度
% hold on;
% 
% %% figure plotbox, the impact of the sample points
% input_file_name = 'plot_data_20200522';
% data1 = xlsread(input_file_name,'Sheet4');% read the input data;
% disp(data1);
% boxplot(data1, 'labels', {'4', '7', '10', '13', '16', '19','22', '25', '28', '31', '34', '37','40', '43', '46', '49', '52', '55','58', '61', '64'});
% % 坐标轴标注 
% xlabel('The number of sample point ') 
% ylabel('Error(mm)')
% % set(gca,'XLim',[4 64]);%X轴的数据显示范围
% % set(gca,'XTick', [4:3:64]); %设置要显示坐标刻度
% % set(gca,'YLim',[0 2]);%X轴的数据显示范围
% % set(gca,'YTick', [0:0.5:2]); %设置要显示坐标刻度