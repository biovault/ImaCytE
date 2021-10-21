function my_density_graph(handles,axes_figure,cohort_values,cluster_name,cluster_color,num)

%  Function creating each raincloud plot
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - axes_figure: axes object defining the place the raincloud will be plotted
%   - cohort_values: cell array, where each cell contains the values of each cohort
%   - cluster_name: cell which contains the label of the speicfic raincloud
%   plot.
%   - cluster_color: RGB triplet defining the color which the name of label is colored
%   - num: unique number defining the ordering of the raincloud plots in the small multiples view.

%   Copyright 2020 Antonios Somarakis (LUMC)

colors(1,:)=[240 69 0]/255; %'orange';
colors(2,:)=[0 171 240]/255; %'cyan';
setappdata(handles.figure1,'cohort_colors',colors)
transparancy_param=1;

if max(vertcat(cohort_values{:}))~=0
    max_val=max(vertcat(cohort_values{:}));
else
    max_val=1;
end
bnd=max_val/50;
max_val=max_val+bnd;
steps=linspace(0,max_val);
f=cell(1,numel(cohort_values));
for i=1:numel(cohort_values)
    if ~isempty(cohort_values{i})
        f{i}= ksdensity(cohort_values{i},steps,'Bandwidth',bnd);
    else
        f{i}=zeros(1,numel(steps));
    end
    X=[steps,fliplr(steps)];                %#create continuous x value array for plotting
    Y=[zeros(1,numel(f{i})),fliplr(f{i})];              %#create y values for out and then back
    fill1=fill(axes_figure,X,Y,colors(i,:),'FaceAlpha',transparancy_param,'EdgeAlpha',0);  
    fill1.ButtonDownFcn={@Cell_Abundance_Cohort_ButtonDown,handles};
    hold(axes_figure,'on')
end
axes_figure.Box='off';
axes_figure.YColor=[1 1 1];
X=[steps,fliplr(steps)];  %#create continuous x value array for plotting
Y=(f{2}<f{1}).*f{2} + (f{1}<f{2}).*f{1};
Y=[zeros(1,numel(Y)),fliplr(Y)];              %#create y values for out and then back
fill(axes_figure,X,Y,[240  240  240 ]/255,'FaceAlpha',1,'EdgeAlpha',0.5,'Tag','White_parts');
hold(axes_figure,'off')

set(axes_figure,'xlim',[0 max_val])
line_height=max(horzcat(f{:}))/4;
for i=1:numel(cohort_values)
    lines_below(handles,axes_figure,cohort_values{i},colors(i,:),line_height,transparancy_param,max_val,num,i);
end

hold(axes_figure,'off')
set(axes_figure,'YTickLabel',[])
set(axes_figure,'YTick',[]);
ylabel(axes_figure,cluster_name,'Color',cluster_color,'FontWeight','bold','FontSize',8.5,'Interpreter','None') %10.5
set(axes_figure,'ylim',[-line_height  max(horzcat(f{:}))]); 


function lines_below(handles,axes_figure,values,color,line_height,transparancy_param,max_val,num,cohort_num)
offset= max_val/500;
wy=[0 0  -line_height -line_height];
temp2=[-1 1];
temp=values + offset.*temp2 ;
wx=[temp fliplr(temp)];
for i=1:numel(values)
    patch(axes_figure,wx(i,:),wy,color,'FaceAlpha',transparancy_param,'EdgeAlpha',0,'Tag',[num2str(i) ' ' num2str(cohort_num)],'ButtonDownFcn',{@Cell_Abundance_Sample_ButtonDown,handles,num});
end
