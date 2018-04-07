function [ solution1 ] = tournement( parentPop )
%TOURNEMENT Summary of this function goes here
%   Detailed explanation goes here

p_size = numel(parentPop);

a = randi([1,p_size]);
b = randi([1,p_size]);


solution1 = parentPop(a);
solution2 = parentPop(b);

solution1 = solution1.compare(solution2);
end

