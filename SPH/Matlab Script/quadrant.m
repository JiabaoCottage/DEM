function [ index ] = quadrant( p )
index = 0;
x = p(1);
y = p(2);
z = p(3);

if ( x > 0 ) && ( y > 0 ) && ( z > 0 )
    index = 1;
elseif ( x < 0 ) && ( y > 0 ) && ( z > 0 )
    index = 2;
elseif ( x < 0 ) && ( y < 0 ) && ( z > 0 )
    index = 3;
elseif ( x > 0 ) && ( y < 0 ) && ( z > 0 )
    index = 4;
elseif ( x > 0 ) && ( y > 0 ) && ( z < 0 )
    index = 5;
elseif ( x < 0 ) && ( y > 0 ) && ( z < 0 )
    index = 6;
elseif ( x < 0 ) && ( y < 0 ) && ( z < 0 )
    index = 7;
elseif ( x > 0 ) && ( y < 0 ) && ( z < 0 )
    index = 8;
end