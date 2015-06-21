%*********************************************************
%* ex_guide_timergui                                     *
%* Matlab generated code for the GUI.                    *
%* By Francisco Dominguez                                *
%*********************************************************

%This is part of the GUI. It is essentially a Matlab generated
%code for the designed GUI to obtain the graphs.
%_____________________________________________________________

% NOTE: eventdata  reserved - to be defined in a future 
%       version of MATLAB

function varargout = ex_guide_timergui(varargin)
% EX_GUIDE_TIMERGUI - Execute graphic updates at 
% regular intervals
%   MATLAB code for ex_guide_timergui.fig
%      EX_GUIDE_TIMERGUI, by itself, creates a new 
%      EX_GUIDE_TIMERGUI or raises the existing singleton*.
%
%      H = EX_GUIDE_TIMERGUI returns the handle to a new 
%      EX_GUIDE_TIMERGUI or the handle to the existing 
%      singleton*.
%
%      EX_GUIDE_TIMERGUI('CALLBACK',hObject,eventData,...
%      handles,...)
%      calls the local function named CALLBACK in  
%      EX_GUIDE_TIMERGUI.M with the given input arguments.
%
%      EX_GUIDE_TIMERGUI('Property','Value',...) creates a new 
%      EX_GUIDE_TIMERGUI or raises the existing singleton*.
%      Starting from the left, property value pairs are applied
%      to the GUI before ex_guide_timergui_OpeningFcn gets 
%      called. An unrecognized property name or invalid value 
%      makes property application stop.  All inputs are passed
%      to ex_guide_timergui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI
%       allows only one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES, TIMER

% Last Modified by GUIDE v2.5 16-May-2012 13:24:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
           'gui_Singleton',  gui_Singleton, ...
           'gui_OpeningFcn', @ex_guide_timergui_OpeningFcn, ...
           'gui_OutputFcn',  @ex_guide_timergui_OutputFcn, ...
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


% --- Executes just before ex_guide_timergui is made visible.
function ex_guide_timergui_OpeningFcn(hObject, eventdata,...
    handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ex_guide_timergui
% (see VARARGIN)

% Choose default command line output for ex_guide_timergui
handles.output = [];

% START USER CODE
% Create a timer object to fire at 1/10 sec intervals
% Specify function handles for its start and run callbacks
% handles.timer = timer(...
%  'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly
%  Initial period is 1 sec.
%  'Period', 1, ...                        
%  Specify callback function
%  'TimerFcn', {@update_display,hObject}); 
% Initialize slider and its readout text field
if isempty(varargin)
    handles.pmin  = 0;
    handles.pmax  = 100;
    pVal  = 50;
    handles.pStep = [.01 .1];
    handles.Activ = 0;
else
    handles.pmin  = varargin{1};
    handles.pmax  = varargin{2};
    pVal  = varargin{3};
    handles.pStep = varargin{4};
    handles.GUItitle = varargin{5};
    set(handles.guilabel,'String',handles.GUItitle)
    handles.Activ = varargin{6};
end
set(handles.periodsldr,'Min',handles.pmin,'Max',handles.pmax,...
                'Value',pVal,'SliderStep',handles.pStep)
% set(handles.periodsldr,'Value',get(handles.timer,'Period'))
set(handles.slidervalue,'String',...
    num2str(get(handles.periodsldr,'Value')))
set(handles.text4,'String',num2str(handles.pmin))
set(handles.text5,'String',num2str(handles.pmax))
% END USER CODE

guidata(hObject,handles);
% Update handles structure
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command 
% --- line.
function varargout = ex_guide_timergui_OutputFcn(hObject,...
     eventdata,handles) 
% varargout  cell array for returning output args 
% (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on slider movement.
function periodsldr_Callback(hObject, eventdata, handles)
% hObject    handle to periodsldr (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
% get(hObject,'Min') and get(hObject,'Max') to determine 
% range of slider

% START USER CODE
% Read the slider value
period = get(handles.periodsldr,'Value');
% Timers need the precision of periods to be greater than about
% 1 millisecond, so truncate the value returned by the slider
% period = period - mod(period,.01);
pmax = handles.pmax;
pmin = handles.pmin;
pStep = handles.pStep;
if abs(round(period/(pmax-pmin)/pStep(1))-(period/(pmax-pmin)////
    pStep(1)))>eps
    period = round(period/(pmax-pmin)/...
             pStep(1))*(pmax-pmin)*pStep(1);
end
if period>pmax
    period = pmax;
elseif period<pmin
    period = pmin;
end
% Set slider readout to show its value
set(handles.slidervalue,'String',num2str(period))
set(handles.periodsldr,'Value',period)
if handles.Activ
    hMainGui = getappdata(0,'hMainGui');
%     setappdata(hMainGui,'Slider',period)
    fhUpdateGraph = getappdata(hMainGui,'fhUpdateGraph');
    handles2 = getappdata(hMainGui,'handles');
    if strncmp(handles.GUItitle(end),'e',1)
        handles2.Thresh(1) = period;
        set(handles2.Thresh_Edit_Start,'string',num2str(period))
    else
        if strncmp(handles.GUItitle(end),'t',1)
            set(handles2.Pcon_Edit,'string',num2str(period))
            handles2.Cond{get(handles2.Condition_Pop,...
                    'value')}(1) = period;
        else
            set(handles2.Pseed_Edit,'string',num2str(period))
            handles2.Cond{get(handles2.Condition_Pop,...
                    'value')}(2) = period;
        end
    end
    setappdata(hMainGui,'handles',handles2);
    feval(fhUpdateGraph,[],[],[])
end
% If timer is on, stop it, reset the period, and start it again.
% if strcmp(get(handles.timer, 'Running'), 'on')
%     stop(handles.timer);
%     set(handles.timer,'Period',period)
%     start(handles.timer)
% else         % If timer is stopped, reset its period only.
%     set(handles.timer,'Period',period)
% end
% END USER CODE


% --- Executes during object creation, after setting 
% --- all properties.
function periodsldr_CreateFcn(hObject, eventdata,handles)
% hObject    handle to periodsldr (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% START USER CODE
% Necessary to provide this function to prevent timer callback
% from causing an error after GUI code stops executing.
% Before exiting, if the timer is running, stop it.
% if strcmp(get(handles.timer, 'Running'), 'on')
%     stop(handles.timer);
% end
% % Destroy timer
% delete(handles.timer)
% END USER CODE

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);


% --- Executes on button press in OK_Button.
function OK_Button_Callback(hObject, eventdata, handles)
% hObject    handle to OK_Button (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
period = get(handles.periodsldr,'Value');
% Timers need the precision of periods to be greater than about
% 1 millisecond, so truncate the value returned by the slider
% period = period - mod(period,.01);
handles.output = period;
% Update handles structure
guidata(hObject,handles);
uiresume(handles.figure1);

% --- Executes on button press in Cancel_Button.
function Cancel_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_Button (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
handles.output = 0;
% Update handles structure
guidata(hObject,handles);
uiresume(handles.figure1);