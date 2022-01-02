clear;
clc;
close all;
%%
if isunix
    cd('./cvx_linux');
    cvx_setup;
    cd ..
end
if ispc
    cd('./cvx_win');
    cvx_setup;
    cd ..
end
cvx_quiet true;
%%
addpath('./matlab2tikz/src');