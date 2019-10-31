function varargout = IMACytE(varargin)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

% IMACYTE MATLAB code for IMACytE.fig
%      IMACYTE, by itself, creates a new IMACYTE or raises the existing
%      singleton*.
%
%      H = IMACYTE returns the handle to a new IMACYTE or the handle to
%      the existing singleton*.
%
%      IMACYTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMACYTE.M with the given input arguments.
%
%      IMACYTE('Property','Value',...) creates a new IMACYTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IMACytE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IMACytE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IMACytE

% Last Modified by GUIDE v2.5 31-Oct-2019 14:38:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMACytE_OpeningFcn, ...
                   'gui_OutputFcn',  @IMACytE_OutputFcn, ...
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


% --- Executes just before IMACytE is made visible.
function IMACytE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMACytE (see VARARGIN)

% clear variables that may are mis-initialized from previous run 
clear global
cla(handles.uipanel4)
cla(handles.uipanel1)
cla(handles.uipanel2)


setappdata(handles.figure1,'clustMembsCell',[])
set(handles.Markerlist,'String',[]);

set(handles.uipanel1,'Visible','off')
set(handles.uipanel4,'Visible','off')
set(handles.uipanel2,'Visible','off')
set(handles.slider2,'Visible','off')
set(handles.arcsin,'Value',0);
set(handles.arcsin,'Visible','off');
set(handles.Compute_map,'Visible','off');
count=0;
setappdata(handles.figure1,'count_interaction',count);

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
setappdata(0,'mygui',gcf);
set(handles.figure1,'windowbuttonmotionfcn',[]);

set( findall( gcf, '-property', 'Units' ), 'Units', 'Normalized' ) %in order to make window resizable


% UIWAIT makes IMACytE wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = IMACytE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
jFrame = get(handle(gcf),'JavaFrame');
jFrame.setMaximized(true);  


% --- Executes on selection change in Markerlist.
function Markerlist_Callback(hObject, eventdata, handles)
% hObject    handle to Markerlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Markerlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Markerlist

%% This callback saves the selected features which would be used afterwars for the tsne map computation

selected_markers = get(hObject,'Value') ;
setappdata(handles.figure1,'selected_markers',selected_markers);


% --- Executes during object creation, after setting all properties.
function Markerlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Markerlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Compute_map.
function Compute_map_Callback(hObject, eventdata, handles)
% hObject    handle to Compute_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This callback implements the tsne creation map

global n_data
global tsne_map
global cell4
global tsne_idx
tsne_idx=0;

%% Select which samples you want to include in your analysis
samples={cell4(:).name};
selected_samples=listdlg('PromptString','Select samples to utilize:','ListString',samples);
cell4=cell4(selected_samples);
setappdata(handles.figure1,'selection_samples',[]); % you currently deselct all the illustrated images

%% You redifine the tsne_idx and n_data in case less samples were selected
prev=0;
for i=1:length(cell4)    
    tsne_idx(prev+1:prev+length(cell4(i).idx))=i;
    prev=prev+ length(cell4(i).idx);
end

n_data=double(vertcat(cell4(:).data));
%% Select which features to use for tsne map creation
markerlist=getappdata(handles.figure1,'selected_markers');
if isempty(markerlist); warndlg('Please select features for tSNE'); return; end
used_data=n_data(:,markerlist);

%% Select the tsne version you want to use
tsne_choice=listdlg('PromptString','Select tSNE method to utilize:','ListString',{'tSNE', 'A-tSNE','Texture A-tSNE'},'SelectionMode','single');
% tsne_choice=1;
f = waitbar(0,'Please wait...');
switch tsne_choice
    case 1
        try
            tsne_map=tsne(my_normalize(used_data,'column'));
        catch ME
            rethrow(ME)
        end
    case 2
        try
            tsne_map=fast_atsne(my_normalize(used_data,'column'));
        catch ME
            rethrow(ME)
        end
    case 3
        try
            tsne_map=my_texture_tsne(my_normalize(used_data,'column'));
        catch ME
            rethrow(ME)
        end  
end
waitbar(1,f,'Finished');

%% Create the scatter plot which gonna present the tsne map

f_scatter=getappdata(handles.figure1,'Scatter_Figure');
delete(get(f_scatter,'Children'));
x=axes(f_scatter);
scatter(x,tsne_map(:,1),tsne_map(:,2),'filled');
set(x,'Tag','Scatter_axes');
set(x,'Position',[0.05 0.05 0.9 0.9]);

%% Create the controls of the bandwidth range and min/max values they can get
handles.Slider = uicontrol(handles.figure1,'style', 'Slider', 'Min', 0, 'Max', 20, 'Value',10, 'Units','normalized','position', [0 0.9 0.067 0.025 ], 'callback', {@ slider2_Callback, handles});
handles.Text_val = uicontrol(handles.figure1,'Style','text','String','Value(#Clusters)','Units','normalized','position', [0.01 0.94 0.03 0.02 ]);
% handles.Edit_val = uicontrol(handles.figure1,'Style','text','String',num2str(get(handles.Slider,'Value')),'Units','normalized','position', [0.025 0.925 0.015 0.02 ]);
handles.Text_max = uicontrol(handles.figure1,'Style','text','String','Max','Units','normalized','position', [0.048 0.94 0.02 0.02 ]);
handles.Edit_max = uicontrol(handles.figure1,'Style','edit','String',num2str(get(handles.Slider,'max')),'Units','normalized','position', [0.05 0.926 0.015 0.02], 'Callback',{@ MaxCallback, handles});
guidata(handles.figure1,handles)


set(handles.uipanel1,'Visible','on')

function MinCallback(hObject, ~, handles)

        value_min=str2double(get(hObject, 'String'));
        if value_min > str2double(get(handles.Slider, 'Value'))
            set(handles.Slider, 'Value', value_min+1);
        end
        set(handles.Slider, 'Min', value_min);
        guidata(handles.figure1,handles)


function MaxCallback(hObject, ~, handles)

        value_max=str2double(get(hObject, 'String'));
        if value_max < get(handles.Slider, 'Value')
            set(handles.Slider, 'Value', value_max -0.5);
        end
        set(handles.Slider, 'Max', value_max);
        guidata(handles.figure1,handles)


% --- Executes on button press in arcsin.
function arcsin_Callback(hObject, eventdata, handles)
% hObject    handle to arcsin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arcsin

%% This callback applies arcsin transformation to the data if has not been applied so far 

global n_data
global cell4

setappdata(handles.figure1,'Arcsinh',get(hObject,'Value'))

if getappdata(handles.figure1,'Arcsinh')
    n_data=asinh(double(vertcat(cell4(:).data))/5);
else
    n_data=double(vertcat(cell4(:).data));
end



% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Load_data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% This callback initializes the Loading the data process

global cell4 % Each instance of cell4 is a different sample
global tsne_map % represents the calculated tsne_map
global n_data % represents the high dimensional data used for dimensionality reduction
global tsne_idx % keeps track of the sample each cell belongs to
tsne_idx=0;
tsne_map=[];

mode='Imaging'; 
switch mode
    case 'Imaging'         
        cell4=[];
        r=uigetdir();
        direct_=dir(r);
        f = waitbar(0,'Please wait...');
        if isempty(find(vertcat(direct_(3:end).isdir), 1))
            cell4=Load_Multiple_Images_IMACytE(r);
        else
            for i=3:length(direct_)
                if direct_(i).isdir
                    try
                        cell4=[cell4 ; Load_Multiple_Images_IMACytE([direct_(i).folder '\' direct_(i).name])];
                        waitbar((1/(length(direct_)-2)*(i-2)),f,['Loaded ' num2str(i-2) ' out of ' num2str(length(direct_)-2) ' images ']);
                    catch
                        warndlg(['Problem loading File: ' direct_(i).folder '\' direct_(i).name],'Error');
                    end
                end
            end
        end
        waitbar(1,f,'Finished');
end

markers=cell4(1).cell_markers;
setappdata(handles.figure1,'markers',markers);

%% tsne_idx initialization
n_data=double(vertcat(cell4(:).data));
prev=0;
for i=1:length(cell4)
    tsne_idx(prev+1:prev+length(cell4(i).idx))=i;
    prev=prev+ length(cell4(i).idx);
end
%%
set(handles.Markerlist,'String',markers);
set(handles.Markerlist,'Value',[]);


f_scatter=handles.uipanel1; % where scatter plot is gonna be illustrated in the tool
set(f_scatter,'Tag','tsne_plot');
setappdata(handles.figure1,'Scatter_Figure',f_scatter);
d = uicontextmenu(get(f_scatter,'Parent')); %contect menu for saving_as the samples
Sava_as_interaction1=uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, f_scatter});
set(f_scatter,'UIContextMenu',d);

f_image=handles.uipanel2; % where images of samples are gonna be illustrated in the tool
set(f_image,'Tag','Images_panel');
setappdata(handles.figure1,'Tissue_Figure',f_image);
d = uicontextmenu(get(f_image,'Parent')); %contect menu for saving_as the samples
Sava_as_interaction2=uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, f_image});
set(f_image,'UIContextMenu',d);

f_heatmap=handles.uipanel4; % where heatmap is gonna be illustrated in the tool
set(f_heatmap,'Tag','heatmap')
setappdata(handles.figure1,'Heatmap_Figure',f_heatmap);
d = uicontextmenu(get(f_heatmap,'Parent')); %contect menu for saving_as the samples
Sava_as_interaction3=uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, f_heatmap});
set(f_heatmap,'UIContextMenu',d);


%% Initializes the panels of the tool that depict the main figures
gg=get(handles.uipanel2,'Children');
delete(gg);
set(handles.uipanel2,'Visible','on')
% set(handles.axes6,'Visible','off')
set(handles.arcsin,'Visible','on');
set(handles.Compute_map,'Visible','on');
uicontrol(handles.uipanel2,'Style', 'pushbutton', 'String', 'Samples','Units','normalized','position', [0.1 0.96 0.2 0.025 ], 'callback', {@ Samples_Callbacki, handles});
uicontrol(handles.uipanel2,'Style', 'pushbutton', 'String', 'Markers','Units','normalized','position', [0.7 0.96 0.2 0.025 ], 'callback', {@ Markers_Callbacki, handles}); 

% --------------------------------------------------------------------
function Interaction_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Interaction_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% This callback initializes the microenvironemnt exploration of the data which is performed from the Interactions_Motifs functions

global cell4
global tsne_idx
persistent origin_data

count=getappdata(handles.figure1,'count_interaction');
count=count+1;
if count==1
    origin_data=cell4;
end
setappdata(handles.figure1,'count_interaction',count);

cell4=origin_data;
samples={cell4(:).name};
[selection_samples,~] = listdlg('PromptString','Select samples to utilize:','ListString',samples);
cell4=origin_data(selection_samples);

% indexes_left=find(ismember(tsne_idx,selection_samples));
tsne_idx=[];
for i=1:length(cell4)
    tsne_idx=[ tsne_idx ones(1,length(cell4(i).data))*i];
end
handles=cell2clust(handles);

cmap=getappdata(handles.figure1,'cmap');
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
cluster_names=getappdata(handles.figure1, 'cluster_names');
markerlist=getappdata(handles.figure1,'selected_markers');
% uisave({'clustMembsCell','cmap','cluster_names'},'For_interaction.mat')
Interactions_Motifs(clustMembsCell,cmap,1,cluster_names,markerlist);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%% This callback is executed  any time the slider is moved

global tsne_map
global heatmap_selection

bandwidth=get(hObject,'Value');
[~,~,clustMembsCell] = HGMeanShiftCluster(tsne_map',bandwidth,'gaussian'); % Clustering in the tsne map is perfromed

handles.Edit_val = uicontrol(handles.figure1,'Style','text','String',[num2str(round(bandwidth,2)) '(' num2str(length(clustMembsCell)) ')' ],'Units','normalized','position', [0.02 0.925 0.03 0.02 ]);
try
    clustMembsCell(cellfun(@isempty,clustMembsCell))=[]; 
    setappdata(handles.figure1, 'clustMembsCell',clustMembsCell);  %Save the clusters
    clust2cell(handles)
    
    cluster_names=cell(1,length(clustMembsCell));  % Assign random names to clusters
    for i=1:length(clustMembsCell)
        cluster_names{i}=['Cluster' num2str(i)];
    end
    setappdata(handles.figure1,'cluster_names',cluster_names);
    
    setappdata(handles.figure1,'selection_markers',1);  %Chekc if a unique markers has been selected or the clustering one
    color_assignment( handles)                          % Assign the colors for each cluster according to the alogrithm described in the paper
    Update_Scatter(handles);                            % Update the colors of the tsne map
    Update_Tissue(handles);                             % Update the colors of the tissue samples
    heatmap_data(handles)                               % Updates the heatmap to correspond with the colors and points assigned to each cluster
    set(handles.uipanel4,'Visible','on')

    set(handles.figure1,'windowbuttonmotionfcn',@mousemove);
    heatmap_selection=[];
catch ME
    warndlg(ME.message)
    errordlg('Adjust the bandwidth accordingly')
end

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set( hObject, 'Min', 1, 'Max', 30, 'Value', 15 )


% --- Executes on button press in Markers.
function Markers_Callbacki(~, ~, handles)

Markers_Callback([], [], handles)

function Samples_Callbacki(~, ~, handles)

Samples_Callback([],[], handles)


% --------------------------------------------------------------------
function Find_Selection_Callback(hObject, eventdata, handles)
% hObject    handle to Find_Selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global find_selection

temp=listdlg('PromptString','Select samples to utilize:','ListString',{'Show previous selected samples'; 'Show only samples that have been selected'},'SelectionMode','single','InitialValue',find_selection + 1);
find_selection=temp -1;


% --------------------------------------------------------------------
function Export_data_Callback(hObject, eventdata, handles)
% hObject    handle to Export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_session_Callback(hObject, eventdata, handles)
% hObject    handle to Save_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tsne_map
global tsne_idx

markerlist=getappdata(handles.figure1,'selected_markers');
cluster_names=getappdata(handles.figure1, 'cluster_names');
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
cmap=getappdata(handles.figure1, 'cmap');
t_scatter=tsne_map;
T=getappdata(handles.figure1,'h_cluster');
tsne_idx=tsne_idx;

uisave({'clustMembsCell','cmap','t_scatter','cluster_names','T','tsne_idx','markerlist'},'clustered_data.mat')


% --------------------------------------------------------------------
function Save_csv_Callback(hObject, eventdata, handles)
% hObject    handle to Save_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tsne_idx
global cell4

point2cluster=horzcat(cell4(:).clusters);
r=uigetdir;
for i=1:length(cell4)
    t_idx=tsne_idx ==i;
    temo=point2cluster(t_idx)';
    temp_markers={ 'Phenotype' };
    my_csvwrite([r '\' cell4(i).name '.csv'],temo,temp_markers);
end

% --------------------------------------------------------------------
function Load_per_sample_Callback(hObject, eventdata, handles)
% hObject    handle to Load_per_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cell4
global heatmap_selection

[file,path] = uigetfile('*.csv','Select One or More Files',  'MultiSelect', 'on');
if length(cell4)~= length(file)
    warndlg('Not all samples have phneotypes')
end

temp=cellfun(@(x) strsplit(x,'.csv'),file,'uni',0);
temp=cellfun(@(x) x{1},temp,'uni',0);

zero_clust=0;
for i=1:length(file)
   ind=ismember(temp,{cell4(i).name});
   if isempty(find(ind, 1))
       warndlg(['Sample ' cell4(i).name ' has not assigned phenotype. All their cells will be assigned with a unique one'])
       cell4(i).clusters=zeros(1,size(cell4(i).data,1));
       zero_clust=[zero_clust i];
   else
       cell4(i).clusters= xlsread([ path '\' file{ind}])';
   end
end

for i=1:zero_clust
    cell4(i).clusters=ones(1,size(cell4(i).data,1))*(max(horzcat(cell4(:).clusters))+1);
end
num_clust=max(horzcat(cell4(:).clusters));

cluster_names=cell(1,num_clust);
for i=1:num_clust
    cluster_names{i}=['Cluster' num2str(i)];
end

handles=cell2clust(handles);
markers=getappdata(handles.figure1,'markers');
[selection_markers,~] = listdlg('PromptString','Select markers to utilize:','ListString',markers);

setappdata(handles.figure1,'selected_markers',selection_markers);       
setappdata(handles.figure1,'cluster_names',cluster_names);
setappdata(handles.figure1,'selection_markers',1);

color_assignment( handles)
try
    Update_Scatter(handles); 
catch
end

Update_Tissue(handles);
heatmap_data(handles)
set(handles.uipanel4,'Visible','on')

set(handles.figure1,'windowbuttonmotionfcn',@mousemove);
heatmap_selection=[];

% --------------------------------------------------------------------
function Load_per_phenotype_Callback(hObject, eventdata, handles)
% hObject    handle to Load_per_phenotype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global heatmap_selection
global tsne_idx

[file,path] = uigetfile('*.fcs','Select One or More Files',  'MultiSelect', 'on');
for i=1:length(file)
    [a,~]=fca_readfcs([path '\' file{i}]);
    clustMembsCell{i}=a(:,1);
end
setappdata(handles.figure1, 'clustMembsCell',clustMembsCell);

cluster_names=cell(1,length(clustMembsCell));
for i=1:length(clustMembsCell)
    cluster_names{i}=['Cluster' num2str(i)];
end


if ~isequal(length(vertcat(clustMembsCell{:})),length(tsne_idx))
    warndlg('Not all cells have an assigned phneotype')
    clustMembsCell{end+1}=setdiff([1:length(tsne_idx)],vertcat(clustMembsCell{:}));
    cluster_names{end+1}='Unclustered cells';
end

clust2cell(handles);
markers=getappdata(handles.figure1,'markers');
[selection_markers,~] = listdlg('PromptString','Select markers to utilize:','ListString',markers);

setappdata(handles.figure1,'selected_markers',selection_markers);       
setappdata(handles.figure1,'cluster_names',cluster_names);
setappdata(handles.figure1,'selection_markers',1);

color_assignment( handles)
try
    Update_Scatter(handles); 
catch
end

Update_Tissue(handles);
heatmap_data(handles)
set(handles.uipanel4,'Visible','on')

set(handles.figure1,'windowbuttonmotionfcn',@mousemove);
heatmap_selection=[];

% --------------------------------------------------------------------
function Export_fcs_file_Callback(hObject, eventdata, handles)
% hObject    handle to Export_fcs_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cell4
prev=0;
r=uigetdir;
for i=1:length(cell4)
    temo=1:length(cell4(i).idx);
    temo=temo+prev;
    temo=[temo' ones(length(cell4(i).idx),1)*(i) cell4(i).data];
    temp_markers=[ 'Cell_id'  'Image_id' cell4(1).cell_markers];
    fca_writefcs([r '\' cell4(i).name '_mean_aggregated.fcs'],temo,temp_markers,temp_markers);
    prev=prev+ length(cell4(i).idx);
end
% --------------------------------------------------------------------
function Export_csv_file_Callback(hObject, eventdata, handles)
% hObject    handle to Export_csv_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cell4
prev=0;
r=uigetdir;
for i=1:length(cell4)
    temo=1:length(cell4(i).idx);
    temo=temo+prev;
    temo=[temo' ones(length(cell4(i).idx),1)*(i) cell4(i).data];
    temp_markers=[ 'Cell_id'  'Image_id' cell4(1).cell_markers];
    my_csvwrite([r '\' cell4(i).name '_mean_aggregated.csv'],temo,temp_markers);
    prev=prev+ length(cell4(i).idx);
end


% --------------------------------------------------------------------
function Load_session_Callback(hObject, eventdata, handles)
% hObject    handle to Load_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% This callback loads a saved clustering 
global heatmap_selection
global tsne_map

[file,path] = uigetfile('*.mat');
temp=load([path '\' file]);

clustMembsCell=temp.clustMembsCell;
setappdata(handles.figure1,'clustMembsCell',clustMembsCell)
clust2cell(handles)

if ~isempty(temp.cluster_names)
    cluster_names=temp.cluster_names;
else
    cluster_names=cell(1,length(clustMembsCell));  % Assign random names to clusters
    for i=1:length(clustMembsCell)
        cluster_names{i}=['Cluster' num2str(i)];
    end
end
setappdata(handles.figure1,'cluster_names',cluster_names);
setappdata(handles.figure1,'selection_markers',1);

if ~isempty(temp.markerlist)
    markerlist=temp.markerlist;
else
    markers=getappdata(handles.figure1,'markers');
    [markerlist,~] = listdlg('PromptString','Select markers to utilize:','ListString',markers);
end
setappdata(handles.figure1,'selected_markers',markerlist);

if ~isempty(temp.cmap)
    cmap=temp.cmap;
    setappdata(handles.figure1, 'cmap',cmap);
else
    color_assignment( handles)
end


if ~isempty(temp.t_scatter) ; tsne_map=temp.t_scatter; end
try
    Update_Scatter(handles); 
catch
end

Update_Tissue(handles); 
Update_Scatter(handles); 
heatmap_data(handles)
set(handles.uipanel4,'Visible','on')
set(handles.uipanel1,'Visible','on')

set(handles.figure1,'windowbuttonmotionfcn',@mousemove);
heatmap_selection=[];
