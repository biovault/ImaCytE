function handleToThisBarSeries=my_bar(array,names,cmap,ax_)

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


