function varargout = Interactions_Motifs(varargin)
% INTERACTIONS_MOTIFS MATLAB code for Interactions_Motifs.fig
%      INTERACTIONS_MOTIFS, by itself, creates a new INTERACTIONS_MOTIFS or raises the existing
%      singleton*.
%
%      H = INTERACTIONS_MOTIFS returns the handle to a new INTERACTIONS_MOTIFS or the handle to
%      the existing singleton*.
%
%      INTERACTIONS_MOTIFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERACTIONS_MOTIFS.M with the given input arguments.
%
%      INTERACTIONS_MOTIFS('Property','Value',...) creates a new INTERACTIONS_MOTIFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interactions_Motifs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interactions_Motifs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interactions_Motifs

% Last Modified by GUIDE v2.5 31-Oct-2019 17:06:28

% In this pat of the tool the interactive analysis of cellular
% microenvironment is performed

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interactions_Motifs_OpeningFcn, ...
                   'gui_OutputFcn',  @Interactions_Motifs_OutputFcn, ...
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


% --- Executes just before Interactions_Motifs is made visible.
function Interactions_Motifs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interactions_Motifs (see VARARGIN)


global cell4
global tsne_idx

num_of_samples=length(cell4);

clustMembsCell=varargin{1};
cmap=varargin{2};
value1=varargin{3};
cluster_names=varargin{4};
markerlist=varargin{5};

setappdata(handles.figure1,'markerlist',markerlist);
setappdata(handles.figure1,'cluster_names',cluster_names);
setappdata(handles.figure1,'clustMembsCell',clustMembsCell);
setappdata(handles.figure1,'cmap',cmap);

%% Identifying the distance that defines microenvironment
prompt={'Distnace (in pixels) that makes 2 cells adjacent'};
dlg_title='Input';
num_lines=1;
defaultans={'5'};
x=inputdlg(prompt,dlg_title,num_lines,defaultans);
number_of_pixels=str2num(x{:}); 

%% Detect which are actually the neighbors of each cell
for i=1:num_of_samples
    [cell4(i).neighlist]=neighlist_creation(cell4(i),number_of_pixels);
end

numClust=length(clustMembsCell);
point2cluster=horzcat(cell4(:).clusters);


%% Assigns to a row of a matrix the neighbors of each cell
ag_neigh=vertcat(cell4(:).neighlist)';
clusteri=zeros(length(ag_neigh),max(cellfun('size',ag_neigh,1)));
for i=1:length(ag_neigh)
    norm_fac=find(tsne_idx == tsne_idx(i),1)-1;  
    temp=ag_neigh{i}+norm_fac;
    temp(temp == norm_fac)=0;
    clusteri(i,1:length(ag_neigh{i}))=temp;
end
tmp=clusteri+1;
tmp2=[0 point2cluster];
cluster_of_neigh_cells=tmp2(tmp);

%% Calculates a matrix where each row represents the relative frequency of a cell to colocalize with a cluster
n_neigh=zeros(length(tsne_idx),numClust);
for i=1:length(tsne_idx)
    tmp=cluster_of_neigh_cells(i,:);
    tmp(tmp==0)=[];
    if isempty(tmp); continue; end
    a_counts = accumarray(tmp(:),1);
    n_neigh(i,1:length(a_counts))=a_counts;
end
norm_neigh=n_neigh./sum(n_neigh,2);
norm_neigh(isnan(norm_neigh))=0;

%% Calculate the relative frequency of colocalization among the clusters 
cooc=zeros(numClust);
cooc2=zeros(numClust);

for i=1:numClust
    tmp=n_neigh(point2cluster==i,:);
    if size(tmp,1)==1
        cooc(i,:)=tmp;
    else
        cooc(i,:)=sum(tmp);
    end
    tmp=tmp>0;
    if size(tmp,1)==1
        cooc2(i,:)=tmp;
    else
        cooc2(i,:)=sum(tmp);
    end
end
new_cooc=cooc./sum(cooc,2);

setappdata(handles.figure1,'new_cooc',new_cooc);
setappdata(handles.figure1,'clusteri',clusteri);
setappdata(handles.figure1,'cooc_overall',cooc);
setappdata(handles.figure1,'cooc_overall_uni',cooc2);

setappdata(handles.figure1,'norm_neigh_list',norm_neigh);

%% The interaction heatmap is presented
hfig1=handles.uipanel1;
set(hfig1,'Tag','heatmap_int')
Interaction_heatmap(hfig1,new_cooc',(cell2mat(cellfun(@length,clustMembsCell,'UniformOutput',false))),handles,clusteri);

d = uicontextmenu(get(hfig1,'Parent'));
uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig1});
set(hfig1,'UIContextMenu',d);
%% The existance and significance of the motifs is calculated
[z,fr,motifs,idx_motif_cells,out,motif_idx]=permutation2_test(clusteri,point2cluster'); 
global val
setappdata(handles.figure1,'First_val',val);

%% The illustration of the motifs is performed
hfig2=handles.uipanel2;
set(hfig2,'Tag','Motifs')
Motif_Creation_CallBack( hfig2,handles,z,fr,motifs,idx_motif_cells,motif_idx )
setappdata(handles.figure1,'z',z);
setappdata(handles.figure1,'fr',fr);
setappdata(handles.figure1,'motifs',motifs);
setappdata(handles.figure1,'idx_motif_cells',idx_motif_cells);
setappdata(handles.figure1,'motif_idx',motif_idx);
setappdata(handles.figure1,'hfig',hfig2);

d = uicontextmenu(get(hfig2,'Parent'));
uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig2});
set(hfig2,'UIContextMenu',d);

hfig3=handles.uipanel3;
set(hfig3,'Tag','Images_panel');
setappdata(handles.figure1,'selection_samples',[1:length(cell4)]);
setappdata(handles.figure1,'selection_markers',1);
setappdata(handles.figure1,'Tissue_Figure',hfig3);
Update_Tissue(handles)

d = uicontextmenu(get(hfig3,'Parent'));
uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig3});
set(hfig3,'UIContextMenu',d);
        
set(handles.figure1,'windowbuttonmotionfcn',{@mousemove_interaction,handles});

% Choose default command line output for Interactions_Motifs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.uipanel1,'BackgroundColor',[1 1 1]);
set(handles.uipanel3,'BackgroundColor',[1 1 1]);
% set(0,'defaultfigurecolor',[1 1 1])

% UIWAIT makes Interactions_Motifs wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set( findall( gcf, '-property', 'Units' ), 'Units', 'Normalized' ) %in order to make window resizable


% --- Outputs from this function are returned to the command line.
function varargout = Interactions_Motifs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Export_Interactions_Callback(hObject, eventdata, handles)
% hObject    handle to Export_Interactions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

temp=getappdata(handles.figure1,'cooc_overall');
temp2=getappdata(handles.figure1,'cooc_overall_uni');
temp3=repmat([1:length(temp2)],length(temp2),1);

[file,name,~] = uiputfile('.csv','Colocalization_per_phneotype');
my_csvwrite([name '\' file],[temp3(:) reshape(temp3',[],1)  reshape(temp',[],1) reshape(temp2',[],1)],{'Phenotype of interest', 'Phneotype of microenvironment','Counts of all the colocalized cells','Counts of at least one colocalized cell'});
