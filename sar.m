function varargout = sar(varargin)
% SAR MATLAB code for sar.fig
%      SAR, by itself, creates a new SAR or raises the existing
%      singleton*.
%
%      H = SAR returns the handle to a new SAR or the handle to
%      the existing singleton*.
%
%      SAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAR.M with the given input arguments.
%
%      SAR('Property','Value',...) creates a new SAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sar

% Last Modified by GUIDE v2.5 17-Apr-2014 22:42:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sar_OpeningFcn, ...
                   'gui_OutputFcn',  @sar_OutputFcn, ...
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


% --- Executes just before sar is made visible.
function sar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sar (see VARARGIN)

% Choose default command line output for sar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn,fp]=uigetfile('*.jpg;*.png;*.jpeg','SELECT A FILE');
if isequal(fn,0)|isequal(fp,0),warndlg('NO FILE IS SELECTED');
else
    fn=fullfile(fp,fn);
    im=imread(fn);
    axes(handles.axes1);
    handles.name = fn;
    %axis off;
    imshow(im);
    title('Original Image');
    axis off;
    handles.oimg = im;
    dim = size(im);
    if length(dim) > 2
        im = rgb2gray(im);
    end
    handles.gimg = im;
end;  
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gim = handles.gimg;
wname = 'sym4';
level = 3;
[coef,siz] = wavedec2(gim,level,wname);
%coefs
siz;
axes(handles.axes2);
imshow(gim),title('Gray Image');
a3 = wrcoef2('a',coef,siz,wname,3); 
%a2 = wrcoef2('a',coef,siz,wname,2);
size(a3);
%figure,imshow(mat2gray(a3)),title('Low frequency Image');
hd3 = wrcoef2('h',coef,siz,wname,3); 
vd3 = wrcoef2('v',coef,siz,wname,3); 
dd3 = wrcoef2('d',coef,siz,wname,3);
%figure,imshow(mat2gray(dd3)),title('High Frequency Image');
 lowPass = conv2(double(a3(:,:)), ones(25), 'same');
 size(lowPass);
 %noiseOnlyImage = double(A(:)) - lowPass;
maxl = max(max(lowPass));
maxg = max(max(dd3));
 
 divl =  lowPass/maxl;
 divg = dd3/maxg;
 divl = divl * 255;
 divg = divg *255;
 nol = mod(round(abs(divl)),256);
 nog = mod(round(abs(divg)),256);
size(nol);
size(nog);
 gco = zeros(256);
 sz = size(nog);
 for i = 1:sz(1)
     for j = 1: sz(2)
         v1 = nol(i,j) + 1;
         v2 = nog(i,j) + 1;
         gco(v1,v2) = gco(v1,v2) + 1;
         
     end
 end
 
 pgc = zeros(256);
 sumgc = sum(sum(gco));
 for i = 1 : 256
     for j = 1 : 256
         pgc(i,j) = gco(i,j) / sumgc;
     end
 end
 %save('temp.mat','gco','pgc');
%fi = Hgrey(pgc,128,12);
%size(a1)
%figure,imshow(mat2gray(a2))



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = get(handles.edit1,'string');
N = str2num(N);
Di = get(handles.edit2,'string');
Di = str2num(Di);
Itr = get(handles.edit3,'string');
Itr = str2num(Itr);
Pro = get(handles.edit4,'string');
Pro = str2num(Pro);
Run = get(handles.edit5,'string');
Run = str2num(Run);
[S T] = runABC(N,Di,Itr,Pro,Run);
%im2bw(\
gimg = handles.gimg;
% whos gimg
% whos S
S = uint8(S);
[r,c] = size(gimg);
% whos S
%wim = whiten(uint8(gimg),uint8(S));
thr = S / 256;
%wim = im2bw(gimg);
img = zeros(r,c);
for i = 1:r
    for j = 1:c
        if gimg(i,j) >= S
            img(i,j) = 1;
        end
    end
end

figure,imshow(mat2gray(img))

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = get(handles.edit1,'string');
N = str2num(N);
Di = get(handles.edit2,'string');
Di = str2num(Di);
Itr = get(handles.edit3,'string');
Itr = str2num(Itr);
Pro = get(handles.edit4,'string');
Pro = str2num(Pro);
Run = get(handles.edit5,'string');
Run = str2num(Run);
[S T] = runABC(N,Di,Itr,2,Run);
gimg = handles.gimg;
% whos gimg
% whos S
S = uint8(S);
[r,c] = size(gimg);

img = zeros(r,c);
for i = 1:r
    for j = 1:c
        if gimg(i,j) >= 163
            img(i,j) = 1;
        end
    end
end
figure,imshow(mat2gray(img))


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'string',' ');
set(handles.edit2,'string',' ');
set(handles.edit3,'string',' ');
set(handles.edit4,'string',' ');
set(handles.edit5,'string',' ');