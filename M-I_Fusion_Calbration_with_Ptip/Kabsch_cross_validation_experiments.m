%**********  Function decription ***********
% This is a leave-one-out cross-validation (LOO-CV) experiments, which is used to calculate the accuracy and precision of the calibration results of Kabsch algorithm. 
% It also calculates the Min_AE, Mean_AE, Max_AE, SD, RMSE of the calibration results. 
% Input:  eul_P_R2ER, The position of the end flange of right hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_R2EL, The position of the end flange of left hand in robotic base frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         eul_P_I2Ntip, The position of the needle-tip in Image frame % 注意：这里是欧拉角表示，需要转换成转换矩阵
%         rotm_ER2Ntip, the transformation matrix of the needle-tip to ER frame   
%         rotm_EL2Ptip, the transformation matrix of the probe-tip to EL frame
% Output: Min_AE, Mean_AE, Max_AE, SD, sRMSE.
%         sRMSE: the Root Mean Square Error of system test.
%*******************************************
function [Min_AE, Mean_AE, Max_AE, SD, sRMSE] = Kabsch_cross_validation_experiments(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip)
    exp_nums = length(eul_P_R2ER(:,1)); % Set the experimental numbers of data,which is equal to the data number. It means exp_num-fold-cross-validation
    for sample_points = exp_nums : 1: exp_nums % excute the exp_i-fold-cross-validation by order. sample_points must greater than 4.
        results = zeros(4*(exp_nums+1),5); % Initial the variable of calibration results, which is used to storage the all calibration results, accuracy and precision
        startIndex_of_results = 1;
        absolute_error_sum = 0; % initial the sum of the absolute error
        absolute_errors = zeros(sample_points,1);
        Min_AE = 1000; % initial the minimum  absolute error
        Max_AE = 0; % initial the maximum  absolute error
        for test_i = 1 : sample_points
            exp_eul_P_R2ER = eul_P_R2ER(1:sample_points,:);  % Selection the experimental data
            exp_eul_P_E2EL = eul_P_R2EL(1:sample_points,:); % Selection the experimental data
            exp_eul_P_I2Ntip = eul_P_I2Ntip(1:sample_points,:);  % Selection the experimental data
            test_eul_P_R2ER = exp_eul_P_R2ER(test_i,:);  % Selection the test data
            test_eul_P_R2EL = exp_eul_P_E2EL(test_i,:); % Selection the test data
            test_eul_P_I2Ntip = exp_eul_P_I2Ntip(test_i,:);  % Selection the test data
            exp_eul_P_R2ER(test_i,:) = []; % remove the test data
            exp_eul_P_E2EL(test_i,:) = []; % remove the test data
            exp_eul_P_I2Ntip(test_i,:) = []; % remove the test data

%             [rotm_I2PTip,rsme]= ICP_calibration(exp_eul_P_ER2R, exp_eul_P_EL2R, exp_eul_P_ITip2I,rotm_T_NTip2ER, rotm_PTip2EL, plane_type); % Get the results of calibration
            [rotm_I2PTip,rsme]= Kabsch_calibration(exp_eul_P_R2ER, exp_eul_P_E2EL, exp_eul_P_I2Ntip,rotm_ER2Ntip, rotm_EL2Ptip); % Get the results of calibration
            absolute_errors(test_i,1) = calCalibrationError(test_eul_P_R2ER, test_eul_P_R2EL, test_eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip,rotm_I2PTip);% C
            if absolute_errors(test_i,1) < Min_AE
                Min_AE = absolute_errors(test_i,1);
            end
            if absolute_errors(test_i,1) > Max_AE
                Max_AE = absolute_errors(test_i,1);
            end
            absolute_error_sum = absolute_error_sum + absolute_errors(test_i,1); % Calculate the Euclidean distance
            results(startIndex_of_results: startIndex_of_results + 3,1:4) = rotm_I2PTip;
            results(startIndex_of_results,5) = absolute_errors(test_i,1);
            startIndex_of_results = startIndex_of_results + 4;
        end
        Mean_AE = absolute_error_sum / sample_points; % Mean absolute error
    %     disp(absolute_errors);
    %     disp((absolute_errors-mean_AE).^2);
    %     disp(sum((absolute_errors-mean_AE).^2)/ exp_i);
        SD = sqrt(sum((absolute_errors-Mean_AE).^2) / sample_points); % Standard deviation
        sRMSE = sqrt(sum((absolute_errors).^2) / sample_points); % Root mean squre error

       %% Used to storage the results
        results(startIndex_of_results,5) = Min_AE;
        results(startIndex_of_results+1,5) = Mean_AE;
        results(startIndex_of_results+2,5) = Max_AE;
        results(startIndex_of_results+3,5) = SD;
        results(startIndex_of_results+4,5) = sRMSE;
    %     startIndex_of_results = startIndex_of_results + 4;
        disp("*** Kabsch algorithm: Exp.data = "+ sample_points + ": Min_AE, Mean_AE, Max_AE, SD, sRMSE ***");
        disp([Min_AE, Mean_AE, Max_AE, SD, sRMSE]);
        sheetfile  = ['Sheet',num2str(sample_points)];
        xlswrite("Exp_results\Kabsch_Accuracy_20200807", roundn(results,-4),sheetfile); % write the result to xls
    end    
end