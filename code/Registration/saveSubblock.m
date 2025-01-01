function[] = saveSubblock(nmbr)

% Extract subblocks
subblock = zeros(9658,12622,50);
    
    for j = 1:50
        
        subblock(:,:,j) = imread(sprintf('~/data/20171010PyramidCellsRegistered_%d/%d.tif',nmbr,j));
        
    end
    
    save(sprintf('~/data/subblock_%d.mat',nmbr),'subblock','-v7.3');

end
