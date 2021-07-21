% *** Implementation of the calCalibrationError function *****
% Function: Calibration the transformation matrix of Image frame relative to Probe-tip frame (tform_Ptip2I).
% Method: The iteration closest point (ICP) algorithm is adopted to resolve the transformation matrix.
% Input:  eul_P_R2ER, The position of the end flange of right hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_R2EL, The position of the end flange of left hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_I2Ntip, The position of the needle-tip in Image frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         rotm_ER2Ntip, the transformation matrix of the needle-tip to ER frame   
%         rotm_EL2Ptip, the transformation matrix of the probe-tip to EL frame
% Output: tform_Ptip2I, the transformation matrix of image frame to probe-tip frame.
%         reg_rmse, the Root Mean Square Error of registration.
function [tform_Ptip2I, reg_rmse] = ICP_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip, plane_type)
%% Use the ICP to calibration the transformation matrix of image to probe-needle-tip frame.
exp_nums = length(eul_P_R2ER(:,1));
xyz_P_Ptip2Ntip = zeros(exp_nums,3);
xyz_P_R2Ntip = zeros(exp_nums,3);
for i = 1:exp_nums
    xyz_P_R2Ntip_i= calEuler2rotMatrix(eul_P_R2ER(i,:)) * rotm_ER2Ntip(:,4); %Calculate the needle-tip's positon in robot's frame
    xyz_P_R2Ntip(i,:) = xyz_P_R2Ntip_i(1:3,1)';
    rotm_P_R2Ptip_i =  calEuler2rotMatrix(eul_P_R2EL(i,:)) * rotm_EL2Ptip;
    xyz_P_Ptip2Ntip_temp = rotm_P_R2Ptip_i \ xyz_P_R2Ntip_i;% the position coordinate of needle-tip to probe-tip
    xyz_P_Ptip2Ntip(i,:) = xyz_P_Ptip2Ntip_temp(1:3,1)';   
end
fixed = pointCloud(xyz_P_Ptip2Ntip); % Use the xyz_P_NTip2PTip  coordinate as fixed points with point cloud format
moving  = pointCloud(eul_P_I2Ntip(:,1:3)); % Use the xyz_P_NTip2PTip coordinate as moving points with point cloud format
% disp(fixed.Location);
% disp(moving.Location);
if plane_type == 'S' % Set the initial matrix of S-plane calibration
    A = [
        0   0   1  28;
        0   -1  0  20;
        1   0   0  -33;
        0   0   0   1];
else % Set the initial matrix of T-plane calibration
    A = [
    1   0   0  -25;
    0   -1  0  15;
    0   0   -1  -18;
    0   0   0   1];
end
A = A';
InitTransf = affine3d(A);
% [tform, movingReg, frmse]= pcregistericp(moving,fixed,'MaxIterations',30, 'Tolerance',[0.01,0.01]);
[tform, movingReg, reg_rmse]= pcregistericp(moving,fixed,'InitialTransform',InitTransf ,'MaxIterations',30, 'Tolerance',[0.01,0.01]);% Calling the ICP function
tform_Ptip2I = (tform.T)';

% disp("Registration points");
% disp(movingReg.Location);
% disp("tform_T_Ptip2I");
% disp(tform_Ptip2I);

% figure
% xyz_P_NTip2R_cp = pointCloud(xyz_P_R2Ntip);
% pcshow(xyz_P_NTip2R_cp,'VerticalAxis','X','VerticalAxisDir','Up','MarkerSize',50);
% title('The positions, {\it^{B}P_{Ntip}(1),...,^{B}P_{Ntip}(30)}, in 3D space.');
% xlabel('X(mm)');
% ylabel('Y(mm)');
% zlabel('Z(mm)');
% colormap('winter')
% % set(gca,'YLim',[30 60]);%X轴的数据显示范围
% % set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度
% 
% figure
% pcshow(fixed,'VerticalAxis','X','VerticalAxisDir','Up','MarkerSize',50);
% title('The positions, {\it^{Ptip}P_{Ntip}(1),...,^{Ptip}P_{Ntip}(30)}, in 3D space.');
% xlabel('X(mm)');
% ylabel('Y(mm)');
% zlabel('Z(mm)');
% colormap('winter')
% % set(gca,'YLim',[30 60]);%X轴的数据显示范围
% % set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度
% 
% figure
% pcshow(moving,'VerticalAxis','Z','MarkerSize',50);
% title('The positions, {\it^{I}P_{Ntip}(1),...,^{I}P_{Ntip}(30)}, in 3D space.');
% xlabel('X(mm)');
% ylabel('Y(mm)');
% zlabel('Z(mm)');
% colormap('winter')
% % set(gca,'XLim',[1 5]);%X轴的数据显示范围
% % set(gca,'XTick', [1:1:5]); %设置要显示坐标刻度
% % set(gca,'YLim',[30 60]);%X轴的数据显示范围
% % set(gca,'YTick', [30:5:60]); %设置要显示坐标刻度
% % set(gca,'ZLim',[-4 4]);%X轴的数据显示范围
% % set(gca,'ZTick', [-4:2:4]); %设置要显示坐标刻
% 
% figure
% pcshowpair(fixed,movingReg,'MarkerSize',50);
% legend('Truth points','Calibration points');
% xlabel('X(mm)');
% ylabel('Y(mm)');
% zlabel('Z(mm)');

% disp("ICP_frmse:"+rmse);
% Plot RMS curve
% hold on;
% figure
% plot(2:length(rmse),frmse(2:length(rmse),1),'--*','MarkerSize',15);
% xlabel('Iteration number');
% ylabel('RMSE');
end
