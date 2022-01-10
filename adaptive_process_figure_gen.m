clear;
clc;
close all;
rng default;
%% single stage simulation;
x = [0 2 -2 0 0 2 2 -1.5];
y = [1 0 0 2.59 -1 1 -1 1];
l = [];
    hold on;
for i = 1:length(x)/2

    l(i) =  line(x(i:i+1),y(i:i+1));
end
hold off;


%%
coef = zeros(1,length(x));
y1 = zeros(1,length(x));
for i = 1:length(x)
    coef(i) = polyfit(x,y,0);
    y1(i) = polyval(coef(i),x);
end
P = InterX([x(1),y(1)],y);
%       plot(x1,y1,x2,y2,P(1,:),P(2,:),'ro')
pgon = polyshape(x,y);
plot(pgon,'FaceColor','red','FaceAlpha',0.1);
%%
x = 1:503;
y = 250 + 0.02*x + 0.005*x.^2 + 0.2*rand(1,503).*x;
figure
polyfit(y,x,0);
coef1 = polyfit(x,y,0);
y1 = polyval(coef1,x);
hold on
plot(x,y,'.');
plot(x,y1);  
polyfit(x,y,1);
coef2 = polyfit(x,y,1);
y2 = polyval(coef2,x);
plot(x,y2);
polyfit(y,x,2);
coef3 = polyfit(x,y,2);
y3 = polyval(coef3,x);
plot(x,y3);