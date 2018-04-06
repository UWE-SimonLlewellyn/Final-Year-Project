% Detects all the straight lines in a binary Image
% Created By: Salaheddin Hosseinzadeh
% Created on: 10.10.2016
% Last Revision: 29.01.2017
% Notes: 
%   - This is particularly made for multiwall_modeV01
%   - Code changed to be compatible with MATLAB 2012 & later (try catch in line 39).

function [floorPlanGray,wallCounter,varargout] = autoWallDetection(floorPlanBW,wallAt,thetaRes,minWallLength,fillGap)
%% Starting with Calculation of Hugh Transform
% floorPlanBW = floorPlanBW;
if isempty(thetaRes)
    thetaRes = 0.1;
end

if isempty(minWallLength)
    minWallLength = 30;
end

if isempty(fillGap)
    fillGap = 40;
end


if isempty(wallAt)
    wallAt = zeros(1,255);
end

floorPlanBWHough = bwmorph(floorPlanBW,'clean');
floorPlanGray = zeros(size(floorPlanBW));
wallCounter = 0;

while 1
    [H,theta,rho] = hough(floorPlanBWHough,'RhoResolution',thetaRes,'Theta',-90:thetaRes:89.5);
    hPeak = houghpeaks(H,1);
    linesH = houghlines(floorPlanBW,theta,rho,hPeak,'MinLength',minWallLength,'FillGap',fillGap);


try linesH.point1;  % this generates an error in MATLAB 2012 and earlier
    if isempty(linesH)
        disp('Wall detection ended!');
        break
    end
catch
    disp('Wall detection ended!');
    break
end

    for k = 1:numel(linesH)
        [x,y] = bresenham(linesH(k).point1(1,2),linesH(k).point1(1,1),linesH(k).point2(1,2),linesH(k).point2(1,1));
        houghSubtIm = zeros(size(floorPlanBW));
        for j = 1:numel(x)
            houghSubtIm(x(j),y(j)) = 1;             
        end
        wallCounter = wallCounter + 1; 
        wallsAngle(wallCounter,1) = theta(hPeak(1,2));
        floorPlanGray = (255 - wallCounter).*houghSubtIm + floorPlanGray;
           houghSubtIm = imdilate(houghSubtIm,strel('disk',3));
        floorPlanBWHough = floorPlanBWHough .* ~houghSubtIm;

    end
end

% wallCounter
% Taking Care of Wall Intersection
intersectionIndex = find(floorPlanGray > 256);
%    floorPlanGray(intersectionIndex) = round(floorPlanGray(intersectionIndex)./2);
floorPlanGray(intersectionIndex)= wallAt(255);
varargout{1} = wallsAngle;
    









