function varargout = Color_Selection(varargin)
% COLOR_SELECTION MATLAB code for Color_Selection.fig
%      COLOR_SELECTION, by itself, creates a new COLOR_SELECTION or raises the existing
%      singleton*.
%
%      H = COLOR_SELECTION returns the handle to a new COLOR_SELECTION or the handle to
%      the existing singleton*.
%
%      COLOR_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLOR_SELECTION.M with the given input arguments.
%
%      COLOR_SELECTION('Property','Value',...) creates a new COLOR_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Color_Selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Color_Selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

%   Copyright 2020 Mirtech, Inc.
% Edit the above text to modify the response to help Color_Selection

% Last Modified by GUIDE v2.5 30-Apr-2018 14:30:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Color_Selection_OpeningFcn, ...
                   'gui_OutputFcn',  @Color_Selection_OutputFcn, ...
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


% --- Executes just before Color_Selection is made visible.
function Color_Selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Color_Selection (see VARARGIN)

% Choose default command line output for Color_Selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Define the colors the user can chose among

colors=[23 118 182 ;...
%    255 127 0 ; ...
    36 161 33; ...
    216 36 31 ; ...
    141 86 73 ; ...
    229 116 195;...
    149 100 191; ...
 %   0 190 208;...
    188 191 0;...
    127 127 127];

colors=[141,211,199
255,255,179
190,186,218
% 251,128,114  %red
% 128,177,211  %blue
253,180,98   %orange
179,222,105
252,205,229
217,217,217
188,128,189
204,235,197
255,237,111];

ax_cell_Pheno=handles.axes1;
rw4=my_bar(ones(size(colors,1),1),[],colors/255,ax_cell_Pheno);
set(ax_cell_Pheno, 'visible', 'off')
set(ax_cell_Pheno,'xlim',[0.5 size(colors,1)+0.5])
set(rw4,'BarWidth',1)
set(rw4,'ButtonDownFcn',{@nodeCallback_axes,handles});
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Color_Selection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = str2num(get(handles.output,'Tag'));
delete(handles.figure1);

function handles=nodeCallback_axes(hObject,~,handles)
set(handles.output,'Tag',num2str(hObject.XData));

% handles.output=hObject.XData;
uiresume(handles.figure1);
