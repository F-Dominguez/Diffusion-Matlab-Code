%**********************************************************
%* GraphUserInt                                           *
%* Graphical User Interface for dynamic plotting of data. *
%* By Francisco Dominguez                                 *
%**********************************************************

%This is the Graphical User Interface for the dynamic plots of
%data. The GUI was designed as an upgraded tool of videomaking 
%for the purpose of data analysis. In the GUI one can load the 
%data of a simulation for 2 populations, then pick from Thres-
%hold, Pconnect and Pn the values that will vary (picking 1 will
%net us a 2D graph and picking 2 a 3D graph), set the specific 
%value of everything that is constant and then plot the data.
%
%One must fill the values of everything that is to be constant.
%This means the appropriate Pn and Pconnect for both populations 
%and for the interaction between them. To do this, when one 
%clicks on the space provided to input the values, a slider with
%all the possibilities within that data set will appear; one can 
%then choose the desired value. To obtain the graph one simply 
%clicks on the "Generate Graph" button.
%
%Another important feature activated by checking the box 
%'Activate Slider' gives us the possibility to change one of the
%fixed values and obtain a new graph with those values. The graph
%is actually updated with the simple move of the slider represen-
%ting the vales of a given parameter. The 'Activate Slider' 
%checkbox must be checked before generating a graph.
%
%_____________________________________________________________

%NOTE: eventdata  reserved - to be defined in a future version...
%of MATLAB

function varargout = GraphUserInt(varargin)
% GraphUserInt(Pconnect_Perm,Pn_Perm,Thresh_Begin:...
%              Thresh_End,Average,MSE,NumPop)
% GraphUserInt MATLAB code for GraphUserInt.fig
% GraphUserInt, by itself, creates a new GraphUserInt or raises
% the existing singleton*.
%
% H = GraphUserInt returns the handle to a new GraphUserInt or 
% the handle to the existing singleton*.
%
% GraphUserInt('CALLBACK',hObject,eventData,handles,...) calls 
% the local function named CALLBACK in GraphUserInt.M with the 
% given input arguments.
%
% GraphUserInt('Property','Value',...) creates a new GraphUserInt 
% or raises the existing singleton*.  Starting from the left, 
% property value pairs are applied to the GUI before 
% GraphUserInt_OpeningFcn gets called. An unrecognized property 
% name or invalid value makes property application stop.  All 
% inputs are passed to GraphUserInt_OpeningFcn via varargin.
%
% *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows 
% only one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GraphUserInt

% Last Modified by GUIDE v2.5 16-May-2012 16:24:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GraphUserInt_OpeningFcn, ...
    'gui_OutputFcn',  @GraphUserInt_OutputFcn, ...
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


% --- Executes just before GraphUserInt is made visible.
function GraphUserInt_OpeningFcn(hObject, eventdata, handles,...
 varargin   %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% Choose default command line output for GraphUserInt
handles.output = hObject;
if isempty(varargin)
    handles.PopNums     = 2;
%     handles.Pcon_Perm   = {0:.4:3;1:2:10;1:1;1.2:.13:5};
%     handles.Pn_Perm     = {1:1;1.2:.13:5};
%     handles.Thresh_Perm = 17:2:25;
else
    handles.Pcon_Perm   = varargin{1};
    handles.Pn_Perm     = varargin{2};
    handles.Thresh_Perm = varargin{3};
    handles.Average     = varargin{4};
    handles.MSE         = varargin{5};
    handles.PopNums     = size(handles.Pcon_Perm,1);
end
handles.Cond{1} = [0 0];
handles.Cond{2} = 0;
handles.Cond{3} = 0;
handles.Cond{4} = [0 0];
handles.Thresh  = 0;
handles.activebutton = 0;

% Update handles structure
guidata(hObject, handles);
setappdata(handles.figure1,'fhUpdateGraph',...
           @Generate_Graph_Callback)
setappdata(0,'hMainGui',handles.figure1);
setappdata(handles.figure1,'handles',handles);
% UIWAIT makes GraphUserInt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the 
%     command line.
function varargout = GraphUserInt_OutputFcn(hObject,...
                     eventdata, handles)
% varargout  cell array for returning output args
% (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)...
    %#ok<*DEFNU,*INUSD>
% hObject    handle to popupmenu1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String'))
% returns popupmenu1 contents as cell array
% contents{get(hObject,'Value')} returns selected item 
% from popupmenu1

% get(hObject,

% --- Executes during object creation, after setting 
%     all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called
% Hint: popupmenu controls usually have a white background
% on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Thresh_Box.
function Thresh_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Thresh_Box (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
CheckBox_Change(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Thresh_Box


% --- Executes on button press in Pcon_Box.
function Pcon_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Pcon_Box (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
CheckBox_Change(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Pcon_Box


% --- Executes on button press in Pseed_Box.
function Pseed_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Pseed_Box (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
CheckBox_Change(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of Pseed_Box

function CheckBox_Change(hObject,handles)

Pcon_Check   = get(handles.Pcon_Box,'value');
Pseed_Check  = get(handles.Pseed_Box,'value');
Thresh_Check = get(handles.Thresh_Box,'value');
NumChecks    = Pcon_Check + Thresh_Check + Pseed_Check;
if NumChecks>2
    set(hObject,'Value',0)
    warndlg('You can only have a max of 2 boxes checked...
             for graphing.')
end


% --- Executes on selection change in Condition_Pop.
function Condition_Pop_Callback(hObject, eventdata, handles)
% hObject    handle to Condition_Pop (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) 
% returns Condition_Pop 
% contents as cell array
% contents{get(hObject,'Value')} returns selected item
% from Condition_Pop
PopNum = get(hObject,'value');
if handles.PopNums<2
    set(hObject,'value',1);
    warndlg('There is only one population for this data set!')
else
    if sqrt(PopNum)==round(sqrt(PopNum))
        set(handles.Pseed_Edit,'string',num2str(...
            handles.Cond{PopNum}(2)),'enable','inactive')
    else
        set(handles.Pseed_Edit,'string',num2str(0),...
        'enable','off')
    end
    set(handles.Pcon_Edit,'string',num2str(handles....
    Cond{PopNum}(1)))
end


% --- Executes during object creation, after setting all
% properties.
function Condition_Pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Condition_Pop (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called

% Hint: popupmenu controls usually have a white background
% on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pcon_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pcon_Edit (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pcon_Edit as
% text
% str2double(get(hObject,'String')) returns contents of Pcon_Edit
% as a double
PopNum = get(handles.Condition_Pop,'value');
handles.Cond{PopNum}(1) = str2double(get(hObject,'string'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all
% properties.
function Pcon_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pcon_Edit (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pseed_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Pseed_Edit (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pseed_Edit
% as text
%        str2double(get(hObject,'String')) returns contents of
% Pseed_Edit
% as a double
PopNum = get(handles.Condition_Pop,'value');
handles.Cond{PopNum}(2) = str2double(get(hObject,'string'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all
% properties.
function Pseed_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pseed_Edit (see GCBO)
% handles    empty - handles not created until after all
% CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Thresh_Edit_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Thresh_Edit_Start (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of 
% Thresh_Edit_Start as 
% text str2double(get(hObject,'String')) returns contents of 
% Thresh_Edit_Start as a double
handles.Thresh(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all 
% properties.
function Thresh_Edit_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thresh_Edit_Start (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

function Thresh_Edit_End_Callback(hObject, eventdata, handles)
% hObject    handle to Thresh_Edit_End (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of 
% Thresh_Edit_End as text
% str2double(get(hObject,'String')) returns contents of
% Thresh_Edit_End as a double
handles.Thresh(1) = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all
% properties.
function Thresh_Edit_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thresh_Edit_End (see GCBO)
% handles    empty - handles not created until after all 
% CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Generate_Graph.
function Generate_Graph_Callback(hObject, eventdata, handles)
% hObject    handle to Generate_Graph (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
hMainGui = getappdata(0,'hMainGui');
handles  = getappdata(hMainGui,'handles');

Pcon_Check   = get(handles.Pcon_Box,'value');
Pseed_Check  = get(handles.Pseed_Box,'value');
Thresh_Check = get(handles.Thresh_Box,'value');
NumChecks = Pcon_Check + Pseed_Check + Thresh_Check;
NumPop = length(handles.Cond);
PconCond = 1:NumPop;
PnCond = (1:sqrt(NumPop)).^2;

if NumChecks
    conditions = cell(0);
    for i = 1:NumPop
        if sqrt(i)==round(sqrt(i))
            if handles.Cond{i}(2)~=0
                conditions(end+1,:) = {'Pn' [sqrt(i)...
                 handles.Cond{i}(2)]}; %#ok<*AGROW>
                PnCond(PnCond==i) = [];
            end
        end
        if handles.Cond{i}(1)~=0
            conditions(end+1,:) = {'Pconnect'...
             [i handles.Cond{i}(1)]};
            PconCond(PconCond==i) = [];
        end
    end
    if handles.Thresh(1)~=0
        conditions(end+1,:) = {'Thresh' handles.Thresh};
    end
%     conditions(end+1,:) = {'Pn' [2 .8]};
%     conditions(end+1,:) = {'Pn' [3 .8]};
    [PconCols,PnCols,ThreshCols] = Find_Perm_Data...
        (conditions,handles.Pcon_Perm,handles.Pn_Perm,...
         handles.Thresh_Perm);
    Average      = handles.Average(ThreshCols,PnCols,PconCols);
    MSE          = handles.MSE(ThreshCols,PnCols,PconCols);
    
    if NumChecks>1
        if Thresh_Check && Pcon_Check
            ResResult = reshape(Average,[size(Average,1) ...
                        size(Average,3)]);
            
            X = handles.Thresh_Perm;
            Y = unique(handles.Pcon_Perm(PconCond,PconCols));
            [XX,YY] = meshgrid(Y,X);
            colormap cool;
            surf(handles.axes1,XX,YY,ResResult);
            view(handles.axes1,[-127.5 30]);
            xlabel(handles.axes1,'Pconnect');
            ylabel(handles.axes1,'Threshold');
            zlabel(handles.axes1,'Proportion of Adoption');
% title(['Adoption for Pn = (' num2str(handles.Cond{) ',...
% ' num2str(Pn2)'), Pconnect = ( : , ' num2str(Pc2) ',...
% ' num2str(Pc3) ', 'num2str(Pc4) '), Weight = (5,0,5,1)']);
        elseif Thresh_Check && Pseed_Check
            ResResult = reshape(Average,[size(Average,1)...
             size(Average,2)]);
            
            X = handles.Thresh_Perm;
            Y = unique(handles.Pn_Perm(PnCond,PnCols));
            [XX,YY] = meshgrid(Y,X);
            colormap cool;
            surf(handles.axes1,XX,YY,ResResult);
            view(handles.axes1,[-127.5 30]);
            xlabel(handles.axes1,'Pn');
            ylabel(handles.axes1,'Threshold');
            zlabel(handles.axes1,'Proportion of Adoption');
        elseif Pcon_Check && Pseed_Check
            ResResult = reshape(Average,[size(Average,2)...
             size(Average,3)]);
            
            X = unique(handles.Pn_Perm(PnCond,PnCols));
            Y = unique(handles.Pcon_Perm(PconCond,PconCols));
            [XX,YY] = meshgrid(Y,X);
            colormap cool;
            surf(handles.axes1,XX,YY,ResResult);
            view(handles.axes1,[-127.5 30]);
            xlabel(handles.axes1,'Pconnect');
            ylabel(handles.axes1,'Pn');
            zlabel(handles.axes1,'Proportion of Adoption');
        end
    else
        if Thresh_Check
            errorbar(handles.axes1,...
               handles.Thresh_Perm(ThreshCols),Average,MSE);
            title(handles.axes1,'Proportion vs. Thresh')
            xlabel(handles.axes1,'Threshold')
            ylabel(handles.axes1,...
            'Proportion of Adoption P=1-(NAf/IN)');
        elseif Pcon_Check
            errorbar(handles.axes1,...
            handles.Pcon_Perm(PconCols),Average,MSE);
            title(handles.axes1,'Proportion vs. Pconnect')
            xlabel(handles.axes1,'Pconnect')
            ylabel(handles.axes1,...
            'Proportion of Adoption P=1-(NAf/IN)');
        else
            errorbar(handles.axes1,...
               handles.Pn_Perm(1,PnCols),Average,MSE);
            title(handles.axes1,'Proportion vs. Pseed')
            xlabel(handles.axes1,'Pseed')
            ylabel(handles.axes1,...
            'Proportion of Adoption P=1-(NAf/IN)');
        end
    end
    axis(handles.axes1,'tight')
    elseif ~NumChecks || NumChecks>2
    warndlg('Must have at least one graph type checked!')
end


% --- If Enable == 'on', executes on mouse press in 
% --- 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixelr 
% --- border or over Pcon_Edit.
function Pcon_Edit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Pcon_Edit (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
PopNum  = get(handles.Condition_Pop,'value');
PconVal = str2double(get(hObject,'string'));
PconStr = get(handles.Condition_Pop,'string');

pUniq   = unique(handles.Pcon_Perm(PopNum,:));
pmin    = min(pUniq);
pmax    = max(pUniq);
if (pmax-pmin) %#ok<*BDLOG>
    pint    = abs(pUniq(2)-pUniq(1))/(pmax-pmin);
    pintL   = .25;
    if pintL < pint
        pintL = pint;
    end
else
    pint  = 1;
    pintL = pint;
end
if PconVal<pmin || PconVal>pmax
    PconVal = pmin;
end

newPconVal = ex_guide_timergui(pmin,pmax,PconVal,[pint pintL],...
    [PconStr{PopNum} ' Pconnect'],handles.activebutton);

if ~isempty(newPconVal)
    handles.Cond{PopNum}(1) = newPconVal;
    set(hObject,'string',num2str(newPconVal))
    hMainGui = getappdata(0,'hMainGui');
    setappdata(hMainGui,'handles',handles);
    guidata(hObject, handles);
end


% --- If Enable == 'on', executes on mouse press in 
% --- 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixelr 
% --- border or over Pseed_Edit.
function Pseed_Edit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Pseed_Edit (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
if strncmp(get(hObject,'enable'),'inactive',5)
    PopNum  = get(handles.Condition_Pop,'value');
    PnVal = str2double(get(hObject,'string'));
    PnStr = get(handles.Condition_Pop,'string');
    
    pUniq   = unique(handles.Pn_Perm(sqrt(PopNum),:));
    pmin    = min(pUniq);
    pmax    = max(pUniq);
    if (pmax-pmin)
        pint    = abs(pUniq(2)-pUniq(1))/(pmax-pmin);
        pintL   = .25;
        if pintL < pint
            pintL = pint;
        end
    else
        pint  = 1;
        pintL = pint;
    end
    if PnVal<pmin || PnVal>pmax
        PnVal = pmin;
    end
    
    newPnVal = ex_guide_timergui(pmin,pmax,PnVal,[pint pintL],...
        [PnStr{PopNum} ' Pn'],handles.activebutton);
    
    if ~isempty(newPnVal)
        handles.Cond{PopNum}(2) = newPnVal;
        set(hObject,'string',num2str(newPnVal))
        hMainGui = getappdata(0,'hMainGui');
        setappdata(hMainGui,'handles',handles);
        guidata(hObject, handles);
    end
end


% --- If Enable == 'on', executes on mouse press in 
% --- 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixelr 
% --- border or over Thresh_Edit_Start.
function Thresh_Edit_Start_ButtonDownFcn(hObject,...
         eventdata, handles)
% hObject    handle to Thresh_Edit_Start (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
if strncmp(get(hObject,'enable'),'inactive',5)
    ThVal = str2double(get(hObject,'string'));
    ThStr = 'Threshold Value';
    
    pUniq   = unique(handles.Thresh_Perm);
    pmin    = min(pUniq);
    pmax    = max(pUniq);
    if (pmax-pmin)
        pint    = abs(pUniq(2)-pUniq(1))/(pmax-pmin);
        pintL   = .25;
        if pintL < pint
            pintL = pint;
        end
    else
        pint  = 1;
        pintL = pint;
    end
    if ThVal<pmin || ThVal>pmax
        ThVal = pmin;
    end
    
    newThVal = ex_guide_timergui(pmin,pmax,ThVal,[pint pintL],...
        ThStr,handles.activebutton);
    
    if ~isempty(newThVal)
        handles.Thresh(1) = newThVal;
        set(hObject,'string',num2str(newThVal))
        hMainGui = getappdata(0,'hMainGui');
        setappdata(hMainGui,'handles',handles);
        guidata(hObject, handles);
    end
end


% --- Executes on button press in Active_Slider.
function Active_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Active_Slider (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of...
% Active_Slider
handles.activebutton = get(hObject,'Value');
guidata(hObject, handles);