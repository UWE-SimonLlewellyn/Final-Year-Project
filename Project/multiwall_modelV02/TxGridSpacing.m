% Name:         Simon Llewellyn
% Student No.:  04971824
% Project:      Optimisation of Wireless Network Access Point Positioning Using Artificial Intelligence

function X = TxGridSpacing(MaxNumTx,GridSize,cellSpace)
%TXGRIDSPACING Check for placment of other AP within a set grid
%   Use in conjuntion with SteadState.m for creating the initialt 
%   population in the GA.
%   
%  Vars imported:
%       MaxNumTx, - Max number of possible TX
%       GridSize, - Represents the size of grid;
%                   e.g. GridSize = 10, grid == 10x10
%       cellSpace - Minimum manhatten distance each TX needs seperated by
%
%   Create a list of X,Y coordiante for a set number of TX
%   Each Tx muxt be X number of cells away in manhatten distance
%   No break condition if solution not possible.
%   
%



    noOfTx = randi([1,MaxNumTx]); % random number of Tx in solution
    gridCoordinates =  zeros(MaxNumTx,2); % zeroed 
    
    i = 1;   
    while i <= noOfTx %loop can only increase once a valid pair is found 
       count = i;
       tempXY = randi([1,GridSize],1,2); % creates pair of random int between 1:GrideSize
       for i10 = 1:count % loop that only continues when valid solution found
           tempA = gridCoordinates(i10,:);  
           % Check new Coords if any other coords are within manhatten
           % distance. If so, coords are thrown away new coords are
           % genreated.
           sumTempXY = tempXY(1,1) + tempXY(1,2);
           tempSumTable = tempA(1,1) + tempA(1,2);
           if tempXY(1,1) > (tempA(1,1) + cellSpace) || tempXY(1,1) < (tempA(1,1) - cellSpace) ...
                       || tempXY(1,2) > (tempA(1,2) + cellSpace) || tempXY(1,2) < (tempA(1,2) - cellSpace) ...
                       || sumTempXY > (cellSpace + tempSumTable) || sumTempXY < (tempSumTable - cellSpace)...
                       || tempSumTable == 0                 
                validTXcell = true;  

           else
               validTXcell = false;
               break
           end 
       end
       if validTXcell == true
             gridCoordinates(i,:) = tempXY;
             i = i+1;
       end
    end
    X = gridCoordinates;
end

