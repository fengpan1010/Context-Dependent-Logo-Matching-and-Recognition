%%%%%%%%%%%%%%%Context-Dependent Logo Matching and Recognition%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%IEEE TRANS 2013%%%%%%%%%%%%%


clc;
clear all;
close all;

run('toolbox/vl_setup')
database_dir = 'Database';
%query_image = 'Query/coke.jpg';
query_image = 'Query/starbucks.jpg';
%query_image = 'Query/coke.jpg';
%query_image = 'Query/starbucks.jpg';

coke_que = false(1,5); coke_que(1:5)=true;
starbucks_que = false(1,5); starbucks_que(6:10)=true;
apple_que = false(1,5); apple_que(11:15)=true; 
kingfisher_que = false(1,5); kingfisher_que(16:21)=true;
que=apple_que;
img = single(rgb2gray(imread(query_image)));
aa=[400 400];
img=imresize(img,aa);
num=zeros(1,2);
show = true;

for l=1:22;
    out_images = [database_dir '/' num2str(l) '.jpg'];

    tic;

    img_que=imread(out_images);
    if ndims(img_que) == 3 
        img_que=single(rgb2gray(img_que));
    else
        img_que=single(img_que);
    end
    img_que=imresize(img_que,aa);
    
    [frames_query,sift_query] = vl_covdet(img,'Method','DoG','EstimateOrientation',true,'DoubleImage',false);
    [frames_test,sift_test] = vl_covdet(img_que,'Method','DoG','EstimateOrientation',true,'DoubleImage',false);
    threshold=1.5;
    [matches,score] = vl_ubcmatch(sift_query,sift_test,threshold);

    loc1 = frames_query(1:2,:)';
    loc2 = frames_test(1:2,:)';
    
    if(show)
        im = appendimages(uint8(img),uint8(img_que));
        close all;
        figure('Position', [100 100 size(im,2) size(im,1)]);
        imshow(im);
        hold on;
        cols1 = size(img,2);
        
        for i = 1:size(matches,2)

            %each line and point of the same color  
            line([loc1(matches(1,i),1) loc2(matches(2,i),1)+cols1], ...
                 [loc1(matches(1,i),2) loc2(matches(2,i),2)], 'Color', 'c');
        end
        vl_plotframe(frames_query(:,matches(1,:)));
        vl_plotframe(frames_test(:,matches(2,:))+repmat([cols1 0 0 0 0 0]',1,size(matches,2)))

        hold off;
        pause;
    end
   
    toc;
end

