function Save_as_Context_Menu(~,~,f_images,handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
selpath = uigetdir;
% selpath='C:\Users\asomarakis\Desktop\samples_to_delete\dddd\';
temp=get(f_images,'Children');
all=temp;
% counter=0;
for i=1:length(all)
    if isa(all(i),'matlab.graphics.axis.Axes')
%         delete(get(all(i),'Parents'));
%         delete(get(all(i),'Children'));
        old_1=get(all(i),'Position');
        old_2=get(all(i),'Units');
        
        f=figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1],'Visible','off');
        s = copyobj(all(i),f);
        set(s,'Units','Pixels')
        counter=find(strcmp(all(i).Title.String , {cell4(:).name}));
        if isempty(counter)
                    counter=find(strcmp(f_images.Title , {cell4(:).name}));
        end
        set(s,'Position',[1 1 size(cell4(counter).cell_borders,2) size(cell4(counter).cell_borders,1)]);
        
        
        F = getframe(s);
        
%         set(all(i),'Units',old_2);
%         set(all(i),'Position',old_1);
        
        Image = frame2im(F);
%         isequal([size(cell4(counter).cell_borders,2) size(cell4(counter).cell_borders,1)],[size(Image,1) size(Image,2)])
        imwrite(Image,  [ selpath '\' all(i).Title.String '_' f_images.Title '.tiff'])

%         counter=counter+1;
%         temp=getappdata(handles.figure1, [ 'image' num2str(find(strcmp(all(i).Title.String , {cell4(:).name})))]);        
%         imwrite(temp.CData,  [ selpath '\' all(i).Title.String '_' f_images.Title '.tiff'])
    end
end