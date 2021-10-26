function moveObject(hObject,eventdata)
global dragging
global orPos
        if ~isempty(dragging) && isvalid(dragging)
            newPos = get(gcf,'CurrentPoint');
            posDiff = newPos - orPos;
            orPos = newPos;
            set(dragging,'Position',get(dragging,'Position') + [posDiff(1:2) 0 0]);
        end
end