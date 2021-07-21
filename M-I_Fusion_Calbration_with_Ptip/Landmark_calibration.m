% *** Implementation of the calCalibrationError function *****
% Function: Calibration the transformation matrix of image frame relative to probe-tip frame (tform_T2Ptip).
% Method: The Landmark algorithm is adopted to resolve the transformation matrix.
% Input:  eul_P_R2ER, The position of the end flange of right hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_R2EL, The position of the end flange of left hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_I2Ntip, The position of the needle-tip in Image frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         rotm_ER2Ntip, the transformation matrix of the needle-tip to ER frame   
%         rotm_EL2Ptip, the transformation matrix of the probe-tip to EL frame
%         rotm_Ptip2I, the transformation matrix of the I to Ptip frame by using C++ program.
% Output: tform_Ptip2I, the transformation matrix of image frame to probe-tip frame.
%         reg_rmse, the least Root Mean Square Error of registration.
function [tform_Ptip2I, reg_rmse] = Landmark_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip, rotm_Ptip2I)
%% Use the Landmark to calibration the transformation matrix of image to probe-needle-tip frame (tform_T2Ptip).
tform_Ptip2I = rotm_Ptip2I(257:260, 1:4);
exp_nums = length(eul_P_R2ER(:,1));
registration_errors = zeros(exp_nums,1);
for test_i = 1:exp_nums
    registration_errors(test_i,1) = calCalibrationError(eul_P_R2ER(test_i,:), eul_P_R2EL(test_i,:), eul_P_I2Ntip(test_i,:), rotm_ER2Ntip, rotm_EL2Ptip, tform_Ptip2I);   
end
reg_rmse = sqrt(sum((registration_errors).^2) / exp_nums); % Root mean squre error of the registration

end
