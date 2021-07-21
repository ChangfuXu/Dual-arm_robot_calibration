% Fucntion: Storage the transformation matrix of the needle-tip to ER frame
% Input: needle_dis_num, the distance number of the needle forward movement  
% Output: rotm_ER2Ntip,the transformation matrix of the needle-tip to ER
% frame in different distance of the needle forward movement.
 
function rotm_ER2Ntip = get_rotm_ER2Ntip(needle_dis)
 all_rotm_ER2Ntip = {
    % distance = 0 mm. The data format:  x£¨mm£© y£¨mm£© z£¨mm£© rx(deg.) ry(deg.) rz(deg.)
    [ 0.9263	-0.2257	0.2865  1.6566;
    0.2182	0.9691	0.0586  -118.568;
    -0.2909	0.0083	0.9563  384.6423;
    0   0   0   1
    ];	   	
	% distance = 10 mm	
    [ 0.9263	-0.2257	0.2865  1.7086;
    0.2182	0.9691	0.0586  -118.7493;
    -0.2909	0.0083	0.9563  394.6899;
    0   0   0   1
    ];
    % distance = 20 mm
    [ 0.9263	-0.2257	0.2865  1.6368; % the better
    0.2182	0.9691	0.0586  -118.4255;
    -0.2909	0.0083	0.9563  404.6173;
    0   0   0   1
    ];
%     [ 0.9263	-0.2257	0.2865  1.9945;
%     0.2182	0.9691	0.0586  -118.6642;
%     -0.2909	0.0083	0.9563  404.596;
%     0   0   0   1
%     ];
    % distance = 30 mm		
    [ 0.9263	-0.2257	0.2865  1.9121;
    0.2182	0.9691	0.0586  -118.1376;
    -0.2909	0.0083	0.9563  414.4022;
    0   0   0   1
    ];
    % distance = 40 mm
    [ 0.9263	-0.2257	0.2865  1.8864;
    0.2182	0.9691	0.0586  -118.089;
    -0.2909	0.0083	0.9563  424.6139;
    0   0   0   1
    ];  		
    % distance = 50 mm
    [ 0.9263	-0.2257	0.2865  2.0823;
    0.2182	0.9691	0.0586  -118.2739;
    -0.2909	0.0083	0.9563  434.7544;
    0   0   0   1
    ]
    };

rotm_ER2Ntip = all_rotm_ER2Ntip{needle_dis/10+1};

end
