%**********  Function decription ***********
% (1) Calibration the transformation matrix of US-image frame relative to probe-tip frame (rotm_Ptip2I)
% (2) Use the cross-validation method to test the effectiveness of the calibration approach
%  Notice: US-image includes the S-plane and T-plane, respectively.
%*******************************************

clear;clc;% clear the variables and functions from memory
tic;
%% Calculate the resolution ratio of ultrasound image in our experiments
sy = 50 / 518; % Calculate y-axis resolution ratio of ultrasound image when the scan-depth of US-image is 50 mm.
sx = sy; % resolution ratio of x-axis is equal to the x-axis
plane_type = 'S'; % Please select that which one is the calibration plane. S or T.
needle_dis_i = 20; % the distance number of the needle forward movement
probe_dis_i = 0; % the distance number of the US probe forward movement

%% Read the sample data
input_file_name = {'Exp_sample_data\2020_0517\ER_data.xlsx', 'Exp_sample_data\2020_0517\EL_data.xlsx', 'Exp_sample_data\2020_0517\ImageTip_data.xlsx'};  % S-plane data
% input_file_name = {'Exp_sample_data\2020_0520\ER_data.xlsx', 'Exp_sample_data\2020_0520\EL_data.xlsx', 'Exp_sample_data\2020_0520\ImageTip_data.xlsx'}; % T-plane data
rotm_ER2Ntip = get_rotm_ER2Ntip(needle_dis_i);% Get the transformation matrix of the needle-tip to ER frame   
rotm_EL2Ptip = get_rotm_EL2Ptip(probe_dis_i);%  Get the transformation matrix of the probe-needle-tip to EL frame
eul_P_R2ER = xlsread(input_file_name{1},num2str(needle_dis_i)); % the position of ER to R frame by euler angle
eul_P_R2EL = xlsread(input_file_name{2},num2str(probe_dis_i)); % the position of EL to R frame by euler angle
eul_P_I2Ntip = xlsread(input_file_name{3},strcat(num2str(needle_dis_i),num2str(probe_dis_i))); % the position of Ntip to I frame by euler angle
eul_P_I2Ntip = eul_P_I2Ntip * sx; % Turn the pixel to millimeter
all_Landmark_rotm_I2PTip = xlsread('Exp_sample_data\Landmark_rotm_I2PTip.xlsx');% read the input data of Landmark registration algorithm
% [eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip] = remove_exception_points(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip); % Remove the exceptional points

%% Calibration the transformation matrix of image frame relative to probe-tip frame (rotm_T_PTip_I)
[ICP_rotm_Ptip2I,ICP_reg_rsme]= ICP_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip, plane_type); % Get the results of calibration with ICP algorithm.
% [Kabsch_rotm_Ptip2I,Kabsch_reg_rsme]= Kabsch_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip); % Get the results of calibration with Kabsch algorithm.
% [Landmark_rotm_Ptip2I,Landmark_reg_rsme]= Landmark_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip, all_Landmark_rotm_I2PTip); % Get the results of calibration with Landmark algorithm.
toc;
disp("*** ICP algorithm: Coordinate transformation matrix of the I frame to Ptip frame, and regRMSE ***");
disp(ICP_rotm_Ptip2I);
% disp(ICP_reg_rsme(end));
% disp("*** Kabsch algorithm: Coordinate transformation matrix of the I frame to Ptip frame, and regRMSE ***");
% disp(Kabsch_rotm_Ptip2I);
% disp(Kabsch_reg_rsme);
% 
% disp("*** Landmark algorithm: Coordinate transformation matrix of the I frame to Ptip frame, and regRMSE ***");
% disp(Landmark_rotm_Ptip2I);
% disp(Landmark_reg_rsme);
% 
% disp("*** Coordinate transformation matrix of the I frame to EL frame ***");
% disp(rotm_EL2Ptip*ICP_rotm_Ptip2I);

%% Use the cross-validation method to test the effectiveness of the calibration approach 
% [Min_AE, Mean_AE, Max_AE, SD, sRMSE] = ICP_cross_validation_experiments(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip, plane_type);
% [Min_AE, Mean_AE, Max_AE, SD, sRMSE] = Kabsch_cross_validation_experiments(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip);
% [Min_AE, Mean_AE, Max_AE, SD, sRMSE] = Landmark_cross_validation_experiments(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip,all_Landmark_rotm_I2PTip);
% [Min_AE, Mean_AE, Max_AE, SD, sRMSE] = cross_validation_experiments_random(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip,plane_type);
