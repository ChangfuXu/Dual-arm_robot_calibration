function [remove_eul_P_B_ER, remove_eul_P_B_EL, remove_eul_P_I_ITip] = remove_exception_points(eul_P_B_ER, eul_P_B_EL, eul_P_I_ITip, rotm_T_ER_NTip,rotm_T_EL_PTip)
% Function: Remove the exceptional points from eul_P_B_ER, eul_P_B_EL, eul_P_I_ITip.
% Input: eul_P_B_ER, The position of the end flange of right hand in base frame % 注意：这里是四元数表示，需要转换成转换矩阵
%        eul_P_B_EL, The position of the end flange of left hand in base frame % 注意：这里是四元数表示，需要转换成转换矩阵
%        eul_P_I_ITip, The position of the image-needle-tip in Image frame % 注意：这里是四元数表示，需要转换成转换矩阵
%        rotm_T_ER_NTip, the transformation matrix of the needle-tip to ER frame   
%        rotm_T_EL_PTip, the transformation matrix of the probe-needle-tip to EL frame
%        rotm_T_PTip_I, the transformation matrix of image to probe-needle-tip frame.
% Output: the eul_P_B_ER, eul_P_B_EL, eul_P_I_ITip that the remove the exception points 

exp_nums = length(eul_P_B_ER(:,1));
xyz_P_PTip_NTip = zeros(exp_nums,3);
for i = 1:exp_nums
    xyz_P_B_NTip_i= calEuler2rotMatrix(eul_P_B_ER(i,:)) * rotm_T_ER_NTip(:,4); %Calculate the needle-tip's positon in robot's frame	
    rotm_P_B_PTip_i =  calEuler2rotMatrix(eul_P_B_EL(i,:)) * rotm_T_EL_PTip;
    xyz_P_PTip_NTip_temp = rotm_P_B_PTip_i \ xyz_P_B_NTip_i;% the position coordinate of needle-tip to probe-tip
    xyz_P_PTip_NTip(i,:) = xyz_P_PTip_NTip_temp(1:3,1)';   
end

[a, b, c, d] = get_fit_plane(xyz_P_PTip_NTip); % fit a plane based on the oringnial points
distance = zeros(exp_nums,1); 
for i = 1 : exp_nums
    point_i = xyz_P_PTip_NTip(i,:);
    distance(i,1) = abs(a*point_i(1)+b*point_i(2)+c*point_i(3)+d)/sqrt(a^2+b^2+c^2); % Calculate the distance of each point to the plane
end
mean_distance = mean(distance); %  Calculate the mean of the all distance

%% Remove the exception points
%  Method: if the distance of a point to the plane is bigger than the  mean distance, we think this point is a exception point, then remove it.
temp_remove_eul_P_B_ER = zeros(exp_nums,6);
temp_remove_eul_P_B_EL = zeros(exp_nums,6);
temp_remove_eul_P_I_ITip = zeros(exp_nums,6);
start_index = 1;
for i = 1 : exp_nums
    if distance(i,1) < mean_distance
        temp_remove_eul_P_B_ER(start_index,:) = eul_P_B_ER(i,:);
        temp_remove_eul_P_B_EL(start_index,:) = eul_P_B_EL(i,:);
        temp_remove_eul_P_I_ITip(start_index,:) = eul_P_I_ITip(i,:);
        start_index = start_index + 1;
    end   
end
remove_eul_P_B_ER = temp_remove_eul_P_B_ER(1:start_index-1,:);
remove_eul_P_B_EL = temp_remove_eul_P_B_EL(1:start_index-1,:);
remove_eul_P_I_ITip = temp_remove_eul_P_I_ITip(1:start_index-1,:);
% disp(remove_eul_P_B_ER);
% disp(remove_eul_P_B_EL);
% disp(remove_eul_P_I_ITip);

%% Using the least squares method to fit the plane based on the points in 3D space 
function [a, b, c, d] = get_fit_plane(planeData)
% 协方差矩阵的SVD变换中，最小奇异值对应的奇异向量就是平面的方向
% x = planeData(:,1);
% y = planeData(:,2);
% z = planeData(:,3);
% scatter3(x,y,z,'filled')
% hold on;
xyz0=mean(planeData,1);
centeredPlane=bsxfun(@minus,planeData,xyz0);
[~,~,V]=svd(centeredPlane);

a=V(1,3);
b=V(2,3);
c=V(3,3);
d=-dot([a b c],xyz0);

% Figure
% xfit = min(x):1:max(x);
% yfit = min(y):2:max(y);
% [XFIT,YFIT]= meshgrid (xfit,yfit);
% ZFIT = -(d + a * XFIT + b * YFIT)/c;
% mesh(XFIT,YFIT,ZFIT);
end
end