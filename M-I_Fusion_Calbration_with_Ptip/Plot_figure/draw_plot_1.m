clear;clc;% clear the variables and functions from memory

%% Calculate the resolution ratio of ultrasound image in our experiments
depth = 50; % The depth of US scan image.Unit: cm 
sy = 50 / 518; % Calculate y-axis resolution ratio of ultrasound image
sx = sy; % resolution ratio of x-axis is equal to the x-axis

%% Read the sample data
needle_dis_i = 20; % the distance number of the needle forward movement
probe_dis_i = 0; % the distance number of the US probe forward movement
input_file_name = {'..\Exp_sample_data\2020_0517\ER_data.xlsx', '..\Exp_sample_data\2020_0517\EL_data.xlsx', '..\Exp_sample_data\2020_0517\ImageTip_data.xlsx'};
rotm_T_ER_NTip = get_rotm_T_ER_NTip(needle_dis_i);% Get the transformation matrix of the needle-tip to ER frame   
rotm_T_EL_PTip = get_rotm_T_EL_PTip(probe_dis_i);%  Get the transformation matrix of the probe-needle-tip to EL frame
eul_P_B_ER = xlsread(input_file_name{1},num2str(needle_dis_i));% read the input data
eul_P_B_EL = xlsread(input_file_name{2},num2str(probe_dis_i));% read the input data
eul_P_I_ITip = xlsread(input_file_name{3},strcat(num2str(needle_dis_i),num2str(probe_dis_i)));% read the input data
eul_P_I_ITip = eul_P_I_ITip * sx; % Turn the pixel to millimeter

%% Use the ICP to calibration the transformation matrix of image to probe-needle-tip frame (rotm_P_PTip_I).
exp_nums = length(eul_P_B_ER(:,1));
xyz_P_PTip_NTip = zeros(exp_nums,3);
xyz_P_B_NTip = zeros(exp_nums,3);
for i = 1:exp_nums
    xyz_P_B_NTip_i= calEuler2rotMatrix(eul_P_B_ER(i,:)) * rotm_T_ER_NTip(:,4); %Calculate the needle-tip's positon in robot's frame
    xyz_P_B_NTip(i,:) = xyz_P_B_NTip_i(1:3,1)';
    rotm_P_B_PTip_i =  calEuler2rotMatrix(eul_P_B_EL(i,:)) * rotm_T_EL_PTip;
    xyz_P_PTip_NTip_temp = rotm_P_B_PTip_i \ xyz_P_B_NTip_i;% the position coordinate of needle-tip to probe-tip
    xyz_P_PTip_NTip(i,:) = xyz_P_PTip_NTip_temp(1:3,1)';   
end
% disp(xyz_P_PTip_NTip);
xyz_P_B_NTip_cp = pointCloud(xyz_P_B_NTip);
fixed = pointCloud(xyz_P_PTip_NTip); % Use the xyz_P_PTip_NTip  coordinate as fixed points with point cloud format
moving  = pointCloud(eul_P_I_ITip(:,1:3)); % Use the xyz_P_I_ITip coordinate as moving points with point cloud format
disp("xyz_P_B_NTip");
disp(xyz_P_B_NTip_cp.Location);
disp("xyz_P_PTip_NTip");
disp(fixed.Location);
disp("xyz_P_I_ITip");
disp(moving.Location);
% gridSize = 0.1;
% fixed = pcdownsample(fixed, 'gridAverage', gridSize);
% moving = pcdownsample(moving, 'gridAverage', gridSize);
Tolerance = [0.01,0.01];
A = [
    0   0   1  28;
    0   -1  0  20;
    1   0   0  -33;
    0   0   0   1];
A = A';
InitTransf = affine3d(A);
% [tform, movingReg, frmse]= pcregistericp(moving,fixed,'MaxIterations',30, 'Tolerance',Tolerance);
[tform, movingReg, frmse]= pcregistericp(moving,fixed,'InitialTransform',InitTransf ,'MaxIterations',30, 'Tolerance',Tolerance);% Calling the ICP function

disp("Registration points");
disp(movingReg.Location);
tform_T_Ptip_I = (tform.T)';
disp(tform_T_Ptip_I);

% f = zeros(4,1);
% test_moving = moving.Location;
% f(1:3,1) = test_moving(3,1:3)';
% f(4,1) = 1;
% disp(tform_T_Ptip_I * f);
% disp(fixed.Location(3,:));


figure
pcshow(xyz_P_B_NTip_cp,'VerticalAxis','Z','VerticalAxisDir','Up','MarkerSize',100);
title('The positions, {\it^{R}P_{Ntip}(1),...,^{R}P_{Ntip}(64)}, in 3D space.');
xlabel('X(mm)');
ylabel('Y(mm)');
zlabel('Z(mm)');
colormap('winter')
% set(gca,'YLim',[30 60]);%X轴的数据显示范围
% set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度


figure
pcshow(fixed,'VerticalAxis','X','VerticalAxisDir','Up','MarkerSize',100);
title('The positions, {\it^{Ptip}P_{Ntip}(1),...,^{Ptip}P_{Ntip}(64)}, in 3D space.');
xlabel('X(mm)');
ylabel('Y(mm)');
zlabel('Z(mm)');
colormap('winter')
% set(gca,'YLim',[30 60]);%X轴的数据显示范围
% set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度

figure
pcshow(moving,'VerticalAxis','Z','MarkerSize',100);
title('The positions, {\it^{I}P_{Ntip}(1),...,^{I}P_{Ntip}(64)}, in 3D space.');
xlabel('X(mm)');
ylabel('Y(mm)');
zlabel('Z(mm)');
colormap('winter')
% set(gca,'XLim',[1 5]);%X轴的数据显示范围
% set(gca,'XTick', [1:1:5]); %设置要显示坐标刻度
% set(gca,'YLim',[30 60]);%X轴的数据显示范围
% set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度
% set(gca,'ZLim',[-4 4]);%X轴的数据显示范围
% set(gca,'ZTick', [-4:2:4]); %设置要显示坐标刻

figure
pcshowpair(fixed,movingReg,'MarkerSize',100);
legend('Truth points','Calibration points');
xlabel('X(mm)');
ylabel('Y(mm)');
zlabel('Z(mm)');


