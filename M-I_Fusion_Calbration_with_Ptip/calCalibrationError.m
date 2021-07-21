% *** Implementation of the calCalibrationError function *****
% Function: Test the calbration error of Calibration Results (rotm_P_PTip_I)
% Input: test_data,consist of eul_P_B_ER,eul_P_B_EL and eul_P_I_ITip.
%        eul_P_B_ER, The position of the end flange of right hand in base frame % 注意：这里是四元数表示，需要转换成转换矩阵
%        eul_P_B_EL, The position of the end flange of left hand in base frame % 注意：这里是四元数表示，需要转换成转换矩阵
%        eul_P_I_ITip, The position of the image-needle-tip in Image frame % 注意：这里是四元数表示，需要转换成转换矩阵}
%        rotm_T_ER_NTip, the transformation matrix of the needle-tip to ER frame   
%        rotm_T_EL_PTip, the transformation matrix of the probe-needle-tip to EL frame
%        rotm_T_PTip_I, the transformation matrix of image to probe-needle-tip frame.
% Output: Calibration Error (absolute error), ||real_P_Ntip2R - cal_P_Ntip2R||
function calibrationError = calCalibrationError(eul_P_B_ER, eul_P_B_EL, eul_P_I_ITip, rotm_T_ER_NTip,rotm_T_EL_PTip,rotm_T_PTip_I)
    real_P_Ntip2R =  calEuler2rotMatrix(eul_P_B_ER) * rotm_T_ER_NTip(:,4); %Calculate the needle-tip's positon in robot's frame
    xyz_P_I_ITip = [eul_P_I_ITip(1,1);eul_P_I_ITip(1,2);0;1]; % Turn the eul position to rotation transformation matrix  
    rotm_P_B_PTip =  calEuler2rotMatrix(eul_P_B_EL) * rotm_T_EL_PTip;% Calculate the probe-needle-tip's positon in robot's frame        
    cal_P_Ntip2R = rotm_P_B_PTip * rotm_T_PTip_I * xyz_P_I_ITip;%Calculate the position of needle-tip in image to robot frame in testing experiment. 
    calibrationError = sqrt((real_P_Ntip2R-cal_P_Ntip2R)' * (real_P_Ntip2R-cal_P_Ntip2R));
end