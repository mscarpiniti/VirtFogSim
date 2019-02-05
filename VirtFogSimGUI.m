function varargout = VirtFogSimGUI(varargin)
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



% VIRTFOGSIMGUI MATLAB code for VirtFogSimGUI.fig
%      VIRTFOGSIMGUI, by itself, creates a new VIRTFOGSIMGUI or raises the existing
%      singleton*.
%
%      H = VIRTFOGSIMGUI returns the handle to a new VIRTFOGSIMGUI or the handle to
%      the existing singleton*.
%
%      VIRTFOGSIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIRTFOGSIMGUI.M with the given input arguments.
%
%      VIRTFOGSIMGUI('Property','Value',...) creates a new VIRTFOGSIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VirtFogSimGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VirtFogSimGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VirtFogSimGUI

% Last Modified by GUIDE v2.5 11-Jan-2019 17:28:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VirtFogSimGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @VirtFogSimGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VirtFogSimGUI is made visible.
function VirtFogSimGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VirtFogSimGUI (see VARARGIN)

global option
global openDAG
global openArchivedDAG

% Choose default command line output for VirtFogSimGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VirtFogSimGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Inserting SplashScreen Figure into axes1
I = imread('Logo_VFS.jpg');
axes(handles.axes1);
imshow(I);
option = [1, 1, 1, 1, 1, 0, 1];
openArchivedDAG = 0;
openDAG = 0;


% --- Outputs from this function are returned to the command line.
function varargout = VirtFogSimGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global openArchivedDAG

uiopen([pwd, '\Archived DAGs\']);
openArchivedDAG = 1;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DAGfile
global openDAG

[filename, pathname] = uigetfile('*m', 'Select a DAG File');
openDAG = 1;
DAGfile = [pathname, filename];
edit(DAGfile);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DAGfile
global openDAG

if openDAG
    [~, DAGname, ~] = fileparts(DAGfile);
    feval(DAGname);
    all_variables = {'V','s','A','Da','n_M','n_F','n_C','NF_WiFi','NF_CELL','NF_WD','f_MAX_M','f_MAX_F','f_MAX_C', ...
        'R_MAX_U','R_MAX_D','B_MAX_U','B_MAX_D','TH_MIN_0','Teta_M','Teta_F','Teta_C','P_IDLE_CPU_M', ...
        'P_IDLE_CPU_F','P_IDLE_CPU_C','nc_M','nc_F','nc_C','gamma_M','gamma_F','gamma_C','K_M', ...
        'K_F','K_C','r_M','r_F','r_C','P_IDLE_ETH','P_IDLE_WiFi_M','P_IDLE_CELL_M','zeta_TX_WiFi', ...
        'zeta_RX_WiFi','zeta_TX_CELL','zeta_RX_CELL','eta','RTT_WiFi','RTT_CELL','RTT_WD','MSS', ...
        'Prob_LOSS','chi_TX_WiFi','chi_RX_WiFi','chi_TX_CELL','chi_RX_CELL','I_MAX','a_max', ...
        'no_HOP','P_HOP','PS','CF','G_MAX','MN','iteration_number','jump1_WiFi','jump1_CELL', ...
        'jump2_WiFi','jump2_CELL','a_max_vec_FT','c1','c2','k1','k2'};
    uisave(all_variables, DAGname)
else
    fprintf('No opened files to be saved!\n');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global option
global openDAG
global DAGfile
global openArchivedDAG

clc;

% If DAG has been opened but not saved, it will be run
if openDAG
    [~, DAGname, ~] = fileparts(DAGfile);
    feval(DAGname);
end    
    
% Run the VirtFogSim simulator with the chosen options
if (openDAG || openArchivedDAG)
    VirtFogSim_Run(option);
else
    fprintf('No DAG has been opened!\n');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open('VirtFogSim_UserGuide.pdf')


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(clf)
close all
clear


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

global option

option(1) = get(hObject, 'Value');


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

global option

option(2) = get(hObject, 'Value');


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

global option

option(3) = get(hObject, 'Value');


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4

global option

option(4) = get(hObject, 'Value');


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5

global option

option(5) = get(hObject, 'Value');


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6

global option

option(6) = get(hObject, 'Value');


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7

global option

option(7) = get(hObject, 'Value');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
