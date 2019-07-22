function Save_as_Context_Menu(~,~,f_images)

% Callback function that saves all the images are illustrated in the image
% viewer of the tool
%   - f_images: handlers of the images to be saved

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
selpath = uigetdir;
temp=get(f_images,'Children');
all=temp;
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