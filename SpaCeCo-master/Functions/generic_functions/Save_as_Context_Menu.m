function Save_as_Context_Menu(~,~,f_images,handles)

% Callback function that saves all the images are illustrated in the image
% viewer of the tool
%   - f_images: handlers of the images to be saved

%   Copyright 2020 Mirtech, Inc.
%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
temp_1=get(f_images,'Tag');
img_types={'*.svg' ; '*.tiff' ; '*.jpeg' ; '*.png'};

switch temp_1
    case 'tsne_plot'
        f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
        temp=get(f_images,'Children');
        copyobj(temp,f);
        [file,name,~] = uiputfile(img_types,'tsne_plot');
        saveas(f,[name '\' file]);
    case 'Images_panel'
        temp=get(f_images,'Children');
        all=temp;
        selpath = uigetdir;
        for i=1:length(all)
            if isa(all(i),'matlab.graphics.axis.Axes')        
                f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
                s = copyobj(all(i),f);
                set(s,'Units','Pixels')
                counter=find(strcmp(all(i).Title.String , {cell4(:).name}));
                if isempty(counter)
                    counter=find(strcmp(f_images.Title , {cell4(:).name}));
                end
                set(s,'Position',[1 1 size(cell4(counter).cell_borders,2) size(cell4(counter).cell_borders,1)]);
                F = getframe(s);
                Image = frame2im(F);
                imwrite(Image,  [ selpath '\' all(i).Title.String '_' f_images.Title '.tiff'])
            end
        end
    case 'heatmap'
        f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
        temp=get(f_images,'Children');
        copyobj(temp,f);
        colormap(f,viridis);
        [file,name,~] = uiputfile(img_types,'heatmap');
        saveas(f,[name '\' file]);
    case 'heatmap_int'
        f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
        temp=get(f_images,'Children');
        copyobj(temp,f);
        colormap(f,redblueTecplot);
        [file,name,~] = uiputfile(img_types,'heatmap');
        saveas(f,[name '\' file]);
    case 'Motifs'
        z=getappdata(handles.figure1,'z');
        f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
        caxis([min(z) max(z)])
        colormap(flipud(gray))
        temp=get(f_images,'Children');
        copyobj(temp,f);
        [file,name,~] = uiputfile(img_types,'motifs');
        saveas(f,[name '\' file]);
        
end
end
