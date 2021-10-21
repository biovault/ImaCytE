function  Cell_Abundance_environment_creation(~,~,handles)

global cell4
global values_selection             
values_selection=1;

% zoom off

hfig=getappdata(handles.figure1,'cell_type_fig');
if isempty(hfig)
    hfig = figure('WindowButtonUpFcn',{@dropObject,handles},'units','normalized','WindowButtonMotionFcn',@moveObject,'Name','Cell Type Abundances','NumberTitle','off','Color','White');
    setappdata(handles.figure1,'cell_type_fig',hfig);
elseif ~isvalid(hfig)
    hfig = figure('WindowButtonUpFcn',{@dropObject,handles},'units','normalized','WindowButtonMotionFcn',@moveObject,'Name','Cell Type Abundances','NumberTitle','off','Color','White');
    setappdata(handles.figure1,'cell_type_fig',hfig);
end

%% Calculate the abundances

numClust=max(horzcat(cell4(:).clusters));
per_image_clusters=zeros(length(cell4),numClust);
for i=1:length(cell4)
    temp=accumarray(cell4(i).clusters',1)';
    per_image_clusters(i,1:length(temp))=temp;
end
setappdata(handles.figure1,'per_image_clusters',per_image_clusters);

num_subplots=6;
% subplot = @(n) subtightplot (num_subplots,1,  n, [0.04 0.05], [0.05 0.05], [0.05 0.05]);
tabgp = uitabgroup(hfig,'units','normalized','outerposition',[0 0 1 0.8]);

temp_ax=axes(hfig,'Position',[0.45 0.90 0.1 0.04]);
title(temp_ax,'Drop area');
set(temp_ax,'XColor','none')
set(temp_ax,'YColor','none')
set(temp_ax,'TitleFontSizeMultiplier',2)
set(temp_ax,'TitleFontWeight','normal')

total_num=ceil((numClust)/num_subplots);
tab=cell(1,total_num);
for i=1:total_num
    tab{i}=uitab(tabgp,'Title',num2str(i));
    set(tab{i},'BackgroundColor',[1 1 1]);
    try 
        d = uicontextmenu(get(hfig,'parent'));
        uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig, handles});
        set(tab{i},'UIContextMenu',d);
    catch
    end
end
% setappdata(handles.figure1,'tabgroup_cell_abundance',tab);

% num_subplots=6;
% tab=getappdata(handles.figure1,'tabgroup_cell_abundance');
% total_num=ceil((numClust)/num_subplots);
temp_pos=zeros(total_num,4);
temp_tab=cell(1,total_num);
for i=1:numClust
        ax_=axes(tab{ceil(i/num_subplots)});
        if mod(i,num_subplots) == 0
%             ax(i)=subplot(num_subplots);
            ax(i)=subplot (num_subplots,1,num_subplots,ax_);
        else
            ax(i)=subplot (num_subplots,1,mod(i,num_subplots), ax_);
%             ax(i) = subplot(mod(i,num_subplots));
        end
        temp_pos(i,:)=get(ax(i),'Position');
        temp_tab{i}=tab{ceil(i/num_subplots)};
        d = uicontextmenu;
        uimenu('Parent',d,'Label','Filter','Callback',{@Brush_context_menu,handles,i});
        uimenu('Parent',d,'Label','Reset','Callback',{@Brush_context_menu,handles,i});
        set(ax(i),'UIContextMenu',d);   
end
setappdata(handles.figure1,'initial_pos',temp_pos);
setappdata(handles.figure1,'initial_tab',temp_tab);
setappdata(handles.figure1,'axes_cell_abundance',ax);


Cell_Abundance_creation([],[],handles)
%% Create order selection functionality

bg = uibuttongroup(hfig,'Visible','off',...
                  'Position',[0.13 0.005 0.78 0.04],...
                  'BackgroundColor',[1 1 1],... 
                  'Title','Reordering');  
              
Ascending_button = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Ascending',...
                  'BackgroundColor',[1 1 1],...
                  'Value',0,...
                  'Callback', {@Cell_Abundance_Selection_CallBack,handles});
Ascending_button.Units= 'normalized';
Ascending_button.Position= [0.6 0.1 0.2 0.8];
Ascending_button.Enable='off';

Descending_button = uicontrol(bg,'Style','radiobutton',...
                  'String','Descending',...
                  'BackgroundColor',[1 1 1],...
                  'Value',1,...
                  'Callback', {@Cell_Abundance_Selection_CallBack,handles});
Descending_button.Units= 'normalized';            
Descending_button.Position= [0.8 0.1 0.2 0.8];
Descending_button.Enable='off';

metrics={'Silhouette','Davies-Bouldin','Calinski-Harabasz','Krzanowski- Lai','Dunn','Bhattacharyya','DTW','Clustering validity index'};
Metrics = uicontrol( bg,'Style', 'popup',...
           'String', metrics,...
           'Callback', {@Cell_Abundance_Selection_CallBack,handles}); 
set(Metrics,'Units','normalized')
set(Metrics,'Position',[0.3 0.1 0.25 0.8]);
Metrics.Enable='off';
Metrics.Tag='Metrics';


Seperability_checkbox = uicontrol( bg,'Style', 'checkbox',...
           'String', 'Seperability metric',...
           'BackgroundColor',[1 1 1],... 
           'Callback', {@Cell_Abundance_Selection_CallBack,handles}); 
set(Seperability_checkbox,'Units','normalized')
set(Seperability_checkbox,'Position',[0 0.1 0.3 0.8]);
bg.Visible = 'on';

%% Create values representation selection

bg1 = uibuttongroup(hfig,'Visible','off',...
                  'Position',[0.02 0.74 0.4 0.035],...
                  'BackgroundColor',[1 1 1],... 
                  'Title','Values');

Absolute = uicontrol(bg1,'Style',...
                  'radiobutton',...
                  'String','Absolute',...
                  'BackgroundColor',[1 1 1],...
                  'Callback', {@Cell_Abundance_Selection_CallBack,handles});
Absolute.Units= 'normalized';
Absolute.Position= [0 0.1 0.5 0.8];
Relative = uicontrol(bg1,'Style','radiobutton',...
                  'String','Relative',...
                  'BackgroundColor',[1 1 1],...
                  'Value',1,...
                  'Callback', {@Cell_Abundance_Selection_CallBack,handles});
Relative.Units= 'normalized';            
Relative.Position= [0.5 0.1 0.5 0.8];
bg1.Visible = 'on';


%% Create search selection funcitonality
Metrics = uicontrol( hfig,'Style', 'edit',...
           'String', {'Search here a cell type'},...
           'Callback', {@Cell_Abundance_Selection_CallBack,handles}); 
set(Metrics,'Units','normalized')
set(Metrics,'Position',[0.45 0.74 0.25 0.03]);
