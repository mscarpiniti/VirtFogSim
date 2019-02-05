% Setting all the global variables for DAG #12
%
% DAG #12 describes a bioinformatics sRNA Indentification Protocol workflow 
% with V = 31 tasks.
%
%  ***************************************************
%  * Package: VirtFogSim                             *
%  * Author: Enzo Baccarelli and Michele Scarpiniti  *
%  * Date: January, 2019                             *
%  * Version: 4.0                                    *
%  ***************************************************
%


fprintf('..DAG #12..');

%--------------------------------------------------------------------------
% Begin the declaration of the 61 global variables
 
global V
global s
global A
global Da
global n_M
global n_F
global n_C
global NF_WiFi
global NF_CELL
global NF_WD
global f_MAX_M
global f_MAX_F
global f_MAX_C
global R_MAX_U 
global R_MAX_D
global B_MAX_U
global B_MAX_D
global TH_MIN_0
global Teta_M
global Teta_F
global Teta_C
global P_IDLE_CPU_M
global P_IDLE_CPU_F
global P_IDLE_CPU_C
global nc_M
global nc_F
global nc_C
global gamma_M
global gamma_F
global gamma_C
global K_M
global K_F
global K_C
global r_M
global r_F
global r_C
global P_IDLE_ETH
global P_IDLE_WiFi_M
global P_IDLE_CELL_M
global zeta_TX_WiFi
global zeta_RX_WiFi
global zeta_TX_CELL
global zeta_RX_CELL
global eta
global RTT_WiFi
global RTT_CELL
global RTT_WD
global MSS
global Prob_LOSS
global chi_TX_WiFi
global chi_RX_WiFi
global chi_TX_CELL
global chi_RX_CELL
global I_MAX
global a_max
global no_HOP
global P_HOP
global PS
global CF
global G_MAX
global MN
global iteration_number
global jump1_WiFi
global jump1_CELL
global jump2_WiFi
global jump2_CELL
global a_max_vec_FT 
% End of the declaration of 61 global variables
%-----------------------------------------------------------------------

%--------------------------------------------------------------------------
% BEGIN THE SETUP OF 61 INPUT PARAMETERS: TO BE PERFORMED BY THE USER
%
V = 31;  % Positive scalar integer value. It is the number of tasks of the 
        % application DAG. It must be: V >= 3.
%
% Constants used to scale the workload
c1 = 1e+3;
c2 = 1e+3;
%
k1 = 2.0;
% k1 = 1;
% k1 = 0.5;
k2 = 1;
%
s = k1*c1*[5, 60, 100, 50, 65, 65, 50, 50*ones(1,15), 70, 170, 60, 60, 40, 55, 55, 40, 5]; %DAG_B (SIPHT Bioinformatics workflow)
% (1xV) row vector of the sizes of the tasks of the application DAG. 
% Each entry is a non-negative real number and it is measured in (bit). 
%
A = [0, 1, 1, zeros(1,28);          %DAG_B (SIPHT Bioinformatics workflow)
     0, 0, 0, ones(1,4), zeros(1,24);
     zeros(1,7), ones(1,15), zeros(1,9);
     zeros(1,22), 1, zeros(1,8);
     zeros(1,22), 1, zeros(1,8);
     zeros(1,22), 1, zeros(1,8);
     zeros(1,22), 1, zeros(1,8);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,23), 1, zeros(1,7);
     zeros(1,24), 1,  1, 1, 1, 1, 0, 0;
     zeros(1,30), 1;
     zeros(1,25), 1, zeros(1,5); 
     zeros(1,29), 1, 0;
     zeros(1,29), 1, 0;
     zeros(1,29), 1, 0;
     zeros(1,29), 1, 0;
     zeros(1,30), 1;
     zeros(1,31)];
% (VxV) binary (i.e,(0,1)) adjacency matrix of the application DAG.
% a(i,j)=1 (resp., a(i,j)=0) means that there is (resp., there is not) 
% a DIRECTED edge FROM node i TO node j in the application DAG. 
%
Da = k2*c2*[0, 260, 10, zeros(1,28);          %DAG_B (SIPHT Bioinformatics workflow)
     0, 0, 0, 12, 12, 12, 12, zeros(1,24);
     zeros(1,7), 10*ones(1,15), zeros(1,9);
     zeros(1,22), 40, zeros(1,8);
     zeros(1,22), 80, zeros(1,8);
     zeros(1,22), 40, zeros(1,8);
     zeros(1,22), 40, zeros(1,8);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,23), 15, zeros(1,7);
     zeros(1,24), 58, 42, 96, 96, 40, 0, 0;
     zeros(1,30), 10;
     zeros(1,25), 50, zeros(1,5); 
     zeros(1,29), 40, 0;
     zeros(1,29), 80, 0;
     zeros(1,29), 80, 0;
     zeros(1,29), 40, 0;
     zeros(1,30), 135;
     zeros(1,31)];
% (VxV) non-negative real-valued matrix of the labels of the edges 
% of the application DAG. Specifically, d(i,j) is the label of the DIRECTED
% edge FROM node i TO node j in the application DAG. It represents the 
% volume of the data that node i GIVES in input TO node j. 
% Each entry of the Da matrix is measured in (bit). 
% If there is NOT a DIRECTED edge FROM node i TO node j in the 
% application DAG, THEN d(i,j) = 0 (bit).    
%
n_M = 1; % It is a scalar positive integer, i.e., n_M >= 1. It is the 
         % number of the (virtual) computing cores that equip 
         % the Mobile device. 
%
n_F = 4; % It is a scalar positive integer,i.e., n_F >= 1. It is the number
         % of the (virtual) computing cores that equip the device clone 
         % at the Fog node. 
%
n_C = 12; % It is a scalar positive integer, i.e., n_C >= 1. It is the number
         % of (virtual) computing cores that equip the device clone 
         % at the Cloud node. Typically, 1 <= n_M <= n_F <= n_C. 
%
%
NF_WiFi = 1.1; % Scalar non-negative real-valued parameter, i.e., 
               % NF_WiFi >= 0. It represents the average per-connection 
               % number of failures of the WiFi-supported uni-directional 
               % TCP/IP connections: Mobile -> Fog and Fog -> Mobile. 
%
NF_CELL = 0.1; % Scalar non-negative real-valued parameter, i.e., 
               % NF_CELL >= 0. It represents the average per-connection 
               % number of failures of the cellular uni-directional 
               % TCP/IP connections: Mobile -> Cloud and Cloud -> Mobile. 
%
NF_WD = 0.01; % Scalar non-negative real-valued parameter, i.e., 
              % NF_WD >= 0. It represents the average per-connection number 
              % of failures of the fixed uni-directional TCP/IP backbone 
              % connections: Cloud -> Fog and Fog -> Cloud. 
              % Typically, 0 <= NF_WD < NF_CELL < NF_WiFi. 
%
f_MAX_M = 12e+6;  % Per-core maximum computing frequency at the Mobile device. 
                  % It is measured in (bit/sec).
%
f_MAX_F = 12e+6;  % Per-core maximum computing frequency at the Fog clone. 
                  % It is measured in (bit/sec). 
                  % Typically, f_MAX_F >= 10 x f_MAX_M. 
%
f_MAX_C = 12e+6;  % Per-core maximum computing frequency at the Cloud clone. 
                  % It is measured in (bit/sec). 
                  % Typically, f_MAX_C >= 100 x f_MAX_M. 
%
R_MAX_U = 8.0e+6; % Maximum bit rate of the WiFi-based unidirectional 
                  % TCP/IP connection: Mobile -> Fog. 
                  % It is measured in (bit/sec).
%
R_MAX_D = 9.0e+6; % Maximum bit rate of the WiFi-based unidirectional 
                  % TCP/IP connection: Fog -> Mobile. 
                  % It is measured in (bit/sec).
%
B_MAX_U = 6.5e+6; % Maximum bit rate of the 3G/4G cellular unidirectional 
                  % TCP/IP connection: Mobile -> Cloud. 
                  % It is measured in (bit/sec).
%
B_MAX_D = 7.0e+6; % Maximum bit rate of the 3G/4G cellular unidirectional 
                  % TCP/IP connection: Cloud -> Mobile. 
                  % It is measured in (bit/sec).
%
% Typically, 
% B_MAX_U(3G) = 2 x 10^6 (bit/sec)  
% R_MAX_U (IEEE802.11b) = 8 x 10^6 (bit/sec)  
% B_MAX_D (3G) = 2.5 x 10^6 (bit/sec) 
% R_MAX_D (IEEE802.11b) = 9 x 10^6 (bit/sec) 
% B_MAX_U (4G) = 9.4 x 10^6 (bit/sec) 
% B_MAX_D (4G) = 20.8 x 10^6 (bit/sec). 
% Fixing R_MAX_U, R_MAX_D, B_MAX_U, and  B_MAX_D is equivalent to fix 
% the sizes of the maximum congestion windows of the corresponding 
% TCP-NewReno connections.
%
TH_MIN_0 = 1/0.3; %1/0.3; % Scalar non-negative real parameter, i.e., TH_MIN_0 >= 0. 
                % It is the minimum required application throghput and it 
                % is measured in processed application DAG per second,
                % i.e.,(app/sec). 
                % Typically, TH_MIN_0 >= 0.1  (app/sec). 
% TH_MIN_0 = 1;
% TH_MIN_0 = 1/2;
%
Teta_M = 1;  % Binary 0-1 parameter.
%
Teta_F = 1;  % Binary 0-1 parameter.
%
Teta_C = 1;  % Binary 0-1 parameter. 
% Actual values of Teta_M, Teta_F and Teta_C are dictated by the applied 
% application service model. Typically, Teta_M = Teta_F = Teta_C = 1. 
%
%
P_IDLE_CPU_M = 1.2; % Power consumed by the physical CPU at the Mobile 
                       % device in the idle state. It is measured in (Watt).
%
P_IDLE_CPU_F = 220; % Power consumed by a single physical server in the
                       % idle state at the Fog node. It is measured in (Watt).
%
P_IDLE_CPU_C = 440; % By Michele 220; Power consumed by a single physical server in the
                       % idle state at the Cloud node. 
                       % It is measured in (Watt).
% Typically, 0 < P_IDLE_CPU_M << P_IDLE_CPU_F <= P_IDLE_CPU_C.
%
%
nc_M = 1;   % Dimension-less scalar positive integer parameter, 
            % i.e., nc_M >= 1. It is the average number of containers that 
            % SIMULTANEOUSLY run atop the CPU at the Mobile device.   
%
nc_F = 16; %60;   % Dimension-less scalar positive integer parameter, 
            % i.e., nc_F >= 1. It is the average number of containers that 
            % SIMULTANEOUSLY run atop a SINGLE physical server at the 
            % Fog node.   
%
nc_C = 24; %92;  % Dimension-less scalar positive integer parameter, 
            % i.e., nc_C >= 1. It is the average number of containers that 
            % SIMULTANEOUSLY run atop a SINGLE physical server at the 
            % Cloud node.   
% Typically, nc_M = 1, nc_F = 60 x nc_M, and nc_C = 90 x nc_M.
%
gamma_M =  3.2;% Dimension-less positive scalar exponent of the dynamic power 
             % consumption of the CPU at the Mobile device. 
             % Typically, gamma_M = 3. 
%
gamma_F = 3.1; %3.5; %3; % Dimension-less positive scalar exponent of the dynamic power 
             % consumption of a single physical server at the Fog node. 
             % Typically, gamma_F = 3. 
%
gamma_C = 3.0; %by Michele 3.0; %3.4; %3; % Dimension-less positive scalar exponent of the dynamic power 
             % consumption of a single physical server at the Cloud node. 
             % Typically, gamma_C = 3. 
%
K_M = 7.5e-21; %by Michele = 4.73e-20; %3.31e-19; %0.85e-18; % Positive scalar parameter. It is the profile of the dynamic 
                % power consumption of the CPU at the Mobile device. 
                % It is measured in: (Watt)/((bit/sec)^gamma_M).
%
K_F = 3.0*3.26e-20; % Positive scalar parameter. It is the profile of the dynamic 
                % power consumption of a single physical server at 
                % the Fog node. It is measured in:(Watt)/((bit/sec)^gamma_F).
%
K_C = 3.5*3.26e-20; %by Michele 3.5*3.26e-20; % Positive scalar parameter. It is the profile of the dynamic 
                % power consumption of a single physical server at the 
                % Cloud node. It is measured in: (Watt)/((bit/sec)^gamma_C).
%
% Typically, K_M = 0.5e-9 (Watt/(bit/sec)^3), K_F = 0.5 x K_M, 
% and K_C = 0.02 x K_M.
%
r_M = 0.0;  % Dimension-less scalar fraction of the overall 
            % computing power shared by the computing cores 
            % at the Mobile device. 0 <= r_M < 1.
%
r_F = 0.2;  % Dimension-less scalar fraction of the overall 
            % computing power shared by the computing cores of a single 
            % physical server at the Fog node. 0 <= r_F < 1.
%
r_C = 0.1;  % Dimension-less scalar fraction of the overall computing power 
            % shared by the computing cores of a single physical server 
            % at the Cloud node. 0 <= r_C < 1.
% Typically, r_M = 0, r_F = 0.2, and r_C = 0.4.
%
%
P_IDLE_ETH = 1.0e-4; % Power consumed in the idle state 
                     % by each physical Ethernet Network Interface Card (NIC) 
                     % that equips the Fog and Cloud nodes. 
                     % It is measured in (Watt). 
%
P_IDLE_WiFi_M = 1.3;   % Power consumed in the idle state by each physical 
                       % WiFi NIC that equips the Mobile device 
                       % and the corresponding Fog clone. 
                       % It is measured in (Watt). 
%
P_IDLE_CELL_M = 0.818; % Power consumed in the idle state by each physical 
                       % cellular 3G/4G NIC that equips the Mobile device 
                       % and the corresponding Cloud clone. 
                       % It is measured in (Watt). 
%
% Typically, 
% 0 < P_IDLE_ETH << P_IDLE_CELL_M << P_IDLE_WiFi_M, 
% with:   
% P_IDLE_ETH = 0.0001 (Watt), P_IDLE_CELL_M (3G) = 0.133 (Watt), 
% P_IDLE_CELL_M (4G) = 0.818 (Watt), and P_IDLE_WiFi_M = 1.3 (Watt). 
%
zeta_TX_WiFi = 2.4; %2.3;     % Dimension-less positive scalar exponent 
                        % of the dynamic power consumption of the WiFi NIC 
                        % in the transmit mode.
%
zeta_RX_WiFi = 2.2; %2.1;     % Dimension-less positive scalar exponent 
                        % of the dynamic power consumption of the WiFi NIC 
                        % in the receive mode.
%
zeta_TX_CELL = 2.45;    %by Michele 2.42; %2.2;     % Dimension-less positive scalar exponent 
                        % of the dynamic power consumption of the cellular 
                        % 3G/4G NIC in the transmit mode.
%
zeta_RX_CELL = 2.34;    %by Michele 2.32; %2.1;     % Dimension-less positive scalar exponent 
                        % of the dynamic power consumption of the cellular
                        % 3G/4G NIC in the receive mode.
                        %
% Typically, 
% zeta_TX_WiFi = 2.34, zeta_RX_WiFi = 2.18, 
% zeta_TX_CELL (3G) = 2.14, zeta_RX_CELL (3G) = 2.1, 
% zeta_TX_CELL (4G) =  2.16, zeta_RX_CELL (4G) = 2.15.
%
eta = 0.6;      % Dimensionless scalar positive exponent of the 
                % Round-Trip-Times (RTTs) of the TCP/IP WiFi and Cellular 
                % connections. Typically, 0.5 <= eta <= 0.7. 
%
RTT_WiFi = 10e-3;    % Average RTT of the TCP/IP WiFi connections. 
                     % It is measured in (sec). 
                     % Typically, 0.005 (sec) <= RTT_WiFi <= 0.15 (sec).  
%
RTT_CELL = 10e-2;    % Average RTT of the TCP/IP cellular connections. 
                     % It is measured in (sec). 
                     % Typically, 0.03(sec) <= RTT_CELL <= 0.05(sec).  
%
RTT_WD = 10e-1;      % Average RTT of the (possibly, multi-hop) TCP/IP 
                     % Cloud - Fog Internet backbone connection. 
                     % It is measured in (sec). 
                     % Typically, 0.2(sec) <= RTT_WiFi <= 0.33(sec).  
%
%
MSS = 12e+3;         % Maximum size of a TCP segment. 
                     % It is measured in (bit).Typically,MSS = 12000 (bit).
%
%
Prob_LOSS = 1.56e-5; %5.0e-8;  % Average segment loss probability of the TCP/IP 
                     % Cloud - Fog connection. 
                     % Typically, 10^(-8) <= Prob_LOSS <= 10^(-7). 
%
chi_TX_WiFi = 5*1.0e-14; % Power profile of the WiFi NIC in the transmit mode.
                      % It is measured in: 
                      % (Watt)/(((bit/sec)^(zeta_TX_WiFi)) x ((sec)^(eta))).
%
chi_RX_WiFi = 5*2.8e-15; % Power profile of the WiFi NIC in the receive mode.
                      % It is measured in: 
                      % (Watt)/(((bit/sec)^(zeta_RX_WiFi)) x ((sec)^(eta))). 
%
chi_TX_CELL = 6*3.85e-14;%by Michele 5*3.85e-14; % Power profile of the cellular NIC in the 
                      % transmit mode. It is measured in: 
                      % (Watt)/(((bit/sec)^(zeta_TX_CELL)) x ((sec)^(eta))).
%
chi_RX_CELL = 6*1.35e-15;% Power profile of the cellular NIC in the 
                         % transmit mode. It is measured in: 
                         % (Watt)/(((bit/sec)^(zeta_RX_CELL)) x ((sec)^(eta))).
% chi_TX_WiFi = 2.6e-7;
% chi_RX_WiFi = 1.6e-7;
% chi_TX_CELL = 5.2e-7;
% chi_RX_CELL = 3.2e-7;
%
% Typically,
% chi_TX_WiFi = 8 x 10^(-7), 
% chi_RX_WiFi = 5 x 10^(-7),
% chi_TX_CELL (3G) = 2.6 x 10^(-7),
% chi_RX_CELL (3G) = 1.6 x 10^(-7),
% chi_TX_CELL (4G) = 5.2 x 10^(-7),
% chi_RX_CELL (4G) = 3.2 x 10^(-7).
%
%
I_MAX = 700;   % Positive scalar integer parameter, i.e., I_MAX >= 1. 
                % It is the maximum number of the primal-dual iterations 
                % performed by the RAP function.
                % Typically, 200 <= I_MAX <= 700. 
 
%
a_max = 1.40e-7; % Dimension-less positive scalar real parameter, 
                 % i.e., a_max > 0. It is the speed-factor of the 
                 % gradient-based iterations performed by the RAP function. 
                 % It must be tuned by trials, in order to speed-up the 
                 % convergence rate of the RAP iterations, without causing 
                 % oscillations at the convergence.
                 % Typically, a_max is of the order of: 10^-7 - 10^-8.
%
no_HOP = 4;     % Dimension-less positive integer scalar parameter, i.e., 
                % no_HOP >= 1. It is the number of hops of the 
                % Cloud <-> Fog bidirectional 
                % Internet backbone connection. Typically, no_HOP >= 2.
%
P_HOP = 5.7e-1;  % Average power consumed by a SINGLE hop of the 
                % Cloud <-> Fog bidirectional Internet backbone connection. 
                % It is measured in (Watt). 
                % Typically, P_HOP > 2.5 x 10^(-1) (Watt).
%
 
PS = 200;       % Dimension-less positive even integer scalar parameter. 
                % It must be EVEN and NOT BELOW 4, i.e., PS is an 
                % even integer and PS >= 4. 
                % It is the size of the population processed by 
                % all the called genetic functions. 
%
CF = 0.5;       % Fraction of the population size PS that is subject 
                % to cross over by all the called genetic functions. 
                % It must be: 0 < CF < 1.
%
G_MAX = 50;     % Dimension-less positive scalar integer parameter, 
                % i.e., G_MAX >= 1. It is the number of iterations 
                % (that is, the number of generations) performed 
                % by all the called genetic functions.
                % Typically, G_MAX >= 20. 
%
MN = V-2;       % Number of elements of any V-long ternary 
                % task allocation vector: x that are mutated by 
                % the called genetic functions.  
                % It must be: 1 <= MN <= (V-2). 
               
%
iteration_number = 5000; % It must be a POSITIVE INTEGER MULTIPLE of 5. 
                % It is the total number of the primal-dual iterations 
                % performed by the RAP function during each run of FogTracker. 
                % It must be ADDED to the list of the GLOBAL variables of
                % the main program.
%
%
a_max_vec_FT = [1.62e-7,1.40e-7,1.1e-7];  
% Dimension-less positive (1x3) real valued-vector., 
% It is the vector of the THREE tested speed-factors of the 
% gradient-based iterations performed by the RAP function. 
% Its size MUST BE 3. It must be ADDED to the list of the GLOBAL variables
% of the main program
%
jump1_WiFi = 0.0;          % Non-negative scalar parameter that specifies the factor
jump1_CELL = 1.0;          % of the up/down scaling applied to the maximum up/down
jump2_WiFi = 1.0;          % bandwidths of the WiFi and Cellular connections. It must
jump2_CELL = 1.0; %or 0.0  % be added to the list of the GLOBAL variables of main program.
%         
%
fprintf('..\n');
%
%      End setup of the input parameters of MobiFogSim 
%--------------------------------------------------------------------------  
