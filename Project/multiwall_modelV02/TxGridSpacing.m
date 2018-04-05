function X = TxGridSpacing(MaxNumTx,GridSize,cellSpace)
%TXGRIDSPACING Summary of this function goes here
%   Detailed explanation goes here



    noOfTx = randi([1,MaxNumTx]);
    gridCoordinates =  zeros(MaxNumTx,2);
    
    i = 1;   
    while i <= noOfTx
       count = i;
       tempXY = randi([1,GridSize],1,2);
       for i10 = 1:count 
           tempA = gridCoordinates(i10,:);  
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

