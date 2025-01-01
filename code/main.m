function [] = main()

[~, ~] = computeRegistration(true, false);
performRegistration();





filename = segmentCells(false);
analyze(filename, 150);

end
