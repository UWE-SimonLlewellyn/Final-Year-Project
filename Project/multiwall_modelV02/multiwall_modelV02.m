% mutliwall_modelV02
% Motley-Keenan (COST 231 Model) & Free Space Path Loss
% Author: Salaheddin Hosseinzadeh (hosseinzadeh.88@gmail.com)
% Created on: 18.02.2016
% Last revision: 30.01.2017
% Notes:
%   - Mind the Command Window while running the code, you'll be asked for inputs
%   - All lines should be straight lines for this to work! (no curves)
%   - Meshing method is not completed, only use meshingMethod = 2 
%   - Attenuation is calculated in dB atm!
%   - To assign attenuation to walls change "wallAtt" in line 72-77 ...
%   - This code uses imoverlay.mat, by Steven L. Eddins. 
%   - This code uses bresenham.mat, by Aaron Wetzler.
%   - Version 01.
%   - This code requires (imoverlay.m),(shortestPath.m),
%   (autoWallDetection.m), (bresenham.m) to be present in MATLAB path
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INITIALIZATION  
clear all
clc

 gaMode                = 1;        % 0 = random values , 1 = grid spacing initiation
 
 

% for distance calculator
GridSize = 20;
meshNode.vert.num       = 10;             % Number of probs in the structure increase for better accuracy
meshNode.horz.num       = 10;


% Wall Detection Parameters (Change them wiselt if walls are not correctly detected)
thetaRes = 0.1;                   % Resolution of the Hough Transform Space (don't make it smaller than 0.1)
minWallLength = 15;               % Minimum length of the walls in pixel
fillGap = 5;                     % Gap between walls

%Wall Attenuation Coefficient Assignment dB
% Manually Assign Attenuation factors to each particular wall based on it's
% intensity dynamic range (change plot mode in autoWallDetection to 1 to
% see the intesity of each wall.
wallAt = zeros(255,1);
wallAt(200:end) = 6;
wallAt(254) = 5.5;
wallAt(253) = 6;
wallAt(252) = 6;
wallAt(255) = round(sum(wallAt)./sum(wallAt>0));  % This is for intersecting walls, just leave it as it is


% Added vars for UWE work
%-------------------------------------------

% calculate scale of diagram
pathLength = 5; % meters
pathPixels = 110; % pixles or  
pathUnit = pathLength./pathPixels; %pathUnit = meter per pixel

%% Reading the image
% Converts the images into a 2D array that indicates
% floorPlan = 0 for wall, 255 for non-wall
% floorPlanBW = 0/False for non-wal, 1/true for wall
try
    [fileName,filePath] = uigetfile('*.*');
catch
end
floorPlan = imread([filePath,fileName]);
floorPlanBW = ~im2bw(floorPlan);



% adjusting the image if required
try
    [co,bi] = imhist(floorPlanBW);
    
    if bi(1) == 0 && co(1) > co(2)
        floorPlanBW = ~floorPlanBW; % complements the image if not in correct form so that the structure will be in Black in case it's not
    end
catch
end

originalFloorPlan = floorPlanBW; % At this point, Structure in Original Image and floorPlanBW is in black

% % LOS & Walls Determination
% Thining the floor plan. Only one pixel per wall should intersect with LOS  
thinFloorPlanBW = ~ originalFloorPlan;
thinFloorPlanBW = bwmorph(thinFloorPlanBW,'thin','inf');
thinFloorPlanBW = bwmorph(thinFloorPlanBW,'diag');


% Optional delation of the image to make wall selection easier
floorPlanBW = ~imdilate(~floorPlanBW,strel('disk',2));


%% Meshing the Floor Plan
% Mesh is where plot points are added to the image to to help loss
% calculations
floorMesh = zeros(size(floorPlanBW));

mesh.vert.spacing = pathUnit .* size(floorPlanBW,1) ./ meshNode.vert.num; % node spacing meters
mesh.horz.spacing = pathUnit .* size(floorPlanBW,2) ./ meshNode.horz.num; % node spacing meters
floorMesh(floor(linspace(1,size(floorPlanBW,1),meshNode.vert.num)),...
    floor(linspace(1,size(floorPlanBW,2),meshNode.horz.num))) = 1;


[floorPlanGray,countedWalls] = autoWallDetection(~originalFloorPlan,wallAt,thetaRes,minWallLength,fillGap); % Detecting all the walls Generates floorPlanGray where different wall are index coded in the gray image


%% Creating Grid for placement

% TxGrid hold the start and end cooridantes of the 
TxGrid = zeros(2, 2, GridSize, GridSize);

% Centre of grid squares using the starting x,y cordinates 
%TxGrid =  zeros(10); % needs a 4D array holding 2 sets of co ords top left and bottom right:([0,0],[10,10]), ([0,10],[10,20])
tempX = size(floorPlanBW,1)./GridSize;
tempY = size(floorPlanBW,2)./GridSize;

for i =1:GridSize   
    for i2 = 1:GridSize                       
        TxGrid(1,1,i2,i) = tempX.*(i-1);
        TxGrid(1,2,i2,i) = tempY.*(i2-1);
        TxGrid(2,1,i2,i) = tempX.*(i);
        TxGrid(2,2,i2,i) = tempY.*(i2);            
    end     
end

if gaMode == 1
   % Center CoOrs held in 4D array
    TxGridCentre =  zeros(1,2,GridSize,GridSize); % holds centre co-ord for each gridl
    for i =1:GridSize
        for i2 = 1:GridSize
            TxGridCentre(1,1,i2,i) =  TxGrid(1,1,i2,i) + (tempX./2);
            TxGridCentre(1,2,i2,i) = TxGrid(1,2,i2,i) + (tempY./2);        
        end
    end
else
    %Center CoOrs held in array
    TxGridCentre =  zeros([GridSize.*GridSize],2); % holds centre co-ord for each gridl
    j = 0;
    for i =1:GridSize
        for i2 = 1:GridSize
            j = j+1;
            TxGridCentre(j,1) =  TxGrid(1,1,i2,i) + (tempX./2);
            TxGridCentre(j,2) = TxGrid(1,2,i2,i) + (tempY./2);        
        end
    end
end
%% Combining all plan details into an object

currentPlanDetails = PropPlan;
currentPlanDetails = currentPlanDetails.add(floorMesh, pathUnit,thinFloorPlanBW,floorPlanGray,...
    wallAt, TxGridCentre,GridSize);


%% Start of the GA
%
Starttime = now;
MaxNumTx = 6;
popSize = 20;
generations = 50;
grid = [GridSize,GridSize];
cellSpace = 2;

%% TEST SPACE

% testSol = Solution;
% testSol.tableOfCoOrdinates = [0,13;3,20;11,4;0,0;0,0;0,0];
% 
% testSol = PopSolution(testSol,currentPlanDetails,MaxNumTx);
% disp("Tx: " + testSol.noTx + " , MeanDB: " + testSol.meandB + " , Fitness: " +  testSol.dualFitness);
% 
% % smallFSPLImage = mesh map values from transmission point
% smallFSPLImage = (reshape(testSol.nodedBresults,meshNode.vert.num, meshNode.horz.num));
% % FSPLFullImage -db level for value of singal on the map. 
% FSPLFullImage = (imresize(smallFSPLImage,[size(floorPlan,1),size(floorPlan,2)],'method','cubic'));
% % Converts to a num 0.0-1.0 high is the strongest signal
% FSPLFullImage = mat2gray(FSPLFullImage);
% figure('Name','Path loss method ');
% z = imoverlay(FSPLFullImage,~originalFloorPlan,[0,0,0]);
% imshow(rgb2gray(z))
% colormap(gca,'jet');
% 
% 
% for i = 1:7
%     colorbarLabels(i) = min(testSol.nodedBresults) + i .* ((max(testSol.nodedBresults)-min(testSol.nodedBresults))./7);
% end    
% colorbar('YTickLabel',num2str(int32(colorbarLabels')));
% text(testSol.pixelCoOrds(:,1),testSol.pixelCoOrds(:,2),'Tx','Color','Black','FontSize',12);
% title("final solution: " + testSol.meandB  + "(dbs), number of TX " + testSol.noTx + ", bestDualFitness = " + testSol.dualFitness );


%%

tableOfBestSolutions = Solution.empty(generations+1,0);
%create initial population and score
[parent,geneLen,tempBestSolution ] = createPop(gaMode,MaxNumTx,popSize,grid,cellSpace,currentPlanDetails);
tableOfBestSolutions(1) = tempBestSolution;
bestSolution = Solution;
for g = 1:generations     
     [parent,bestOfChildren] = SteadyState(parent,currentPlanDetails,MaxNumTx ,tempBestSolution);    
     if tableOfBestSolutions(g).dualFitness > bestOfChildren.dualFitness
            tableOfBestSolutions(g+1) = tableOfBestSolutions(g);
     else
         tableOfBestSolutions(g+1) = bestOfChildren;
     end
end

Endtime = now;

timedif = Endtime - Starttime;
for i = 1:popSize
    bestSolution = bestSolution.compare(parent(i));
    disp("Tx: " + parent(i).noTx + " , MeanDB: " + parent(i).meandB + " , Fitness: " +  parent(i).dualFitness);
end

disp("Total different in time " + datestr(timedif,'HH:MM:SS.FFF'));

disp("BEST Tx: " + bestSolution.noTx +  " , MeanDB: " + bestSolution.meandB + " , Fitness: " +  bestSolution.dualFitness);

%% Applying color map    
% smallFSPLImage = mesh map values from transmission point
smallFSPLImage = (reshape(bestSolution.nodedBresults,meshNode.vert.num, meshNode.horz.num));
% FSPLFullImage -db level for value of singal on the map. 
FSPLFullImage = (imresize(smallFSPLImage,[size(floorPlan,1),size(floorPlan,2)],'method','cubic'));
% Converts to a num 0.0-1.0 high is the strongest signal
FSPLFullImage = mat2gray(FSPLFullImage);
figure('Name','Path loss method ');
z = imoverlay(FSPLFullImage,~originalFloorPlan,[0,0,0]);
imshow(rgb2gray(z))
colormap(gca,'jet');


for i = 1:7
    colorbarLabels(i) = min(bestSolution.nodedBresults) + i .* ((max(bestSolution.nodedBresults)-min(bestSolution.nodedBresults))./7);
end    
colorbar('YTickLabel',num2str(int32(colorbarLabels')));
text(bestSolution.pixelCoOrds(:,1),bestSolution.pixelCoOrds(:,2),'Tx','Color','Black','FontSize',12);
title("final solution: " + bestSolution.meandB  + "(dbs), number of TX " + bestSolution.noTx + ", bestDualFitness = " + bestSolution.dualFitness );

%%%%%%%%%%%%%%%%5  REFERENCES  %%%%%%%%%%
%
% http://uk.mathworks.com/matlabcentral/fileexchange/28190-bresenham-optimized-for-matlab/content/bresenham.m

