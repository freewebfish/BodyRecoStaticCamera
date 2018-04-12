function joinedImgs = findLargestImgSubset(imgs,mask)
%FINDLARGESTIMGSUBSET Summary of this function goes here
%   Detailed explanation goes here
    
    % First we find all the subset of the mask, corresponding do valid
    % images. We are doing it in a circular way, so we start not from the
    % firs 1, but from the first 0 (invalid image), keeping trace of the
    % starting index
    maskLength = length(mask);   
    numSubs = 0;
  
    zerosPos = find(mask == 0);
    if ~isempty(zerosPos)
        firstZ = min(zerosPos);
        lastZ = max(zerosPos);
    else
        joinedImgs = imgs;
        return
    end
    
    for i = 2:maskLength
        if mask(i) && ~mask(i-1)
            numSubs = numSubs + 1;
        end
    end 
    
    if lastZ == firstZ
        joinedImgs = selectImages(imgs,[firstZ+1, maskLength-1]);
        return
    end
    
    subsets = ones(numSubs+1,2);
    idx = 0;
    for i = 2:maskLength
        if mask(i) 
            if ~mask(i-1)
                idx = idx+1;
                subsets(idx,1) = i;
            else
                if idx ~= 0
                    subsets(idx,2) = subsets(idx,2) + 1;
                end
            end
        end
    end
    
    idx = idx + 1;
    subsets(idx,:) = [mod((lastZ+1),maskLength),maskLength-lastZ+firstZ-1];
    
    maxSubsetsInd = subsets(:,2) >= max(subsets(:,2));
    maxInd = find(maxSubsetsInd,1); 
    bestSubset = subsets(maxInd,:);
    joinedImgs = selectImages(imgs,bestSubset);
end

function selectedImgs = selectImages(imgs,bestSubset)
    numImgs = length(imgs);
    numSelectedImgs = bestSubset(2);
    selectedImgs = cell(numSelectedImgs,1);
    for i = 1:numSelectedImgs
        if bestSubset(1)+i-1 <= numImgs
            currIdx = bestSubset(1)+i-1;
        else
            currIdx = mod(bestSubset(1)+i-1,numImgs);
        end
        selectedImgs{i} = imgs{currIdx};
    end
end