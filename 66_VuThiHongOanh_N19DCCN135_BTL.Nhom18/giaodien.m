  function varargout = giaodien(varargin)
% GIAODIEN M-file for giaodien.fig
%      GIAODIEN, by itself, creates a new GIAODIEN or raises the existing
%      singleton*.
%
%      H = GIAODIEN returns the handle to a new GIAODIEN or the handle to
%      the existing singleton*.
%
%      GIAODIEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GIAODIEN.M with the given input arguments.
%
%      GIAODIEN('Property','Value',...) creates a new GIAODIEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcc1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to giaodien_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help giaodien
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @giaodien_OpeningFcn, ...
                   'gui_OutputFcn',  @giaodien_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
% --- Executes just before giaodien is made visible.
function giaodien_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to giaodien (see VARARGIN)
% Choose default command line output for giaodien
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes giaodien wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = giaodien_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in start_cam.
function start_cam_Callback(hObject, eventdata, handles)
global vid;    
    cla(handles.Camera,'reset');
    guidata(hObject, handles); %updates the handles
    imaqreset;
    set(gcf,'CurrentAxes',handles.Camera);
    set(gcf,'DoubleBuffer','on');
    imaqhwinfo;
    imaqhwinfo('winvideo',1);
    vid=videoinput('winvideo',1,'MJPG_640x480');
    vid.ReturnedColorSpace = 'rgb';
    vidRes = get(vid, 'VideoResolution');
    nBands = get(vid, 'NumberOfBands');
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) );   
    preview(vid, hImage);
% hObject    handle to start_cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in exitprogram.
function exitprogram_Callback(hObject, eventdata, handles)
delete(handles.figure1);
% hObject    handle to exitprogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in result.
function result_Callback(hObject, eventdata, handles)
S = handles.S;      %image
NRows=size(S,1); % kích thước dòng
NColoms=size(S,2); % kích thước cột
S=imcrop(S,[0 NRows/2 NColoms NRows/1.2]);
depth=10;
horizantalRule=depth+1;
I=rgb2gray(S);
I = imadjust(I);   

I=imbinarize(I);

hang=size(I,1);
cot=size(I,2);

%By Horizontal Lines
for i=1:(horizantalRule-1)
    c=BYhorizontal(horizantalRule,hang,cot,I);                 %function# 1
    
   % disp("c: " + c)
    td=Region(c);   %60                                                     %function# 2
    %disp("td: " + td)
    s=Collect(c,td);                                                         %function# 3
   % 5disp("s: " + s)
    [k,g]=CheckT(s);                                                          %function# 4
   % disp("k: " + k)
    %disp("g: " + g)
    rec=s(k);
   % disp("rec: " + rec)
    q=s./rec;
   % disp("q: " + q)
    p=round(q);
   % disp("p: " + p)
    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1
        
        result=eanupc(p,k)

        
     
    if ischar(result)
    set(handles.result_barcode,'string',result);
       else 
    result=num2str(result);
    set(handles.result_barcode,'string',result);
       end
    
        
        break;  
    end
end
clear
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in capture.
function capture_Callback(hObject, eventdata, handles)
clc;
global vid;
    S=getsnapshot(vid);
    axes(handles.Capture_image);
    imshow(S);
    %Image Storage
    imwrite(S,'imagename2.jpg');
    %%%%
    handles.S = S;
    guidata(hObject, handles);
    I = imread("C:\Users\HongOanh\OneDrive\Desktop\66_VuThiHongOanh_N19DCCN135_BTL.Nhom18\66_VuThiHongOanh_N19DCCN135_BTL.Nhom18\imagename2.jpg");
    [msg,detectedFormat,loc] = readBarcode(I,'1D');
    disp("Decoded barcode message: " + msg)
    disp("Barcode format: " + detectedFormat)
    set(handles.result_barcode,'string',msg);
   % hObject    handle to capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in loadimage.
function loadimage_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.Capture_image);
imshow(S);
handles.S = S;
guidata(hObject, handles);
% hObject    handle to loadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object creation, after setting all properties.
function result_barcode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result_barcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.
function Capture_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Capture_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate Capture_image
% Hint: place code in OpeningFcn to populate Capture_image
% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes3
% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
tato=imread('logo.jpg');
imshow(tato);
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes4
% --- Executes during object creation, after setting all properties.
function logo_CreateFcn(hObject, eventdata, handles)
imshow(imread('logo.gif'))
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate logo
