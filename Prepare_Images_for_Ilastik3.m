function  Prepare_Images_for_Ilastik3( folder_in,folder_out,markers, Nucleus_marker_number )
%UNTITLED Summary of this function goes here
%   INPUT: 
%             -folder_in: The folder with ome.tiff files you want to process
%             -foler_out: The folder with the RPOCESSED ome.tiff files 
%             -markers: the numbers of markers you want to use for the annotation in Ilastik
%             -Nucleus_marker_number: the number of the markers that are representing nucleus markers

if nargin<3
    markers=[2 11 12 13 17 18 20 21 22 24 25 27 28 30 33 35 36 37 38 39 42 44]; %  Here you put the numbers of markers you want to use for the annotation
    Nucleus_marker_number=[34 44];  %Here you put which markers are nucleus markers
end

fnames=dir([folder_in '\*.ome.tiff']);
for k=1:length(fnames)
    fname = [folder_in fnames(k).name];
    info = imfinfo(fname);
    imageStack = [];
    for l = markers 
        currentImage1 = imread(fname, l, 'Info', info);
        marker=strtok(info(l).PageName,'(');
        imageStack(:,:,l)=image_prepro(l,currentImage1,Nucleus_marker_number);
        imwrite(imageStack(:,:,l),[folder_out '\' fnames(k).name],'writemode','append','Description',marker);
    end
end


function the_one=image_prepro(l,currentImage,Nucleus_marker_number)

    if isempty(find(l == Nucleus_marker_number, 1)) 
        asinh_img=asinh(currentImage/5);
        gcf=figure; 
        set(gcf, 'Visible', 'off');
        imshow(asinh_img);
        title('Arcsin_image', 'Interpreter', 'none');
        the_one=asinh_img; 
    else  
        thres_img=currentImage;
        temp=prctile(currentImage(:),[0 99]);
        thres_img( currentImage > temp(2))= temp(2);
        r_thres_img=mat2gray(thres_img);
        r_thres_img=imadjust(r_thres_img);
        gcf=figure; 
        set(gcf, 'Visible', 'off');
        imshow(r_thres_img);
        title('Threshold_normalized_image', 'Interpreter', 'none');
        the_one=r_thres_img;
    end    
     


