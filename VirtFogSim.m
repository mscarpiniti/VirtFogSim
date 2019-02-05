%
%
%   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
%   *          Parallel Mobile Fog Simulator - ParVirtFogSim          *
%   *                                                                 *
%   * Authors: Enzo Baccarelli and Michele Scarpiniti                 *
%   * Last updating: January, 2019                                    *
%   * Copyright: This simulator has been developed under the          *
%   *                                                                 *
%   *            "GAUChO" project, Italian PRIN, Bando 2016.          *
%   *                                                                 *
%   * Current version: 4.0                                            *
%   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
%
%
% The parallel VirtFogSim script acts as main program and graphic user interface 
% of the overall parallel version of the simulator.
% The user sets 67 global variables, that act as global input parameters.
% In addition, the user also sets three test
% (0,1,2)-ary (1xV)-dimensional allocation vectors (namely, x1, x2, and x3),
% before calling the FogTracker function.
%
% VirtFogSim orderly calls the following seven functions:
%
% 1) GeneticTA_par (parallel version of the Genetic Task Allocation);
% 2) OM_S (Only-Mobile Strategy);
% 3) OF_S (Only-Fog Strategy);
% 4) OC_S (Only-Cloud Strategy);
% 5) O_TAS_par (parallel version of the Only-Task Allocation Strategy); 
% 6) ES_S_par (parallel version of the Exhaustive-Search Strategy); and
% 7) FogTracker (dynamic plots of the consumed total and network energies and multiplier
%    values under the test allocation vector x1, x2 and x3 set by the user
%    before calling FogTracker).
%
% These seven functions call, in turn, the following ten  
% auxiliary functions:
% 1) RAP (sequential version of the Resource Allocation Procedure);
% 2) RAP_p (parallel version of the Resource Allocation Procedure);
% 3) Crossover;
% 4) Mutation;
% 5) evaluatestaticenergy_p;
% 6) find_allocations;
% 7) plot_DAG;
% 8) customTextNode;
% 9) ustep; and
% 10) delta.
%
% The output data/plots of the VirtFogSim simulator are:
%
% 1) x_best, RS_best (bit/sec), RB_best (bit/sec), E_best and E_NET_best (Joule), 
%    that are output by GeneticTA_par;
% 2) RS_OM (bit/sec) and E_OM (Joule), that are output by OM_S;
% 3) RS_OF (bit/sec) and E_OF (Joule), that are output by OF_S;
% 4) RS_OC (Bit/sec) and E_OC (Joule), that are output by OC_S;
% 5) x_OTAS, E_OTAS and E_NET_OTAS(Joule), that are output by O_TAS_par;
% 6) x_ESS, RS_ESS (bit/sec), RB_ESS (bit/sec), E_ESS and E_NET_ESS(Joule), 
%    that are output by ES_S_par; and,
% 7) the plots of the total energy, network energy and multiplier values
% when abrupt changes are induced in the maximum up/down bandwidths and
% task allocation vectors. They are output by the FogTracker function;
% 8) the colored map of the task allocation performed by the GeneticTA_par
% under the given DAG; 
% 9) the colored map of the task allocation performed by the OM_S
% under the given DAG; 
% 10) the colored map of the task allocation performed by the OF_S
% under the given DAG;
% 11) the colored map of the task allocation performed by the OF_S
% under the given DAG; 
% 12)the colored map of the task allocation performed by the ES_S
% under the given DAG;
% 13)the colored map of the task allocation performed by the O_TAS
% under the given DAG;
%
% All the seven (scalar) components of the resource allocation vectors: 
% RS_best,RS_OM, RS_OF, RS_OC, RS_ESS and the corresponding utilised
% transport rates of the backhaul connection:
% RB_best and RB_ESS are displayed in (Mbit/sec).
%
% All the (scalar) energies: E_best, E_OM, E_OF, E_OC, E_OTAS, E_ESS, 
% E_NET_best, E_NET_OTAS and E_NET_ESS are displayed in Joule.
%
% x_best, x_OTAS, and x_ESS are (1xV) ternary task allocation
% vectors. Their integer-valued scalar components take value over the 
% ternary set (0, 1, 2). 
% Specifically, for i = 1,...V, we have that:
%
% x(i)==0 means: 'the i-th task is executed at the Fog node. The rendered task colour is red';
% x(i)==1 means: 'the i-th task is executed at the Mobile node. The rendered task colour is green'; and,
% x(i)==2 means: 'the i-th task is executed at the Cloud node. THe rendered task colur is azure'.
%
% The positive integer-valued parameter V is the number of nodes of the 
% considered application Directed Acyclic Graph (DAG), that is, 
% the number of the tasks of the considered application. 
%
% By design, the first and last tasks of any application DAG are executed
% at the Mobile device. 
% This means, in turn, that the first (i.e., x(1)) and last (i.e., x(V))
% components of the (ternary) task allocation vectors: 
% x_best, x_OTAS, and x_ESS are, by default, set to the unit.
% 
% Let us assume that the HW plattform used for running VirtFogSim 
% is equipped with n_core >= 1 physical workers. 
% Then, the overall asymptotic complexity of the parallel version of 
% parallel VirtFogSim scales up as:
%
% O((8*I_MAX*((PS*G_MAX)+(3^(V-2))+3)+(PS*G_MAX))/n_core),
%
% where I_MAX, PS, V and G_MAX are input parameters whose meanings/roles
% are described by the GUI that equips VirtFogSim.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin the VirtFogSim script
clear;
clc;
close all;

%--------------------------------------------------------------------------
fprintf('BEGIN the current run of VirtFogSim\n');

%--------------------------------------------------------------------------
fprintf('Setting the parameters....');
%
% Selecting the chosen DAG
%
% Set_parameters_DAG_1;
% Set_parameters_DAG_2;
% Set_parameters_DAG_3;
% Set_parameters_DAG_4;
% Set_parameters_DAG_5;
% Set_parameters_DAG_6;
% Set_parameters_DAG_7;
% Set_parameters_DAG_8;
% Set_parameters_DAG_9;
Set_parameters_DAG_10;
% Set_parameters_DAG_A;
% Set_parameters_DAG_B;
% Set_parameters_DAG_C;
%
%--------------------------------------------------------------------------
% Selecting the Allocation Strategies to run
GAA = 1;   % Genetic Algorithm Allocation
OMA = 1;   % Only Mobile Allocation
OFA = 1;   % Only Fog Allocation
OCA = 1;   % Only Cloud Allocation
OTA = 1;   % Only Task Allocation
ESA = 0;   % Exhaustive Search Allocation
FGT = 1;   % Fog Tracker
%
options = [GAA, OMA, OFA, OCA, OTA, ESA, FGT];
%
%
fprintf('....\n\n');
%
%--------------------------------------------------------------------------
% Evaluating the Communication-to-Computing Ratio (CCR)
CCR = ccr(s, A, Da);
fprintf('The Communication-to-Computing Ratio (CCR) is %4.3f\n\n', CCR);
%
%                                                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin the code of the VirtFogSim script
%
% -------------------------------------------------------------------------
% Begin the call and display of the Parallel or not Parallel versione of 
% the VirtFogSim
%
p = gcp('nocreate');   % If no pool, do not create new one.
if isempty(p)
    p = parpool;
    poolsize = p.NumWorkers;
    fprintf('There are %d workers available\n\n', poolsize);
else
    poolsize = p.NumWorkers;
    fprintf('There are %d workers available\n\n', poolsize);
end
VirtFogSim_Run(options);
%
fprintf('\nEND of the current run of VirtFogSim\n');
% 
%--------------------------------------------------------------------------
%
% End the script of VirtFogSim.
