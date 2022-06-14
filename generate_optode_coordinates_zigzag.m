clc
clear all
close all

data_path = 'H:\Project\Current_Jobs\fNIRS\Drawings\';

save_output = true;
fig_size = [20 8];
marker_size = 10;
line_width = 2;

normDist = 30; % mm (according to Oxysoft optode template)

R_T_comb = [1 1
    1 2
    1 9
    1 10
    2 2
    2 3
    2 8
    2 9
    3 3
    3 4
    3 7
    3 8
    4 4
    4 5
    4 6
    4 7
    5 5
    5 6
    6 6
    6 7
    6 8
    ];

T1x_left  =  [-78.3 -12.2]';
T2x_left  =  [-52.0 2.0]';
T3x_left  =  [-25.3 15.6]';
T4x_left  =  [1.4 29.8]';
T5x_left  =  [28.0 43.6]';
T6x_left  =  [51.9 -2.4]';
T7x_left  =  [25.8 -16.93]';
T8x_left  =  [-1.3 -30.1]';
T9x_left  =  [-27.5 -44.1]';
T10x_left =  [-54.5 -58.5]';

R1x_left = [-54.0 -28.0]';
R2x_left = [-26.8 -14.6]';
R3x_left = [0.0 0.0]';
R4x_left = [26.4 13.4]';
R5x_left = [53.0 27.4]';
R6x_left = [30.3 -26.1]';

Tx_all_left = [-78.3   -12.2
                -52.0   2.0
                -25.3   15.6
                1.4 	29.8
                28.0	43.6
                51.9	-2.4
                25.8	-16.93
                -1.3	-30.1
                -27.5   -44.1
                -54.5   -58.5]';

Rx_all_left = [-54.0  -28.0
               -26.8  -14.6
               0.0    0.0
               26.4   13.4
               53.0   27.4
               30.3   -26.1]';

dummy_optodes_left = [-6.9   9.3
                      -51   -55
                      60    30]';
                  
dummy_optode_locations_left = {'C5', 'F9', 'P3'};
dummy_optode_locations_right = {'C6', 'F10', 'P4'};           
           
% x-positions should be negated for the right side
Tx_all_right = Tx_all_left;
Tx_all_right(1, :) = -Tx_all_right(1, :);

Rx_all_right = Rx_all_left;
Rx_all_right(1, :) = -Rx_all_right(1, :);

dummy_optodes_right = dummy_optodes_left;
dummy_optodes_right(1, :) = -dummy_optodes_right(1, :);

R_comb = R_T_comb(:, 1);
T_comb = R_T_comb(:, 2);

% x- and y-positions of Rx's
R_xPos_left = Rx_all_left(1, R_comb);
R_yPos_left = Rx_all_left(2, R_comb);

% x- and y-positions of Tx's
T_xPos_left = Tx_all_left(1, T_comb);
T_yPos_left = Tx_all_left(2, T_comb);

% x- and y-positions of Rx's
R_xPos_right = Rx_all_right(1, R_comb);
R_yPos_right = Rx_all_right(2, R_comb);

% x- and y-positions of Tx's
T_xPos_right = Tx_all_right(1, T_comb);
T_yPos_right = Tx_all_right(2, T_comb);

% normalized Rx-Tx distance (to be used for defining optode template in Oxysoft)
Tx_all_left_normDist = Tx_all_left ./normDist;
Rx_all_left_normDist = Rx_all_left ./normDist;
Tx_all_right_normDist = Tx_all_right ./normDist;
Rx_all_right_normDist = Rx_all_right ./normDist;

table_left_oxysoft = table(R_T_comb(:, 1), R_T_comb(:, 2), 'VariableNames', {'Rx'; 'Tx'});

h = figure;
set(h, 'Units', 'centimeters', 'Position', [2 2 fig_size],...
'PaperUnits', 'centimeters', 'PaperPosition', [0 0 fig_size], 'PaperSize', fig_size);
subplot(121);
line([R_xPos_left; T_xPos_left], [R_yPos_left; T_yPos_left], 'Color', 'g', 'LineWidth', line_width);
hold on

plot(Tx_all_left(1, :), Tx_all_left(2, :), 'or', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
plot(Rx_all_left(1, :), Rx_all_left(2, :), 'ob', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b');
plot(dummy_optodes_left(1, :), dummy_optodes_left(2, :), 'ok', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k');

text(-5+dummy_optodes_left(1, :)', 10+dummy_optodes_left(2, :)', dummy_optode_locations_left);

axis equal
set(gca, 'Box', 'on');
xlabel('X position (mm)');
ylabel('Y position (mm)');
title('Left');

axis([-90 70 -70 60]);

subplot(122);
line([R_xPos_right; T_xPos_right], [R_yPos_right; T_yPos_right], 'Color', 'g', 'LineWidth', line_width);
hold on

plot(Tx_all_right(1, :), Tx_all_right(2, :), 'or', 'MarkerSize', marker_size, 'MarkerFaceColor', 'r');
plot(Rx_all_right(1, :), Rx_all_right(2, :), 'ob', 'MarkerSize', marker_size, 'MarkerFaceColor', 'b');
plot(dummy_optodes_right(1, :), dummy_optodes_right(2, :), 'ok', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k');
text(-5+dummy_optodes_right(1, :)', 10+dummy_optodes_right(2, :)', dummy_optode_locations_right);

axis equal
set(gca, 'Box', 'on');
xlabel('X position (mm)');
ylabel('Y position (mm)');
title('Right');

axis([-70 90 -70 60]);

if save_output
    print([data_path 'optode_config_zigzag'], '-dpng', '-r600');
end
