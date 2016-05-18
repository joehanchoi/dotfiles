-- ----------------------------------------------------------------------------
-- Initial Setup
-- ----------------------------------------------------------------------------

-- No animations
hs.window.animationDuration = 0

local vw = hs.inspect.inspect
local configFileWatcher = nil
local appWatcher = nil
local frameCache = {}

-- Get list of screens and refresh that list whenever screens are plugged
-- or unplugged:
local screens = hs.screen.allScreens()
local screenwatcher = hs.screen.watcher.new(function()
    screens = hs.screen.allScreens()
end)
screenwatcher:start()

-- Modified hinting extension for when the window manager is triggered
-- local hintsb = require 'hintsb'

-- ----------------------------------------------------------------------------
-- Keyboard modifiers
-- ----------------------------------------------------------------------------
local modNone  = {}
local mAlt     = {"⌥"}
local modCmd   = {"⌘"}
local modShift = {"⇧"}
local modCtrl = {"^"}

local modHyper = {"⌥", "⌃"}
local modUltra = {"⌥", "⌃", "⇧"}

-- ----------------------------------------------------------------------------
-- Modules
-- ----------------------------------------------------------------------------

-- Move a window a number of pixels in x and y
function nudge(xpos, ypos)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	f.x = f.x + xpos
	f.y = f.y + ypos
	win:setFrame(f)
end

-- Resize a window by moving the bottom
function yank(xpixels,ypixels)
	local win = hs.window.focusedWindow()
	local f = win:frame()

	f.w = f.w + xpixels
	f.h = f.h + ypixels
	win:setFrame(f)
end

-- Resize window for chunk of screen.
-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function push(x, y, w, h)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w*x)
	f.y = max.y + (max.h*y)
	f.w = max.w*w
	f.h = max.h*h
	win:setFrame(f)
end

-- Move to monitor x. Checks to make sure monitor exists, if not moves to last
-- monitor that exists
function moveToMonitor(x)
	local win = hs.window.focusedWindow()
	local newScreen = nil
	while not newScreen do
		newScreen = screens[x]
		x = x-1
	end

	win:moveToScreen(newScreen)
end

-- Automatically reload config
function reloadConfig()
    configFileWatcher:stop()
    configFileWatcher = nil
    appWatcher:stop()
    appWatcher = nil
    hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/",
				       reloadConfig)
configFileWatcher:start()

-- Callback function for application events
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- Modal activation / deactivation
local modalKeys = {}
local modalActive = false

function modalBind( mods, key, callback )
    table.insert( modalKeys, hs.hotkey.new( mods, key, callback ) )
end

function disableModal()
    modalActive = false
    for keyCount = 1, #modalKeys do
        modalKeys[ keyCount ]:disable()
    end
    hs.alert.closeAll()
    hs.hints.closeHints()
    k:exit()
end

function enableModal()
    modalActive = true
    for keyCount = 1, #modalKeys do
        modalKeys[ keyCount ]:enable()
    end
    hs.alert.show( "Window manager active", 999999 )
end

hs.hotkey.bind( modHyper, 'space', function()
    if( modalActive ) then
        disableModal()
    else
        enableModal()
        hs.hints.windowHints(nil, sendMouseCenter)
    end
end )

modalBind( modNone, 'escape', function() disableModal() end )
modalBind( modNone, 'return', function() disableModal() end )


-- Move Active Window
function moveWindow(x, y, w, h)
    push(x, y, w, h);
    hs.hints.windowHints(nil, sendMouseCenter)
end

-- Cycle args for the function when called repeatedly:
-- cycleCalls( fn, { {args1...}, ... } )
function cycleCalls( fn, args )
    local argIndex = 0
    return function()
        argIndex = argIndex + 1
        if (argIndex > #args) then
            argIndex = 1;
        end
        fn( args[ argIndex ] );
    end
end

-- Toggle between full screen
function toggle_window_maximized()
    local win = hs.window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- Send mouse to center of window
function sendMouseCenter()
    hs.eventtap.keyStroke({"ctrl", "alt"}, "n")
end

-- Move cursor and click
-- pointTable is a table formatted as {x = xpos, y = ypos}
function positionCursorClick(pointTable)
    -- Move cursor and get its absolute position
    hs.mouse.setRelativePosition(pointTable)
    local absoluteMousePos = hs.mouse.getAbsolutePosition()

    local types = hs.eventtap.event.types
    hs.eventtap.event.newMouseEvent(types.leftMouseDown, absoluteMousePos):post()
    hs.eventtap.event.newMouseEvent(types.leftMouseUp, absoluteMousePos):post()
end

-- Notification for changes
hs.notify.new( {title='Hammerspoon', subTitle='Configuration loaded'} ):send()

-- Hinting Setup
hs.hints.hintChars = {"Y", "U", "I", "O", "P", ";", "N", "M", "/",
                      "6", "7", "8", "9", "0"}
hs.hints.showTitleThresh = 0
hs.hints.fontSize = 0

-- ----------------------------------------------------------------------------
-- Modal Keys
-- ----------------------------------------------------------------------------
-- Move & Resize Window
modalBind(modNone, 'h', function() push(0,0,0.5,1); hs.hints.windowHints(nil, sendMouseCenter) end)
modalBind(modNone, 'j', function() push(0.5,0.5,0.5,0.5); hs.hints.windowHints(nil, sendMouseCenter) end)
modalBind(modNone, 'k', function() push(0.5,0,0.5,0.5); hs.hints.windowHints(nil, sendMouseCenter) end)
modalBind(modNone, 'l', function() push(0.5,0,0.5,1); hs.hints.windowHints(nil, sendMouseCenter) end)

-- Center Screen
modalBind(modNone, 'c', function() push(0.1,0,0.8,1); hs.hints.windowHints(nil, sendMouseCenter) end)
modalBind(modNone, 'b', function() push(0.25,0.1,.5,.8); hs.hints.windowHints(nil, sendMouseCenter) end)

-- Move Active Window to Monitor
modalBind(modNone, '1', function() moveToMonitor(4); hs.hints.windowHints(nil, sendMouseCenter) sendMouseCenter() end)
modalBind(modNone, '2', function() moveToMonitor(1); hs.hints.windowHints(nil, sendMouseCenter) sendMouseCenter() end)
modalBind(modNone, '3', function() moveToMonitor(2); hs.hints.windowHints(nil, sendMouseCenter) sendMouseCenter() end)

-- Toggle Full Screen
modalBind(modNone, 'F',  toggle_window_maximized)

-- ----------------------------------------------------------------------------
-- Non-Modal Keys
-- ----------------------------------------------------------------------------
-- App Switcher (Hints)
hs.hotkey.bind(modHyper, 'O', function()
    hs.hints.windowHints(nil, sendMouseCenter)
end)

-- Move & Resize Window
hs.hotkey.bind(modUltra, 'h', function() moveWindow(0,0,0.5,1) end)
hs.hotkey.bind(modUltra, 'j', function() push(0.5,0.5,0.5,0.5); hs.hints.windowHints(nil, sendMouseCenter) end)
hs.hotkey.bind(modUltra, 'k', function() push(0.5,0,0.5,0.5); hs.hints.windowHints(nil, sendMouseCenter) end)
hs.hotkey.bind(modUltra, 'l', function() push(0.5,0,0.5,1); hs.hints.windowHints(nil, sendMouseCenter) end)
hs.hotkey.bind(modUltra, '6', function() moveWindow(0,0,0.7,1) end)
hs.hotkey.bind(modUltra, '9', function() moveWindow(.7,0,0.3,1) end)
hs.hotkey.bind(modUltra, 'f', function() toggle_window_maximized() end)

-- Center Screen
hs.hotkey.bind(modUltra, 'c', function() push(0.1,0,0.8,1) end)
hs.hotkey.bind(modUltra, 'b', function() push(0.25,0.1,.5,.8) end)

-- Move Active Window to Monitor
hs.hotkey.bind(modUltra, '1', function() moveToMonitor(4) end)
hs.hotkey.bind(modUltra, '2', function() moveToMonitor(1) end)
hs.hotkey.bind(modUltra, '3', function() moveToMonitor(2) end)

-- Moving cursor around active monitor
-- Left Center
hs.hotkey.bind(modHyper, 'h', function()
    local monitorXRes = hs.mouse.getCurrentScreen():frame().w
    local monitorYRes = hs.mouse.getCurrentScreen():frame().h

    local xPos = monitorXRes / 4
    local yPos = monitorYRes / 2
    positionCursorClick({x=xPos, y=yPos})
end)
-- Right Upper
hs.hotkey.bind(modHyper, 'k', function()
    local monitorXRes = hs.mouse.getCurrentScreen():frame().w
    local monitorYRes = hs.mouse.getCurrentScreen():frame().h

    local xPos = monitorXRes - monitorXRes / 4
    local yPos = monitorYRes / 3
    positionCursorClick({x=xPos, y=yPos})
end)

hs.hotkey.bind(modHyper, 'l', function()
    local monitorXRes = hs.mouse.getCurrentScreen():frame().w
    local monitorYRes = hs.mouse.getCurrentScreen():frame().h

    local xPos = monitorXRes - monitorXRes / 4
    local yPos = monitorYRes / 3
    positionCursorClick({x=xPos, y=yPos})
end)
-- Right Lower
hs.hotkey.bind(modHyper, 'j', function()
    local monitorXRes = hs.mouse.getCurrentScreen():frame().w
    local monitorYRes = hs.mouse.getCurrentScreen():frame().h

    local xPos = monitorXRes - monitorXRes / 4
    local yPos = monitorYRes - monitorYRes / 3
    positionCursorClick({x=xPos, y=yPos})
end)
