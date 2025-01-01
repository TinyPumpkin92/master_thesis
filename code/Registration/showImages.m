figure;

number_images = 50;

for i = 1:number_images
    
    im = imread(sprintf('%d.tif',i));
    im = rgb2gray(im);
    
    imshow(im,[]);
    pause();
    
end
