function [handler,mean_val,std_val]=my_pie(handles,distro,init_blob,fr,ax_,z)

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
if size(distro,1)==1
    mean_val2=distro;
else
    mean_val2=mean(distro);
end
mean_val=mean_val2(mean_val2 ~=0);
r_s=(0.1+power(fr,1/2))*0.45;

% load colorbrewer.mat
% cmap=[colorbrewer.qual.Set1{end} ;colorbrewer.qual.Set2{end};colorbrewer.qual.Set3{end};colorbrewer.qual.Pastel2{end};colorbrewer.qual.Pastel1{end}];
% cmap2=cmap(1:size(distro,2),:)/255;
cmap2=getappdata(handles.figure1,'cmap');
cmap2=cmap2(1:size(distro,2),:);


if isempty(mean_val)
    th_ = linspace(0,2*pi, 100) ;
    r=0.6;
    x_ = r*cos(th_) ;
    y_ = r*sin(th_) ;
    handler(2)=patch(ax_,x_,y_,[1 1 1]) ;
    set(handler(2),'EdgeColor',[1 1 1 ]);
    
    handler(1)=plot_central_blob(init_blob,cmap2,r_s,ax_);
elseif length(mean_val)==1
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

    handler(1)=plot_central_blob(init_blob,cmap2,r_s,ax_);
else
    cmap=cmap2(find(mean_val2),:);
    
    if size(distro,1)==1
        std_val=zeros(1,size(distro,2));
    else
        std_val=std(distro);
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

    handler(1)=plot_central_blob(init_blob,cmap2,r_s,ax_);

end

if flag
%     c=mat2gray(z,[1000 9000]);
%     c = gray;
%     c = flipud(c);
    handler(i*2+3)=patch(ax_,[1 0.45 1],[1 1 0.45],z);
    caxis([0 1]);
%     colormap(ax_,c);

%     colormap(ax_, gray)
end

set(ax_,'ylim',[-1 1])
set(ax_,'xlim',[-1 1])
set(ax_, 'visible', 'off')
set(ax_,'PlotBoxAspectRatio',[1 1 1])

function handler=plot_central_blob(init_blob,cmap2,r_s,ax_)
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
