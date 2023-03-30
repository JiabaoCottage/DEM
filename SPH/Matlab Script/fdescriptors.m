function [c,I] = fdescriptors(I)
    T=241;
    I(I>T)=255;
    I(I<T)=0;

    sobelH = [-1 -2 -1 ;  0 0 0 ;  1 2 1];
    sobelV = [-1  0  1 ; -2 0 2 ; -1 0 1];

    sH = convolve( I, sobelH );
    sV = convolve( I, sobelV );
    s=(sH.^2+sV.^2).^0.5;
    figure;
    imshow(s), title('Sobel'); 


    s(s>0)=1;
    I=s; 


    % Find a starting point on the boundary
    [x, y] = find(I~=0);

    schema = bwtraceboundary(I, [x(1), y(1)],'E',8,Inf,'clockwise');

    for i=1:length(schema)
         c(i) = schema(i,2) + 1i*schema(i,1);
    end

end

