
function [meandB,lossdB] = prop(tableOfTxCoords,currentPlanDetails,noOfTx)
%% initiation
lightVel                = 3e8;      % Light velocity (m/s).
freq                    = 865.2e6;  % Hz

TxPower                 = 0;        % dBm or dB
antennaLoss             = 0;        % dB
TxAntennaGain           = 0 + antennaLoss ; % Gain of Transmitting antenna
RxAntennaGain           = TxAntennaGain;    % Gain of Receiving antenna

% Multi-Wall Model Parameters
d0Cost231               = 1;      % Multi-wall model reference distance

%% Calculating mesh points distance from Tx
% 
% AMEND THIS TO CALC DISTANCE FROM MULTIPLE POINTS
%

for i = 1:noOfTx
    Txc = tableOfTxCoords(i,1);  
    Txr = tableOfTxCoords(i,2);
    
    if (Txc ~= 0) % if Txc == 0 means no fuurther Tx in solution
        [Rxr,Rxc] = find(currentPlanDetails.floorMesh == 1); % finding the nodes 
        dRxTxr = Rxr - Txr; % distance in terms of pixels
        dRxTxc = Rxc - Txc; % distance in terms of pixels 
        tempNodeDistance = sqrt(dRxTxr.^2 + dRxTxc.^2) * currentPlanDetails.pathUnit; % distance in terms of meters

        if i==1
            nodeDistance = tempNodeDistance;
        else
            for j = 1:numel(tempNodeDistance)
                if tempNodeDistance(j,1) <  nodeDistance(j,1)
                    nodeDistance(j,1) = tempNodeDistance(j,1); % var that is passed though to the rest 
                end
            end       
        end
    else
        break;
    end 
end


%% Indoor Propagation Models
% %  COST 231 Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % LOS & Walls Determination
% % Thining the floor plan. Only one pixel per wall should intersect with LOS  
% thinFloorPlanBW = ~ originalFloorPlan;
% thinFloorPlanBW = bwmorph(thinFloorPlanBW,'thin','inf');
% thinFloorPlanBW = bwmorph(thinFloorPlanBW,'diag');


losTemp = zeros(size(currentPlanDetails.thinFloorPlanBW));
wallsType = cell(size(Rxr,1),1); % pre-defining
numWalls = zeros(size(Rxr,1),1);    
lossdB = zeros(size(Rxr,1),1);

for h = 1:noOfTx
    losC = cell(size(Rxr,1),1);
    losR = cell(size(Rxr,1),1);
    Txc = tableOfTxCoords(h,1);  
    Txr = tableOfTxCoords(h,2);
    if Txc ~= 0
        tempLossdB = zeros(size(Rxr,1),1);
        for i = 1:numel(Rxr)
            [losC{i},losR{i}] = bresenham(Txc,Txr,Rxc(i),Rxr(i)); %LOS between Tx &Rx
            for j = 1:numel(losC{i}(:))
                losTemp(losR{i}(j),losC{i}(j)) = 1; % temporary line of sight image
            end
            [wallsLable,numWalls(i)] = bwlabel(losTemp .* currentPlanDetails.thinFloorPlanBW,8); % find intersection of LOS and walls
            wallsLable = bwmorph(wallsLable,'shrink','inf');
            wallsType{i} = unique(double(currentPlanDetails.floorPlanGray).*wallsLable);  % type of the walls (grayscale) between each Tx to Rx

            % calculating the total wall attenuation for each beam
            wallLoss = 0;
            for k = 2:numel(wallsType{i})
                wallLoss =  currentPlanDetails.wallAt(wallsType{i}(k)) + wallLoss;
            end
            % Calculating the signal strength
            tempLossdB(i) = ((20 * log10(4*pi.*nodeDistance(i).*freq./lightVel) .* (nodeDistance(i) > d0Cost231)) + ((nodeDistance(i) < d0Cost231) .* 20 * log10(4*pi.*d0Cost231.*freq./lightVel)) ) ...
                + abs(wallLoss);
                tempLossdB(i) = TxPower - tempLossdB(i) + RxAntennaGain + TxAntennaGain;


            if h==1
                lossdB = tempLossdB;
            elseif h > 1
                if tempLossdB(i,1) >  lossdB(i,1)
                    lossdB(i,1) = tempLossdB(i,1); % var that is passed though to the rest 
                end
            end  
            losTemp = zeros(size(currentPlanDetails.thinFloorPlanBW)); % clears the LOS image
        end
    else
        break;
    end
end % for h = 1:noOfTx

meandB = sum(lossdB)./numel(Rxr);

