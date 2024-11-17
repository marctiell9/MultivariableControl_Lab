function [sys,x0,str,ts,simStateCompliance] = pendulum_animation(t, x, u, flag, params)
%PENDAN S-function for making pendulum animation.
%
%   See also: PENDDEMO.

%   Copyright 1990-2014 The MathWorks, Inc.

% Plots every major integration step, but has no states of its own
switch flag

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(params);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2
    sys=mdlUpdate(t,x,u, params);
    
  case 3
    sys=mdlOutput(t,x,u, params);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9
    sys=mdlTerminate();
    
  %%%%%%%%%%%%%%%%
  % Unused flags %
  %%%%%%%%%%%%%%%%
  case { 1, 4}
    sys = [];
    
  %%%%%%%%%%%%%%%
  % DeleteBlock %
  %%%%%%%%%%%%%%%
  case 'DeleteBlock'
    LocalDeleteBlock()
    
  %%%%%%%%%
  % Close %
  %%%%%%%%%
  case 'Close'
    LocalClose(params(4))
    
  case 'Output'
    sys=mdlOutput(t,[-1],u, params);
    error(message('simdemos:general:UnhandledFlag', 'Ecchecazze'));
  
  %%%%%%%%%%%%
  % Playback %
  %%%%%%%%%%%%
  case 'Slider'
    slider1_Callback();
   
  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(message('simdemos:general:UnhandledFlag', num2str( flag )));
end

% end pendan

function slider1_Callback()
    fig = get_param(gcbh,'UserData');
    if ishghandle(fig, 'figure')
        mSlider = findobj(fig,'Tag','leftPush');
        cval = get(mSlider, 'Value');
        set(mSlider, 'Value', round(cval));
    end
%end


%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(params)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times, for the pendulum example,
% the animation is updated every 0.1 seconds
%
ts  = [params(5) 0];

%
% create the figure, if enabled
%
if params(4)
    LocalPendInit(params);
end

% specify that the simState for this s-function is same as the default
simStateCompliance = 'DefaultSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlUpdate
% Update the pendulum animation.
%=============================================================================
%
function sys=mdlUpdate(t, x, u, params) %#ok<INUSL>

fig = get_param(gcbh,'UserData');
if ishghandle(fig, 'figure') 
  if strcmp(get(fig,'Visible'),'on')
    ud = get(fig,'UserData');
    LocalPendSets(t,ud, u, params);
  end
end
 
sys = [];
% end mdlUpdate

function sys=mdlOutput(t, x, u, params) %#ok<INUSL>
    fig = get_param(gcbh,'UserData');
    if ishghandle(fig, 'figure')
        leftcheck = findobj(fig,'Tag','leftPush');
        sys = get(leftcheck, 'Value');
    else
        sys = -1;
    end
     
% end mdlOutput
    
%
%=============================================================================
% mdlTerminate
% Re-enable playback buttong for the pendulum animation.
%=============================================================================
%
function sys=mdlTerminate() 
    sys = [];

% end mdlTerminate

%
%=============================================================================
% LocalDeleteBlock
% The animation block is being deleted, delete the associated figure.
%=============================================================================
%
function LocalDeleteBlock()

fig = get_param(gcbh,'UserData');
if ishghandle(fig, 'figure')
  delete(fig);
  set_param(gcbh,'UserData',-1)
end

%
%=============================================================================
% LocalClose
% The callback function for the animation window close button.  Delete
% the animation figure window.
%=============================================================================
%
function LocalClose(enabled)
if enabled
    delete(gcbf)
end
% end LocalClose


%
%=============================================================================
% LocalPendSets
% Local function to set the position of the graphics objects in the
% inverted pendulum animation window.
%=============================================================================
%
function LocalPendSets(time,ud,u, params)
L         = params(3);
theta     = -u(3);
HCart     = L / 5;
XDelta    = L / 20;
PDelta    = L / 50;
XPendTop = u(2) + L*sin(theta);
YPendTop = L*cos(theta);
PDcosT   = PDelta*cos(theta);
PDsinT   = -PDelta*sin(theta);

CircT = linspace(0, 2*pi);
HingeLowRad = 1.25 * PDelta;
HingeHighRad = 3 * PDelta;
HLX = HingeLowRad*cos(CircT) + u(2);
HHX = HingeHighRad*cos(CircT) + XPendTop;
HHY = HingeHighRad*sin(CircT) + YPendTop;


set(ud.Cart,...
  'XData',ones(2,1)*[u(2)-4*XDelta u(2)+4*XDelta]);
set(ud.Pend,...
  'XData',[XPendTop-PDcosT XPendTop+PDcosT; u(2)-PDcosT u(2)+PDcosT], ...
  'YData',[YPendTop-PDsinT YPendTop+PDsinT; -PDsinT PDsinT] - HCart/2);
set(ud.TimeField,...
  'String',num2str(time));
set(ud.RefMark, 'XData',u(1)+[-XDelta 0 XDelta]);
set(ud.HingeLow, 'XData', HLX);
set(ud.HingeHigh, 'XData', HHX, 'YData', HHY - HCart/2);

% Force plot to be drawn
pause(0)
drawnow

% end LocalPendSets


%
%=============================================================================
% LocalPendInit
% Local function to initialize the pendulum animation.  If the animation
% window already exists, it is brought to the front.  Otherwise, a new
% figure window is created.
%=============================================================================
%
function LocalPendInit(params)

%
% The name of the reference is derived from the name of the
% subsystem block that owns the pendulum animation S-function block.
% This subsystem is the current system and is assumed to be the same
% layer at which the reference block resides.
%

TimeClock = 0;
RefSignal = params(1); %str2double(get_param([sys '/' RefBlock],'Value'));
XCart     = params(1);
Theta     = -params(2);
L         = params(3);

XDelta    = L / 20;
HCart     = L / 5;
HRef      = HCart / 4;
PDelta    = L / 50;
XPendTop  = XCart + L*sin(Theta); % Will be zero
YPendTop  = L*cos(Theta);         % Will be 10
PDcosT    = PDelta*cos(Theta);     % Will be 0.2
PDsinT    = -PDelta*sin(Theta);    % Will be zero

CircT = linspace(0, 2*pi);
HingeLowRad = 1.25 * PDelta;
HingeHighRad = 3 * PDelta;
HLX = HingeLowRad*cos(CircT) + XCart;
HHX = HingeHighRad*cos(CircT) + XPendTop;
HHY = HingeHighRad*sin(CircT) + YPendTop;

%
% The animation figure handle is stored in the pendulum block's UserData.
% If it exists, initialize the reference mark, time, cart, and pendulum
% positions/strings/etc.
%
% Fig = get_param(gcbh,'UserData');
% if ishghandle(Fig ,'figure')
%   FigUD = get(Fig,'UserData');
%   set(FigUD.RefMark, 'XData', RefSignal+[-XDelta 0 XDelta]);
%   set(FigUD.RefMark1, 'XData', RefSignal + L +[-XDelta 0 XDelta]);
%   set(FigUD.RefMark2, 'XData', RefSignal - L +[-XDelta 0 XDelta]);
%   set(FigUD.TimeField, 'String', num2str(TimeClock));
%   set(FigUD.Cart,'XData', ones(2,1)*[XCart-4*XDelta XCart+4*XDelta]);
%   set(FigUD.Pend, 'XData',[XPendTop-PDcosT XPendTop+PDcosT; XCart-PDcosT XCart+PDcosT],...
%                   'YData',[YPendTop-PDsinT YPendTop+PDsinT; -PDsinT PDsinT] - HCart/2);
%   set(FigUD.HingeLow, 'XData', HLX);
%   set(FigUD.HingeHigh, 'XData', HHX, 'YData', HHY - HCart/2);
%   
%   mSlider = findobj(fig,'Tag','leftPush');
%   set(mSlider, 'Value', 0);    % Restore to 0
%   %
%   % bring it to the front
%   %
%   figure(Fig);
%   return
% end

%
% the animation figure doesn't exist, create a new one and store its
% handle in the animation block's UserData


HLY = HingeLowRad*sin(CircT);

FigureName = 'Pendulum Visualization';
Fig = figure(...
  'Units',           'pixel',...
  'Position',        [100 100 500 300],...
  'Name',            FigureName,...
  'NumberTitle',     'off',...
  'IntegerHandle',   'off',...
  'HandleVisibility','callback',...
  'Resize',          'off',...
  'CloseRequestFcn', 'pendulum_animation([],[],[],''Close'', [0, 0, 1, true, 0.05]);');
AxesH = axes(...
  'Parent',  Fig,...
  'Units',   'pixel',...
  'Position',[50 50 400 200],...
  'CLim',    [1 64], ...
  'Xlim',    [-L-HingeHighRad L+2*HingeHighRad],...
  'Ylim',    [-(HCart+HRef)  L+HingeHighRad],...
  'Visible', 'off');
Cart = surface(...
  'Parent',   AxesH,...
  'XData',    ones(2,1)*[XCart-4*XDelta XCart+4*XDelta],...
  'YData',    [0 0; -HCart -HCart],...
  'ZData',    zeros(2),...
  'CData',    11*ones(2));
Pend = surface(...
  'Parent',   AxesH,...
  'XData',    [XPendTop-PDcosT XPendTop+PDcosT; XCart-PDcosT XCart+PDcosT],...
  'YData',    [YPendTop-PDsinT YPendTop+PDsinT; -PDsinT PDsinT] - HCart / 2,...
  'ZData',    zeros(2),...
  'CData',    11*ones(2));
RefMark = patch(...
  'Parent',   AxesH,...
  'XData',    RefSignal+[-XDelta 0 XDelta],...
  'YData',    [-HCart-HRef, -HCart, -HCart-HRef],...
  'CData',    22,...
  'FaceColor','flat');
HingeLow = patch(...
  'Parent',   AxesH,...
  'XData',    HLX,...
  'YData',    HLY - HCart/2,...
  'CData',    22,...
  'FaceColor','flat');
HingeHigh = patch(...
  'Parent',   AxesH,...
  'XData',    HHX,...
  'YData',    HHY - HCart/2,...
  'CData',    22,...
  'FaceColor','flat');
RefMark1 = patch(...
  'Parent',   AxesH,...
  'XData',    RefSignal+ L +[-XDelta 0 XDelta],...
  'YData',    [-HCart-HRef, -HCart, -HCart-HRef],...
  'CData',    61,...
  'FaceColor','flat');
RefMark2 = patch(...
  'Parent',   AxesH,...
  'XData',    RefSignal - L +[-XDelta 0 XDelta],...
  'YData',    [-HCart-HRef, -HCart, -HCart-HRef],...
  'CData',    61,...
  'FaceColor','flat');
uicontrol(...
  'Parent',  Fig,...
  'Style',   'text',...
  'Units',   'pixel',...
  'Position',[0 0 500 50]);
uicontrol(...
  'Parent',             Fig,...
  'Style',              'text',...
  'Units',              'pixel',...
  'Position',           [250 0 100 25], ...
  'HorizontalAlignment','right',...
  'String',             'Time: ');
TimeField = uicontrol(...
  'Parent',             Fig,...
  'Style',              'text',...
  'Units',              'pixel', ...
  'Position',           [350 0 100 25],...
  'HorizontalAlignment','left',...
  'String',             num2str(TimeClock));
uicontrol(...
  'Parent',  Fig,...
  'Style',   'pushbutton',...
  'Position',[415 15 70 20],...
  'String',  'Close', ...
  'Callback', sprintf('pendulum_animation([],[],[],''Close'', [0, 0, 1, true, %f]);', params(5)));
uicontrol(...
  'Parent',             Fig,...
  'Style',              'text',...
  'Units',              'pixel',...
  'Position',           [15 0 125 25], ...
  'HorizontalAlignment','right',...
  'String',             'Perturb the system: ');
uicontrol(...
  'Parent',  Fig,...
  'Style',   'slider',...
  'Position',[150 5 100 20],...
  'String',  'Perturbate:', ...
  'Callback', sprintf('pendulum_animation([],[],[],''Slider'', [0, 0, 1, true, %f]);', params(5)), ...
  'Value', 0, ...
  'Min',   -3, 'Max', 3, ...
  'Tag','leftPush');

%
% all the HG objects are created, store them into the Figure's UserData
%
FigUD.Cart         = Cart;
FigUD.Pend         = Pend;
FigUD.TimeField    = TimeField;
FigUD.RefMark      = RefMark;
FigUD.RefMark1      = RefMark1;
FigUD.RefMark2      = RefMark2;
FigUD.HingeLow     = HingeLow;
FigUD.HingeHigh    = HingeHigh;
FigUD.Block        = get_param(gcbh,'Handle');
% FigUD.RefBlock     = get_param([sys '/' RefBlock],'Handle');
set(Fig,'UserData',FigUD);

drawnow

%
% store the figure handle in the animation block's UserData
%
set_param(gcbh,'UserData',Fig);

% end LocalPendInit
