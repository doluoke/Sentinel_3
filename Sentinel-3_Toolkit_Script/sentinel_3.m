function varargout = sentinel_3(varargin)
%SENTINEL_3 MATLAB code file for sentinel_3.fig
%      SENTINEL_3, by itself, creates a new SENTINEL_3 or raises the existing
%      singleton*.
%
%      H = SENTINEL_3 returns the handle to a new SENTINEL_3 or the handle to
%      the existing singleton*.
%
%      SENTINEL_3('Property','Value',...) creates a new SENTINEL_3 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to sentinel_3_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SENTINEL_3('CALLBACK') and SENTINEL_3('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SENTINEL_3.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sentinel_3

% Last Modified by GUIDE v2.5 06-Apr-2017 15:24:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sentinel_3_OpeningFcn, ...
                   'gui_OutputFcn',  @sentinel_3_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before sentinel_3 is made visible.
function sentinel_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for sentinel_3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sentinel_3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sentinel_3_OutputFcn(hObject, eventdata, handles)
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
Data_Folder = uigetdir(pwd,'Directory to Downloaded Data');
x = inputdlg({'Output File Suffix Name','Orbit Number','Minimum Latitude',...
    'Maximum Latitude' }, 'Info', [1 25; 1 25; 1 25;1 25]); 

s3_reader(Data_Folder,x{2},[str2num(x{3}),str2num(x{4})],x{1})

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SingleProcess_TimeSeries
