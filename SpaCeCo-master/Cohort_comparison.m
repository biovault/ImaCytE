function varargout = Cohort_comparison(varargin)
% COHORT_COMPARISON MATLAB code for Cohort_comparison.fig
%      COHORT_COMPARISON, by itself, creates a new COHORT_COMPARISON or raises the existing
%      singleton*.
%
%      H = COHORT_COMPARISON returns the handle to a new COHORT_COMPARISON or the handle to
%      the existing singleton*.
%
%      COHORT_COMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COHORT_COMPARISON.M with the given input arguments.
%
%      COHORT_COMPARISON('Property','Value',...) creates a new COHORT_COMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cohort_comparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cohort_comparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Cohort_comparison

% Last Modified by GUIDE v2.5 07-Feb-2020 16:21:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Cohort_comparison_OpeningFcn, ...
                   'gui_OutputFcn',  @Cohort_comparison_OutputFcn, ...
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


% --- Executes just before Cohort_comparison is made visible.
function Cohort_comparison_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Cohort_comparison (see VARARGIN)

% Choose default command line output for Cohort_comparison
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

Options_item = uimenu(handles.figure1,'Text','Options Menu');
% Load_data_item= uimenu(Options_item,'Text','Load Data');
% set(Load_data_item,'MenuSelectedFcn',{@Load_Data,handles})
Cell_Abundance= uimenu(Options_item,'Text','Cell_Abundance');
set(Cell_Abundance,'MenuSelectedFcn',{@Cell_Abundance_environment_creation,handles});
Tissue_samples= uimenu(Options_item,'Text','Tissue_samples');
set(Tissue_samples,'MenuSelectedFcn',{@Tissue_samples_environment_creation,handles});
Colocalization= uimenu(Options_item,'Text','Colocalization');
set(Colocalization,'MenuSelectedFcn',{@Colocalization_environment_creation,handles});

cmap=varargin{1};
cluster_names=varargin{2};
Load_Data([],[],handles,cmap,cluster_names)

setappdata(0,'mygui',gcf);
set( findall( gcf, '-property', 'Units' ), 'Units', 'Normalized' ) %in order to make window resizable

% UIWAIT makes Cohort_comparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Cohort_comparison_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
