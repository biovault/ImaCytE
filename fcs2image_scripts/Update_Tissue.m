function Update_Tissue(handles)

% Updates the colors of the cells in the images according to the assigned cluster
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_idx
global cell4

%% Asign figure handlers and initialize the viewer 
f_images=getappdata(handles.figure1,'Tissue_Figure');
selection_samples=getappdata(handles.figure1,'selection_samples');

clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numClust=length(clustMembsCell);
for i=1:numClust
    point2cluster(clustMembsCell{i})=i;
end

cmap=getappdata(handles.figure1,'cmap');
colors=cmap(point2cluster,:);

delete(get(f_images,'Children'));
uicontrol(f_images,'Style', 'pushbutton', 'String', 'Samples','Units','normalized','position', [0.1 0.96 0.2 0.025 ], 'callback', {@ Samples_Callback, handles});
uicontrol(f_images,'Style', 'pushbutton', 'String', 'Markers','Units','normalized','position', [0.7 0.96 0.2 0.025 ], 'callback', {@ Markers_Callback, handles});

if isempty(selection_samples); warndlg('Please select samples');   return; end

subplot = @(n) subtightplot (ceil(length(selection_samples)/floor(sqrt(length(selection_samples)))),floor(sqrt(length(selection_samples))),  n, [0.025 0.001], [0.001 0.065], [0.001 0.001]);
   
try
    set(0, 'currentfigure', get(f_images,'Parent'));  %# for figures
catch
    set(0, 'currentfigure', f_images);
end
axes(f_images);
counter=0;

try
    f_images.Title='Clustered Data';
catch
    f_images.Name='Clustered Data';
end

%% For each selected sample
for i=selection_samples  
    counter=counter+1;
    norm_fac=find(tsne_idx == i,1)-1;  

%% Color each pixel according to the assigned cluster 
    temp=cell4(i).mask_cell;
    temp(cell4(i).cell_borders)=0;
    one_vec=reshape(temp,[],1);
    one_vec=one_vec +1;
    colors2=[0 0 0; colors(tsne_idx==i,:)];
    one_vec_c=colors2(one_vec,:);
    new_img=reshape(one_vec_c,size(cell4(i).mask_cell,1),size(cell4(i).mask_cell,2),3);

 %% Plot the colored image
    tissue=subplot(counter);
    fg=image(tissue,new_img);
    pbaspect(tissue,[size(new_img,2) size(new_img,1) 1])
    setappdata(handles.figure1, [ 'image' num2str(i)], fg)
    
    set(tissue,'XColor','none');
    set(tissue,'YColor','none');
    
    set(fg,'ButtonDown',{@Image_Callback,norm_fac,point2cluster,handles});
%     imwrite(fg.CData,  [  '\' cell4(i).name '_Clustered_data'  '.png'])

%% Add a contect menu in order to be possible to brush image areas
    try  
        d = uicontextmenu(get(f_images,'Parent'));
        Interact_per_point = uimenu('Parent',d,'Label','Point');
        uimenu('Parent',Interact_per_point,'Label','P.Select','Callback',{@Image_Context_Menu,i,handles,point2cluster});
        uimenu('Parent',Interact_per_point,'Label','P.Brush','Callback',{@Image_Context_Menu,i,handles,point2cluster});
        set(fg,'UIContextMenu',d);
        title(tissue,[cell4(i).name],'Interpreter','None');
        setappdata(handles.figure1,[ 'Tissue_axes' num2str(i)],tissue); %we save each axes different in order to retrieve it also seperately    
    catch
    end
end

set(handles.figure1,'windowbuttonmotionfcn',@mousemove);

