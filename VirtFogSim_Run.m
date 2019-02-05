function VirtFogSim_Run(options)

%
%
%   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
%   *          Parallel Mobile Fog Simulator - VirtFogSim             *
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


%--------------------------------------------------------------------------
% Setting some global parameters
global V;
global s;
global A;
global Da;


%--------------------------------------------------------------------------
% Setting some local parameters
fignumber = 0;  % For the first 5 figs dedicated to Laplace multipliers and gradients

GAA = options(1);  % Genetic Algorithm Allocation
OMA = options(2);  % Only Mobile Allocation
OFA = options(3);  % Only Fog Allocation
OCA = options(4);  % Only Cloud Allocation
OTA = options(5);  % Only Task Allocation
ESA = options(6);  % Exaustive Search Allocation
FGT = options(7);  % Fog Tracker

tic;
                                                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin the code of the VirtFogSim script
%
% -------------------------------------------------------------------------
% Begin the call and display of the GeneticTA function that implements the 
% The Genetic Task Allocation procedure
%
if GAA
    fprintf('\nBegin the run of the GeneticTA function\n');
    fprintf('\nPlease wait..............\n');
    %
    [x_best, RS_best, E_best, E_NET_best, RB_best] = GeneticTA_par;  % Call the parallel GeneticTA function.
    %
    if(E_best == inf)
        fprintf('Warning message from VirtFogSim: all the task allocations generated by GeneticTA are infeasible\n');    
    else
        % Print of the GeneticTA best solution:
        print_solution(RS_best, [E_best, E_best-E_NET_best, E_NET_best], RB_best, 'GeneticTA');
        %------------------------------------------------------------------
        % Plot of the GeneticTA best solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, x_best, 'GeneticTA', 3);
        end
        fignumber = fignumber + 1; % Set the counter of the figure number.
        plot_solution(x_best, RS_best, [E_best, E_best-E_NET_best, E_NET_best], RB_best, fignumber, 'GeneticTA');       
    end % End if
    %
    fprintf('End the run of the GeneticTA function\n');
else
    fprintf('\nGeneticTA function skipped.\n');
end
% End the call and display of the GeneticTA function
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Begin the call and display of the OM_S function that implements the 
% function Only Mobile Strategy
if OMA
    fprintf('\nBegin the run of the OM-S function\n');
    %
    [RS_OM, E_OM, E_NET_OM] = OM_S; % Call the OM_S function.
    %
    if (E_OM == inf)
        fprintf('Warning message from VirtFogSim: The All-Mobile task allocation is infeasible\n');
    else
        % Print of the OM solution:
        print_solution(RS_OM, [E_OM, E_OM-E_NET_OM, E_NET_OM], 0, 'OM-S');
        %------------------------------------------------------------------
        % Plot of the OM solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, ones(1,V), 'OM-S', 3);
        end
        fignumber = fignumber + 1;
        plot_solution([], RS_OM, [E_OM, E_OM-E_NET_OM, E_NET_OM], [], fignumber, 'OM-S');      
    end % End if.
     %
    fprintf('End the run of the OM-S function\n');
else
    fprintf('\nOM-S function skipped.\n');
end
% End call and display of the OM_S function.
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Begin call and display of the OF_S function that implements the function 
% Only Fog Strategy
if OFA
    fprintf('\nBegin the run of the OF-S function\n');
    %
    [RS_OF, E_OF, E_NET_OF] = OF_S; % Call the OF_S function.
    %
    %
    if (E_OF == inf)
        fprintf('Warning message from VirtFogSim: the All-Fog task allocation is infeasible\n');
    else
        % Print of the OF solution:
        print_solution(RS_OF, [E_OF, E_OF-E_NET_OF, E_NET_OF], 0, 'OF-S');
        %------------------------------------------------------------------
        % Plot of the OF solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, [1, zeros(1,V-2), 1], 'OF-S', 3);
        end
        fignumber = fignumber + 1;
        plot_solution([], RS_OF, [E_OF, E_OF-E_NET_OF, E_NET_OF], [], fignumber, 'OF-S');
    end % End if.
    %
    fprintf('End the run of the OF-S function\n');
else
    fprintf('\nOF-S function skipped.\n');
end
% End call and display the OF_S function
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Begin call and display the OC_S function that implements the function 
% Only Cloud Strategy
if OCA
    fprintf('\nBegin the run of the OC-S function\n');
    %
    [RS_OC, E_OC, E_NET_OC] = OC_S; % Call the OC_S function.
    %
    if (E_OC == inf)
        fprintf('Warning message from VirtFogSim: The All-Cloud task allocation is infesible\n');
    else
        % Print of the OC solution:
        print_solution(RS_OC, [E_OC, E_OC-E_NET_OC, E_NET_OC], 0, 'OC-S');
        %------------------------------------------------------------------
        % Plot of the OC solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, [1, 2*ones(1,V-2), 1], 'OC-S', 3);
        end
        fignumber = fignumber + 1;
        plot_solution([], RS_OC, [E_OC, E_OC-E_NET_OC, E_NET_OC], [], fignumber, 'OC-S');
    end % End if
    %
    fprintf('End the run of the OC-S function\n');
else
    fprintf('\nOC-S function skipped.\n');
end
% End call and display of OC_S
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Begin call and display of the O_TAS function that implements the 
% Only-Task Allocation Strategy
if OTA
    fprintf('\nBegin the run of the O-TAS function\n');
    %
    [x_OTAS, E_OTAS, E_NET_OTAS] = O_TAS_par;           % Call the O_TAS function.
    %
    if(E_OTAS == inf)
        fprintf('Warning message from VirtFogSim: all the task allocations generated by O_TAS are infeasible\n');  
    else
        % Print of the OTAS solution:
        print_solution([], [E_OTAS, E_OTAS-E_NET_OTAS, E_NET_OTAS], 0, 'O-TAS');
        %------------------------------------------------------------------
        % Plot of the OTAS solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, x_OTAS, 'O-TAS', 3);
        end
        fignumber = fignumber + 1;
        plot_solution(x_OTAS, [], [E_OTAS, E_OTAS-E_NET_OTAS, E_NET_OTAS], [], fignumber, 'O-TAS');
    end
    %
    fprintf('End the run of the O-TAS function\n');
else
    fprintf('\nO-TAS function skipped.\n');
end
% End call and display the O_TAS function
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% Begin call and display the ES_S function that implements the Exhaustive 
% Search Strategy. 
% The outputs of GeneticTA and O_TAS must be already available.
if ESA
    fprintf('\nBegin the run of the ES-S function\n');

    [x_ESS, RS_ESS, E_ESS, E_NET_ESS, RB_ESS] = ES_S_par;  % Call the ES_S function.

    if(E_ESS == inf)
        fprintf('Warning message from VirtFogSim: all the task allocations generated by ES_S are infeasible\n'); 
    else
        % Print of the ES solution:
        print_solution(RS_ESS, [E_ESS, E_ESS-E_NET_ESS, E_NET_ESS], RB_ESS, 'ES-S');
        %------------------------------------------------------------------
        % Plot of the ES solution:
        if license('checkout', 'bioinformatics_toolbox')
            plot_DAG(s, A, Da, x_ESS, 'ES-S', 3);
        end
        fignumber = fignumber + 1;
        plot_solution(x_ESS, RS_ESS, [E_ESS, E_ESS-E_NET_ESS, E_NET_ESS], RB_ESS, fignumber, 'ES-S');
    end % End if
    %
    fprintf('End the run of the ES-S function\n');
else
    fprintf('\nES-S function skipped.\n');
end
% End call and display of the ES_S function.
%--------------------------------------------------------------------------
%
% End the current run of VirtFogSim.
%--------------------------------------------------------------------------

fprintf('\n');
toc

%--------------------------------------------------------------------------
% Start of the Fog Tracker script that traces the dynamic behaviours of
% the vectors of the consumed energies (Joule); and the vectors of the 
% multiplier values (Joule).
%
if FGT
    x1 = 2*ones(1, V); x1(1) = V; x1(V) = 1;  % Only Cloud task allocation
    x2 = ones(1, V);                          % Only Mobile task allocation
    x3 = zeros(1, V); x3(1) = 1; x3(V) = 1;   % Only Fog task allocation
    %
    %-----------------Calling FogTracker-----------------------------------
    [energy_m_out, net_energy_m_out, lambda_m_out] = FogTracker(x1, x2, x3);
    %
    fignumber = fignumber + 1;
    plot_FogTracker(energy_m_out, net_energy_m_out, lambda_m_out, fignumber);
    
    % fignumber = fignumber + 1;
    % plot_FogTracker(energy_m_out, net_energy_m_out, lambda_m_out, fignumber, 1);
    %    
else
    fprintf('\nFogTracker skipped.\n');
end
%
%--------------End Execution and display of the results of FogTracker------
%
fprintf('\nMessage from VirtFogSim: the total number of plotted figures is %d\n\n', fignumber);
%
%--------------------------------------------------------------------------
%
% End the script of VirtFogSim.
