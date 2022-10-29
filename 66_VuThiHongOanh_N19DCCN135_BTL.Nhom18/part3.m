clear
clc

image=imread('C:\Users\HongOanh\OneDrive\Desktop\DOANXLA2910\readBarCodebyL1B\1.jpg');

depth=10;

horizantalRule=depth+1;

S =image;

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%crop
NRows=size(S,1);
NColoms=size(S,2);

S=imcrop(S,[0 NRows/2 NColoms NRows/1.2]);

%%



I=rgb2gray(S);
I = imadjust(I);
            
I=imbinarize(I);
NumofRows=size(I,1);
NumofColoms=size(I,2);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%%
    c=BYhorizontal(horizantalRule,NumofRows,NumofColoms,I);                 %function# 1
     %disp("c: " + c)
    
    td=Region(c);                                                            %function# 2
    %disp("td: " + td)
    s=Collect(c,td);                                                         %function# 3
    disp("s: " + s)
    [k,g]=CheckT(s);                                                          %function# 4
    
    rec=s(k);                                                                
    q=s./rec;
    p=round(q);
    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1
        
        result=eanupc(p,k)
        
       
    end

