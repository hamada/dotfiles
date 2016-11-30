------------------------------------------------------
-- hammerspoon config file
-- copy this file to ~/.hammerspoon/init.lua and reload hammerspoon
------------------------------------------------------

local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

-- Move cursor
remapKey({'alt'}, 'l', keyCode('right'))
remapKey({'alt'}, 'h', keyCode('left'))
remapKey({'alt'}, 'j', keyCode('down'))
remapKey({'alt'}, 'k', keyCode('up'))

-- Text editing
remapKey({'ctrl'}, 'm', keyCode('return'))
