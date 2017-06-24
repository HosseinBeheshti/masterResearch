function [Earea,Emoment,nsides]=polyerr(nsides)
% [Earea,Emoment,nsides]=polyerr(nsides)
% This function computes the percent error in area and polar moment 
% of inertia resulting when a  circle is approximated by a regular
% polygon with corners touching the circle.
if nargin==0; nsides=3:100; end, nsides=nsides(find(nsides>=3));
Aexact=pi; Jexact=pi/2; n=nsides; Aaprox=n/2.*sin(2*pi./n);
Japrox=n/4.*sin(2*pi./n).*(1-2/3*sin(pi./n).^2);
Earea=100*(1-Aaprox/Aexact); Emoment=100*(1-Japrox/Jexact);
semilogy(nsides,Earea,'k',nsides,Emoment,'r')
xlabel('number of sides'), ylabel('Percent Error = 100*(1-approx/exact)')
title('PERCENT ERROR IN AREA AND POLAR MOMENT OF INERTIA')
legend('area error','polar moment of inertia error')
grid on, shg