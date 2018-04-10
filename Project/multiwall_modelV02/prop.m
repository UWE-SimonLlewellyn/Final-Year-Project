%   Code taken from main file and turn in to fucntion 
%   Writen by:  Salaheddin Hosseinzadeh (hosseinzadeh.88@gmail.com)
%               Motley-Keenan (COST 231 Model) & Free Space Path Loss
%
%               Code written by Simon Llewellyn for Multi TX solution has 
%               been marked up with a banner.
%               Line 36-55 & 106-119
%               


function [meandB,mindB,lossdB] = prop(tableOfTxCoords,currentPlanDetails,MaxNumTx)
%% initiation
lightVel                = 3e8;      % Light velocity (m/s).
freq                    = 865.2e6;  % Hz

TxPower                 = 0;        % dBm or dB
antennaLoss             = 0;        % dB
TxAntennaGain           = 0 + antennaLoss ; % Gain of Transmitting antenna
RxAntennaGain           = TxAntennaGain;    % Gain of Receiving antenna

% Multi-Wall Model Parameters
d0Cost231               = 1;      % Multi-wall model reference distance


count = 0;
for i = 1:MaxNumTx
    Txc = tableOfTxCoords(i,1);  
    Txr = tableOfTxCoords(i,2);
    % checks of 0 in grid coords and skips them if present.
    if Txc ~= 0 && Txr ~= 0
%% Calculating mesh points distance from Tx
% 
%
        dRxTxr = currentPlanDetails.Rxr - Txr; % distance in terms of pixels
        dRxTxc = currentPlanDetails.Rxc - Txc; % distance in terms of pixels 
        tempNodeDistance = sqrt(dRxTxr.^2 + dRxTxc.^2) * currentPlanDetails.pathUnit; % distance in terms of meters

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section written by Simon Llewellyn       
% used to compare the current Tx to node distances againt the previous
% placed Txs
% seperate counter used for IF as loop itterates over the possible
% amount of Tx. If previous IF (Txc ~= 0 && Txr ~= 0) is false
% nodeDistance is not assigned.
        count = count + 1;
        if count==1
            nodeDistance = tempNodeDistance;
        else
            % if temp(current) node is closer to Tx the value replaces the
            % store value
            for j = 1:numel(tempNodeDistance)
                if tempNodeDistance(j,1) <  nodeDistance(j,1)
                    nodeDistance(j,1) = tempNodeDistance(j,1); % var that is passed though to the rest 
                end
            end       
        end
%%%%%%%%%%%%%%%%%%%%%%%%% END SIMON LLEWELLYN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end


%% Indoor Propagation Models
% % COST 231 Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Salaheddin Hosseinzadeh (hosseinzadeh.88@gmail.com)
%   Motley-Keenan (COST 231 Model) & Free Space Path Loss

losTemp = zeros(size(currentPlanDetails.thinFloorPlanBW));
wallsType = cell(size(currentPlanDetails.Rxr,1),1); % pre-defining
numWalls = zeros(size(currentPlanDetails.Rxr,1),1);    
lossdB = zeros(size(currentPlanDetails.Rxr,1),1);
count = 0;
sanitisedTable = zeros(MaxNumTx,2);
for k = 1:MaxNumTx
    if tableOfTxCoords(k,1) ~= 0 && tableOfTxCoords(k,2) ~=0
        count = count +1;
        sanitisedTable(count,:) = tableOfTxCoords(k,:);
    end
end


for h = 1:count
    losC = cell(size(currentPlanDetails.Rxr,1),1);
    losR = cell(size(currentPlanDetails.Rxr,1),1);
    Txc = sanitisedTable(h,1);  
    Txr = sanitisedTable(h,2);
        tempLossdB = zeros(size(currentPlanDetails.Rxr,1),1);
        for i = 1:numel(currentPlanDetails.Rxr)
            [losC{i},losR{i}] = bresenham(Txc,Txr,currentPlanDetails.Rxc(i),currentPlanDetails.Rxr(i)); %LOS between Tx &Rx
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

 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Added by Simon Llewellyn 
 %
 % Section added to allow for multiple Tx in solution.
 % compares the reading of the lossdB with current 
            if h==1
                lossdB = tempLossdB;
            elseif h > 1
                if tempLossdB(i,1) >  lossdB(i,1)
                    lossdB(i,1) = tempLossdB(i,1); % var that is passed though to the rest 
                end
            end  
            losTemp = zeros(size(currentPlanDetails.thinFloorPlanBW)); % clears the LOS image
 %%%%%%%%%%%%%%%%% END SIMON LLEWELLYN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
end % for h = 1:noOfTx - added for 
%% Simon Llewellyn
mindB = min(lossdB);
meandB = sum(lossdB)./numel(currentPlanDetails.Rxr);

