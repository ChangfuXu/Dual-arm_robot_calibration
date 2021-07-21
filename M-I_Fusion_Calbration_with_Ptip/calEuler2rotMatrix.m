function rotMatrix = calEuler2rotMatrix(T_B_EL)
% Convert P_B_ER to coordinate transformation matrix
eul = [T_B_EL(6)*pi/180, T_B_EL(5)*pi/180, T_B_EL(4)*pi/180];
Rotation_Trans_Matrix = eul2rotm(eul,'ZYX');  % Convert Euler Angles to Rotation Matrix
% R_R_ER = angle2dcm(T_B_EL(4)*pi/180,T_B_EL(5)*pi/180,T_B_EL(6)*pi/180,'XYZ');  % Convert Angles to Rotation Matrix
% disp(R_R_ER)
rotMatrix = [Rotation_Trans_Matrix T_B_EL(1:3)'];
rotMatrix(4,:) =[0 0 0 1];
% disp(rotMatrix);
end

