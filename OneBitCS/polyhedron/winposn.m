function winposn(xlft,ybot,width,height)
% winposn(xlft,ybot,width,height) positions the graphics
% window to prevent overwrite of text
if nargin==0, xlft=.45; ybot=.3; width=.4; height=.6; end
u=get(gcf,'units'); r=[xlft,ybot,width,height];
set(gcf,'units','normalized','outerposition',r);
set(gcf,'units',u); shg