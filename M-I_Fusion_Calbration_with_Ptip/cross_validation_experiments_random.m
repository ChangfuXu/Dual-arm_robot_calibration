%**********  Function decription ***********
% This is a cross-validation experiments, which is used to calculate the accuracy and precision of the calibration results. 
% It also calculates the Min_AE, Mean_AE, Max_AE, SD, RMSE of the calibration results. 
% Notice: Select the random data from the sample data  and then used to test
%*******************************************
function [Min_AE, Mean_AE, Max_AE, SD, RMSE] = cross_validation_experiments_random(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip, rotm_EL2Ptip, plane_type)
    exp_num = length(eul_P_R2ER(:,1)); % Set the experimental numbers of data,which is equal to the data number. It means exp_num-fold-cross-validation
    for exp_i = 55 : 3: 55  % excute the exp_i-fold-cross-validation by order
        results = zeros(4*65,5); % Initial the variable of calibration results, which is used to storage the all calibration results, accuracy and precision
        startIndex_of_results = 1;
        absolute_error_sum = 0; % initial the sum of the absolute error
        absolute_errors = zeros(exp_i,1);
        Min_AE = 1000; % initial the minimum  absolute error
        Max_AE = 0; % initial the maximum  absolute error
        exp_index = unidrnd(64,1,exp_i); % General the rangdom integer of range [1,64]
        exp_eul_P_R2ER_temp = zeros(exp_i,6);
        exp_eul_P_R2EL_temp = zeros(exp_i,6);
        exp_eul_P_I2Ntip_temp = zeros(exp_i,6);
        for  exp_j = 1 : exp_i
           exp_eul_P_R2ER_temp(exp_j,:) =  eul_P_R2ER(exp_index(1,exp_j),:);
           exp_eul_P_R2EL_temp(exp_j,:) =  eul_P_R2EL(exp_index(1,exp_j),:);
           exp_eul_P_I2Ntip_temp(exp_j,:) =  eul_P_I2Ntip(exp_index(1,exp_j),:);      
        end    
        for test_i = 1 : exp_i       
            exp_eul_P_R2ER = exp_eul_P_R2ER_temp(1:exp_i,:);  % Selection the experimental data
            exp_eul_P_R2EL = exp_eul_P_R2EL_temp(1:exp_i,:); % Selection the experimental data
            exp_eul_P_I2Ntip = exp_eul_P_I2Ntip_temp(1:exp_i,:);  % Selection the experimental data
            test_eul_P_R2ER = exp_eul_P_R2ER(test_i,:);  % Selection the test data
            test_eul_P_R2EL = exp_eul_P_R2EL(test_i,:); % Selection the test data
            test_eul_P_I2Ntip = exp_eul_P_I2Ntip(test_i,:);  % Selection the test data
            exp_eul_P_R2ER(test_i,:) = []; % remove the test data
            exp_eul_P_R2EL(test_i,:) = []; % remove the test data
            exp_eul_P_I2Ntip(test_i,:) = []; % remove the test data
            
            [rotm_Ptip2I,ICP_reg_rsme]= ICP_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip, plane_type); % Get the results of calibration with ICP algorithm.
%             [rotm_Ptip2I,Kabsch_reg_rsme]= Kabsch_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip); % Get the results of calibration with Kabsch algorithm.
%             [rotm_Ptip2I,Landmark_reg_rsme]= Landmark_calibration(eul_P_R2ER, eul_P_R2EL, eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip, all_Landmark_rotm_I2PTip); % Get the results of calibration with Landmark algorithm.
            absolute_errors(test_i,1) = calCalibrationError(test_eul_P_R2ER, test_eul_P_R2EL, test_eul_P_I2Ntip, rotm_ER2Ntip,rotm_EL2Ptip,rotm_Ptip2I);
            if absolute_errors(test_i,1) < Min_AE
                Min_AE = absolute_errors(test_i,1);
            end
            if absolute_errors(test_i,1) > Max_AE
                Max_AE = absolute_errors(test_i,1);
            end
            absolute_error_sum = absolute_error_sum + absolute_errors(test_i,1); % Calculate the Euclidean distance
            results(startIndex_of_results: startIndex_of_results + 3,1:4) = rotm_Ptip2I;
            results(startIndex_of_results,5) = absolute_errors(test_i,1);
            startIndex_of_results = startIndex_of_results + 4;
        end
        Mean_AE = absolute_error_sum / exp_i;% Mean absolute error
    %     disp(absolute_errors);
    %     disp((absolute_errors-mean_AE).^2);
    %     disp(sum((absolute_errors-mean_AE).^2)/ exp_i);
        SD = sqrt(sum((absolute_errors-Mean_AE).^2) / exp_i);% Standard deviation
        RMSE = sqrt(sum((absolute_errors).^2) / exp_i);% Root mean squre error

        %% Used to storage the results
        results(startIndex_of_results,5) = Min_AE;
        results(startIndex_of_results+1,5) = Mean_AE;
        results(startIndex_of_results+2,5) = Max_AE;
        results(startIndex_of_results+3,5) = SD;
        results(startIndex_of_results+4,5) = RMSE;
    %     startIndex_of_results = startIndex_of_results + 4;
        disp("*** Exp.data = "+ exp_i + ": Min_AE, Mean_AE, Max_AE, SD, RMSE ***");
        disp([Min_AE, Mean_AE, Max_AE, SD, RMSE]);
        sheetfile  = ['Sheet',num2str(exp_i)];
        xlswrite("Exp_results\Accuracy_20200824_random", roundn(results,-4),sheetfile); % write the result to result20200506_1.xls
    end
end