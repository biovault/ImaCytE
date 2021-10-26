function Update_Tissue_2(handles)

% Updates the colors of the cells in the images according to the assigned cluster
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

if isempty(getappdata(handles.figure1,'tissue_samples')); return ;end

global cell4
all_selection_samples=getappdata(handles.figure1,'selection_samples');
cmap=getappdata(handles.figure1,'cmap');
%% Asign figure handlers and initialize the viewer 
num_cohorts=max([cell4(:).cohort]);
for i=1:num_cohorts
    f_images{i}=getappdata(handles.figure1,['cohort_panel' num2str(i)]);
    if isempty(all_selection_samples); delete(get(f_images{i},'Children')); end
    uicontrol(f_images{i},'Style', 'pushbutton', 'String', 'Samples','Units','normalized','position', [0.4 0.975 0.2 0.025 ], 'callback', {@ Samples_Callback_2, handles});

    if ~isempty(all_selection_samples)
        temp=all_selection_samples(all_selection_samples(:,2)==i,1);
        selection_samples=find([cell4(:).cohort]==i);
        selection_samples=selection_samples(temp);
    else
        selection_samples=[];
    end
    if isempty(selection_samples) 
        continue; 
    end
    aspect_ratio=get(f_images{1},'Parent');
    aspect_ratio=aspect_ratio.PaperPosition;
    aspect_ratio=aspect_ratio(3)/(aspect_ratio(4)/2);

    subplot = @(n) subtightplot (floor(sqrt(length(selection_samples))),ceil(length(selection_samples)/floor(sqrt(length(selection_samples)))),  n, [0.025 0.001], [0.001 0.065], [0.001 0.001]);

    try
        set(0, 'currentfigure', get(f_images{i},'Parent'));  %# for figures
    catch
        set(0, 'currentfigure', f_images{i});
    end
    axes(f_images{i});
    counter=0;
    %% For each selected sample
    for j=selection_samples  
        counter=counter+1;
        norm_fac=size(vertcat(cell4(1:i-1).idx),1);

    %% Color each pixel according to the assigned cluster 
        temp=cell4(j).mask_cell;
%         temp(cell4(j).cell_borders)=0;
        one_vec=reshape(temp,[],1);
        one_vec=one_vec +1;
        colors2=[0 0 0; cmap(cell4(j).clusters,:)];
        one_vec_c=colors2(one_vec,:);
        new_img=reshape(one_vec_c,size(cell4(j).mask_cell,1),size(cell4(j).mask_cell,2),3);

     %% Plot the colored image
        tissue=subplot(counter);
        fg=image(tissue,new_img);
        pbaspect(tissue,[size(new_img,2) size(new_img,1) 1])
        setappdata(handles.figure1, [ 'image' num2str(j)], fg)

        set(tissue,'XColor','none');
        set(tissue,'YColor','none');

        set(fg,'ButtonDown',{@Image_Callback_2,norm_fac,handles});
    %     imwrite(fg.CData,  [  '\' cell4(i).name '_Clustered_data'  '.png'])

    %% Add a contect menu in order to be possible to brush image areas
        try  
            title(tissue,[cell4(j).name],'Interpreter','None');
        catch
        end
    end
end
% set(handles.figure1,'windowbuttonmotionfcn',@mousemove);

