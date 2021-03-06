% W18 EECS 504 HW4p2 Fg-bg Graph-cut
% Script to run a full example on an image

%% load the image
%im = double(imread('porch1.png'))/255;

%im = double(imread('veggie-stand.jpg'))/255;

im = double(imread('flower1.jpg'))/255;

%im = double(imread('flag1.jpg'))/255;
%im1=rgb2hsv(im);
%im1(:,:,3)=histeq(im1(:,:,3));
%im1(:,:,2)=min(1,1.5*im1(:,:,2));
% for porch
%im1(:,:,3)=0.2*im1(:,:,3);
%im1(:,:,2)=min(1,0.5*im1(:,:,2));
%im2=hsv2rgb(im1);
%im2=im2*255;
%im2(:,:,1)=255/log10(256)*log(im2(:,:,1)+1)./log(2+8*(im2(:,:,1)/255).^(log(5)/log(0.5)));
%im2(:,:,2)=255/log10(256)*log(im2(:,:,2)+1)./log(2+8*(im2(:,:,2)/255).^(log(5)/log(0.5)));
%im2(:,:,3)=255/log10(256)*log(im2(:,:,3)+1)./log(2+8*(im2(:,:,3)/255).^(log(5)/log(0.5)));
%im2=im2/255;
%im=im2;
figure; imagesc(im);


%% first compute the superpixels on the image we loaded
[S,C] = slic(im,144);
cmap = rand(max(S(:)),3);
mainfig = figure; 
subplot(2,3,1); imagesc(im); title('input image')
subplot(2,3,2); imagesc(S);  title('superpixel mask');
colormap(cmap);

lambda=0.5;
subplot(2,3,3); imagesc(ind2rgb(S,cmap)*lambda+im*(1-lambda));  title('superpixel overlay');

%% next compute the feature reduction for the segmentation (histograms)
C = reduce(im,C,S);

%% next compute the graph cut, given a key index (foreground)

% retrieve a keyindex from the user? set the keyindex by hand if you want,
% but then turn off bkfu
keyindex = 90;
bkfu = 1;
if (bkfu)
    temp = figure();
    lambda = 0.25; 
    imagesc(ind2rgb(S,cmap)*lambda+im*(1-lambda));
    fprintf('Please click on the superpixel you want to be the\n   key on which to base the foreground extraction.\n\n')
    pt = ginput(1);
    close(temp);
    keyindex = S(floor(pt(2)),floor(pt(1)));
    figure(mainfig)
end
B = j_graphcut(S,C,keyindex);

subplot(2,3,4); imagesc(S==keyindex); title('keyindex')
subplot(2,3,5); imagesc(B); title('graphcut result mask')


%% Visualize the output
sp4 = subplot(2,3,6);
showoutput(im,C,S,B,cmap,sp4)
title('extracted boundaries and fg');