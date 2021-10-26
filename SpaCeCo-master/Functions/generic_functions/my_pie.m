function [handler,mean_val,std_val]=my_pie(handles,idx_motif_cells,motif_idx,fr,ax_,z)

% Creates the motif representation 
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - idx_motif_cells: a matrix which shows for each cells(row) of those grouped under this motif the relative frequency of having a cluster (column) in their microenvironment 
%   - motif_idx: a vector for the cluster of the cells of each motif
%   - fr: vector with the relative frequency regarding the cluster of a cell for each motif
%   - ax: the axis object where the scatter plot will be presented
%   - z : vector with the z-score value of each motif

%   Copyright 2020 Mirtech, Inc.

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

flag=1;
i=0;
if nargin <5
    f=figure;
    ax_=axes(f);
    flag=0;
elseif nargin <6
    flag=0;
end

std_val=[];
if size(idx_motif_cells,1)==1
    mean_val2=idx_motif_cells;
else
    mean_val2=mean(idx_motif_cells);
end
mean_val=mean_val2(mean_val2 ~=0);
r_s=(0.1+power(fr,1/2))*0.45;

cmap2=getappdata(handles.figure1,'cmap');
cmap2=cmap2(1:size(idx_motif_cells,2),:);


if isempty(mean_val)  % In case that the motif represents cells with none cell in their microenvironment
    th_ = linspace(0,2*pi, 100) ;
    r=0.6;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(2)=patch(ax_,x_,y_,[1 1 1]) ;
    set(handler(2),'EdgeColor',[1 1 1 ]);
    
    handler(1)=plot_central_blob(motif_idx,cmap2,r_s,ax_);
elseif length(mean_val)==1 % In case that the motif represents cells with cells from one cluster type in their microenvironment
    cmap=cmap2(find(mean_val2),:);
    i=1;
    th_ = linspace(0,2*pi, 100) ;
    r=1;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(4)=patch(ax_,x_,y_,cmap) ;
    set(handler(4),'EdgeColor',cmap);
    
    r=0.6;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(2)=patch(ax_,x_,y_,[1 1 1]) ;
    set(handler(2),'EdgeColor',[1 1 1 ]);
    
    th_ = linspace(0,0, 100) ;
    r=1;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(3)=patch(ax_,x_,y_,[1 1 1]) ;

    handler(1)=plot_central_blob(motif_idx,cmap2,r_s,ax_);
else % In case that the motif represents cells with cells from two or more cluster types in their microenvironment
    cmap=cmap2(find(mean_val2),:);
    
    if size(idx_motif_cells,1)==1
        std_val=zeros(1,size(idx_motif_cells,2));
    else
        std_val=std(idx_motif_cells);
    end
    std_val=std_val(mean_val2 ~=0);
    
    per_mean_val=2*pi*mean_val;
    per_std_val=2*pi*std_val;

    epsilon=pi/48;
    epsilon2=pi/36;

    init_angle=0;

    for i=1:length(mean_val)
        th_ = linspace(init_angle,init_angle+per_mean_val(i)-epsilon, 100) ;
        r=1;
        x_ = r*cos(th_) ;
        y_ = r*sin(th_) ;
        handler((i+1)*2)=patch(ax_,[0 x_],[0 y_],cmap(i,:)) ;  % I am using random color in patch here.
        set(handler((i+1)*2),'EdgeColor',cmap(i,:));
        hold on;
        th_=linspace(init_angle+ per_mean_val(i)-epsilon - epsilon2 - per_std_val(i),init_angle+ per_mean_val(i)-epsilon - epsilon2,100);
        r=0.9;
        x_=r*cos(th_);
        y_=r*sin(th_);
        handler((i+1)*2-1)=patch(ax_,[0 x_],[0 y_],[ 1 1 1]);
        set(handler((i+1)*2-1),'EdgeColor',[1 1 1 ]);
        hold on
        init_angle=init_angle+per_mean_val(i);
    end

    th_ = linspace(0,2*pi, 100) ;
    r=0.6;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(2)=patch(ax_,x_,y_,[1 1 1]) ;
    set(handler(2),'EdgeColor',[1 1 1 ]);

    handler(1)=plot_central_blob(motif_idx,cmap2,r_s,ax_);

end

if flag   % Plots the glyph that represents the z-score
    handler(i*2+3)=patch(ax_,[1 0.45 1],[1 1 0.45],z);
    caxis([0 1]);
end

set(ax_,'ylim',[-1 1])
set(ax_,'xlim',[-1 1])
set(ax_, 'visible', 'off')
set(ax_,'PlotBoxAspectRatio',[1 1 1])

function handler=plot_central_blob(init_blob,cmap2,r_s,ax_)   % Plots the center of each motif
    th_ = linspace(0,2*pi, 100) ;
    if length(init_blob) == 1    
        x_ = r_s*cos(th_) ;
        y_ = r_s*sin(th_) ;
        handler=patch(ax_,x_,y_,cmap2(init_blob,:)) ;
        set(handler,'EdgeColor',cmap2(init_blob,:));
    else
        init_blob2=histcounts(init_blob,'BinMethod','integers');
        init_blob=[ zeros(1,min(init_blob)-1) init_blob2];
        init_blob=init_blob/sum(init_blob);
        cmap3=cmap2(find(init_blob),:);
        init_blob=init_blob(init_blob ~=0);
        per_val=2*pi*init_blob;
        init_angle=0;

        for i=1:length(per_val)
            th_ = linspace(init_angle,init_angle+per_val(i), 100) ;
            x_ = r_s*cos(th_) ;
            y_ = r_s*sin(th_) ;
            handler=patch(ax_,[0 x_],[0 y_],cmap3(i,:)) ;  % I am using random color in patch here.
            set(handler,'EdgeColor',cmap3(i,:));
            hold on;
            init_angle=init_angle+per_val(i);
        end
    end
