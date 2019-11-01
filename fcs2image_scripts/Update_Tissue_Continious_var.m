 function Update_Tissue_Continious_var(handles)

% Updates the colors of the cells in the images according to the assigned
% specific feature 
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global n_data
global tsne_idx
global cell4

%% Asign figure handlers and initialize the viewer 
f_images=getappdata(handles.figure1,'Tissue_Figure');

markers=getappdata(handles.figure1,'markers');
selection_markers=getappdata(handles.figure1,'selection_markers');
if isempty(selection_markers); warndlg('Please select markers');   return; end

selection_markers=selection_markers -1;
selection_samples=getappdata(handles.figure1,'selection_samples');
number_=length(selection_markers)*length(selection_samples);


valuemax=max(n_data(:,selection_markers(1)));
minvalue=min(n_data(:,selection_markers(1)));


subplot = @(n) subtightplot (ceil(number_/floor(sqrt(number_))),floor(sqrt(number_)),  n, [0.025 0.001], [0.001 0.065], [0.001 0.001]);

delete(get(f_images,'Children'));
uicontrol(f_images,'Style', 'pushbutton', 'String', 'Samples','Units','normalized','position', [0.1 0.96 0.2 0.025 ], 'callback', {@ Samples_Callback, handles});
uicontrol(f_images,'Style', 'pushbutton', 'String', 'Markers','Units','normalized','position', [0.7 0.96 0.2 0.025 ], 'callback', {@ Markers_Callback, handles});
if isempty(selection_samples); warndlg('Please select samples');   return; end

try
    set(0, 'currentfigure', get(f_images,'Parent'));  
catch
    set(0, 'currentfigure', f_images);
end
axes(f_images)
counter=0;

if length(selection_markers)==1
   try
        f_images.Title=markers{selection_markers};
   catch
        f_images.Name=markers{selection_markers};
   end
elseif length(selection_samples)==1
    try
        f_images.Title=cell4(selection_samples).name;
    catch
        f_images.Name=cell4(selection_samples).name;
    end
else
   errordlg('Wrong combination of samples is selected')
end

%% For each selected sample and selected marker
for i=selection_samples
    for ii=selection_markers
        counter=counter+1;

%% Color each pixel according to the assigned feature 
        val=n_data(tsne_idx == i,ii);   
        cellmask=cell4(i).mask_cell;
        cellmask(cell4(i).cell_borders)=0;
        val2=[0 ; val];
        temp=val2(cellmask+1);

        tissue(counter)=subplot(counter); 
        fg=imagesc(tissue(counter),temp);
        pbaspect(tissue(counter),[size(temp,2) size(temp,1) 1])

%% Impose the bakcground
        rgbI=zeros(size(temp,1),size(temp,2),3);
        hold(tissue(counter),'on');
        hOVM = image(tissue(counter),rgbI);
        set(hOVM, 'AlphaData', ~cellmask); 
        hold(tissue(counter),'off');

% Impose a transparent layer in order to use for highlighting cells
        hold(tissue(counter),'on');
        hOVM2 = image(tissue(counter),~rgbI);
        hold(tissue(counter),'off');
        set(hOVM2,'Visible','off');
        set(hOVM2,'PickableParts','none');

        setappdata(handles.figure1, [ 'image' num2str(counter)], hOVM2)

        set(tissue(counter),'XColor','none');
        set(tissue(counter),'YColor','none');

        caxis(tissue(counter),[minvalue valuemax])
        colormap(tissue(counter),viridis)

        norm_fac=find(tsne_idx == i,1)-1;
        set(hOVM,'ButtonDown',{@Image_Callback_cont,norm_fac,handles});

%% Add a contect menu in order to be possible to brush image areas
        try
            d = uicontextmenu(get(f_images,'Parent'));
            Interact_per_point = uimenu('Parent',d,'Label','Point');
            uimenu('Parent',Interact_per_point,'Label','Brush','Callback',{@Image_Context_Menu,i,handles});
            set(hOVM,'UIContextMenu',d);
        catch 
        end
        
        if length(selection_markers)==1
            title(tissue(counter),[cell4(i).name],'Interpreter','None');
        elseif length(selection_samples)==1
            title(tissue(counter),[markers{ii}],'Interpreter','None');
        else
            errordlg('Wrong combination of samples is selected')
        end
        setappdata(handles.figure1,[ 'Tissue_axes' num2str(i)],tissue(counter)); %we save each axes different in order to retrieve it also seperately
    end
end


ch=colorbar(tissue(counter),'southoutside');
set(ch,'ButtonDown',{@colormapCallBack_all,tissue})
set(ch,'Position',[ 0.35 0.957 0.3 0.025])

try 
        set(sc,'ButtonDown',{@Image_Callback_cont,0,handles});
catch
%         warning('There is no tsne map yet')
end
