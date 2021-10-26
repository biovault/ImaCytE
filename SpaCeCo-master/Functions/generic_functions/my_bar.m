function handleToThisBarSeries=my_bar(array,names,cmap,ax_)

% Bar scatter plot with each column a different color
%   - array: a vector with the values for each column
%   - names: a cell array with the names of the plotted columns
%   - cmap: an array with the RGB colors for each column
%   - ax: the axis object where the scatter plot will be presented

%   Copyright 2020 Mirtech, Inc.
%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

if nargin <4
    ax_=gca;
end
fontSize = 30;
format compact

barColorMap = cmap; 
numberOfBars=size(array,1);
x=1:size(array,1);
y=array';

for b = 1 : numberOfBars
	% Plot one single bar as a separate bar series.
	handleToThisBarSeries(b) = bar(ax_,x(b), y(b), 'BarWidth', 0.9);
	% Apply the color to this bar series.
	set(handleToThisBarSeries(b),'FaceColor', barColorMap(b,:),'DisplayName','fddfsd');
	hold(ax_,'on');
end

hold off
set(gca, 'XTickMode', 'manual');
set(gca, 'XTick', 1:numberOfBars);

set(gca, 'XTickLabelMode', 'manual');
set(gca,'XTickLabel',names,'XTickLabelRotation',90);


