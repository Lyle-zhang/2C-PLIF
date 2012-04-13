function N=PDF2d(Direct, Start, Stop, Xpts, Ypts, Box, eps)
%--------------------------------------------------------------------------------%
% Note Box is [r c]
%
% FindMeanE 
% Finds the mean of a series of processed images, filtered with some threhold value
% denoted by epsilon (eps).  For example, if data is scaled from 0-1 and eps is .01,
% All data below 0.01 will be set to zero. If no eps is defined, eps is set
% to -Inf
%
% To calculate the means of mulitple data ranges, set start and stop to vectors
% containing the ranges.  Example, to find the mean of images 1-10 and 35-70, call
% FindMeanE(Direct,[1 35],[10 70],eps)
%
% Direct is the directory path to find the means for.  If your current path is the
% correct Directory, set path to: ''
%
% Dependancies: 
% FindMeanE requires a directy of Processed Images located at ProcImgs/Proc****.m
%
% output:
% FindMeanE will return the mean in a matrix the same size and C1 and C2.
% the function will also output a file named
% [Direct 'Vars/ProcMeansE' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))]
% containing matricies for mean1 and mean2.
%--------------------------------------------------------------------------------%
    if nargin == 6
        eps = -Inf;
    end

disp(['Finding 2D PDF for ' int2str(Start) '-' int2str(Stop)]);
load([Direct 'ProcImgs/Proc' sprintf('%05d', Start(1))],'C1','C2')   %Proc Mean

%How many Counts will PDF have? Note won't work for multiple starts/stops
Ncounts=Box(1)*Box(2)*(Stop-Start+1);

Box(2)=floor(Box(2)/2);
Box(1)=floor(Box(1)/2);

% Initilize Centers.  This also sets the length of the PDF
Centers=0:.01:1;
    Cs(1)={Centers};
    Cs(2)={Centers};

% Initilize N. first two dimentions are a PDF for a single x and Y point.
% The second 2 dimentions will specify the X and Y point for that PDF.
N=zeros(length(Centers), length(Centers), length(Xpts), length(Ypts));

ind=1;
i=Start(ind);
while ind<=length(Start)
     load([Direct 'ProcImgs/Proc' sprintf('%05d', i)],'C1','C2')
    % create histogram for each Box
    for X=1:length(Xpts)
        for Y=1:length(Ypts)
            l=Xpts(X)-Box(2);
            r=Xpts(X)+Box(2);
            b=Ypts(Y)-Box(1);
            t=Ypts(Y)+Box(1);
            
            C1s=C1(b:t,l:r);
            C2s=C2(b:t,l:r);
            Nt(:,:,X,Y)=hist3([C1s(:),C2s(:)],Cs); %will C always be the same? Only if i send it an an edges specifier..
        end
    end
    % Add Nt (temp hist for each column of image) to N 
    N=N+Nt;
    
    if i==Stop(ind)
        ind=ind+1;
        if ind<=length(Start)
            i=Start(ind);
        end
    else
        i=i+1;
    end
end

%Normalize by total counts to get a PDF
N=N/Ncounts;

save([Direct 'Vars/Eps' sprintf('%.3f', eps) '/PDF2d' sprintf('%05d', Start(1)) '-' sprintf('%05d', Stop(length(Start)))], 'N','Cs');   %Proc Mean

 