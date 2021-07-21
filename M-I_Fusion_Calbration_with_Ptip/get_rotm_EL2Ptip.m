% Fucntion: Storage the transformation matrix of  the US probe-needle-tip to EL frame
% Input: probe_dis_num, the distance number of the US probe forward movement
% Output: rotm_EL2Ptip, the transformation matrix of the US probe-needle-tip to EL frame.

function rotm_EL2Ptip = get_rotm_EL2Ptip(probe_dis)
all_rotm_EL2Ptip = {
    % distance = 0 mm. Data formal: x£¨mm£© y£¨mm£© z£¨mm£© rx(deg.) ry(deg.) rz(deg.       
%     [-0.9498	0.1685	-0.2633 11.5847;
%     -0.1659	-0.9855	-0.0325 42.3478;
%     -0.2649	0.0128	0.9642  404.89;
%     0 0 0 1
%     ];
    [-0.9498	0.1685	-0.2633 10.9615; % the new result
    -0.1659	-0.9855	-0.0325 43.8911;
    -0.2649	0.0128	0.9642  404.7311;
    0 0 0 1
    ];

    % distance = 10 mm
    [-0.9498	0.1685	-0.2633 10.9131;
    -0.1659	-0.9855	-0.0325 42.2937;
    -0.2649	0.0128	0.9642  415.0286;
    0 0 0 1
    ];
    % distance = 20 mm  
    [-0.9498	0.1685	-0.2633 10.7086;
    -0.1659	-0.9855	-0.0325 42.3571;
    -0.2649	0.0128	0.9642  424.8227;
    0 0 0 1
    ];    
    % distance = 30 mm   
    [-0.9498	0.1685	-0.2633 9.5709;
    -0.1659	-0.9855	-0.0325 40.0437;
    -0.2649	0.0128	0.9642  434.9154;
    0 0 0 1
    ];
    % distance = 40 mm
    [-0.9498	0.1685	-0.2633 10.2901;
    -0.1659	-0.9855	-0.0325 41.6922;
    -0.2649	0.0128	0.9642  444.6861;
    0 0 0 1
    ];
    % distance = 50 mm
    [-0.9498	0.1685	-0.2633 8.6375;
    -0.1659	-0.9855	-0.0325 41.3672;
    -0.2649	0.0128	0.9642  454.7796;
    0 0 0 1
    ];
%     [-0.9498	0.1685	-0.2633 10.5442;
%     -0.1659	-0.9855	-0.0325 42.5591;
%     -0.2649	0.0128	0.9642  454.6978;
%     0 0 0 1
%     ];
     };
 rotm_EL2Ptip = all_rotm_EL2Ptip{probe_dis/10 + 1};
%  disp("rotm_P_EL_PTip: "+ rotm_P_EL_PTip);
end

