function [x,y,z,idface]=triablock
% [x,y,z,idface]=triablock returns corner coordinate and 
% face data for a triangular block with a triangular hole
x=[2 2 2 2 2 2 0 0 0 0 0 0]-1;
y=[0 4 4 2 3 3 0 4 4 2 3 3];
z=[0 0 4 1 1 2 0 0 4 1 1 2];
idface=[1  2  3  6  5  4  6  3;
        1  3  9  7  0  0  0  0;
        1  7  8  2  0  0  0  0;
        2  8  9  3  0  0  0  0;
        7  9 12 10 11 12  9  8;
        4 10 12  6  0  0  0  0;
        4  5 11 10  0  0  0  0;
        5  6 12 11  0  0  0  0];