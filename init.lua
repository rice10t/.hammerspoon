KEY_H = 4
KEY_ENTER = 36
KEY_L = 37
KEY_J = 38
KEY_K = 40
KEY_N = 45
KEY_M = 46
KEY_SPACE = 49
KEY_DEL = 51
KEY_ESCAPE = 53
KEY_EISUU = 102
KEY_KANA = 104
KEY_LEFT = 123
KEY_RIGHT = 124
KEY_DOWN = 125
KEY_UP = 126
-- 英数キーが押下されている状態かどうか
local eisuuKeyPressing = false

-- 指定したキーを入力する
local function sendKey(keyCode)
    hs.eventtap.keyStroke({}, keyCode, 0)
end

local function handleKeyDown(keyCode)
    if keyCode == KEY_EISUU then
        -- 英数キー入力中
        eisuuKeyPressing = true
    end

    if eisuuKeyPressing then
        -- ここで英数キーが押されている場合のキーコンフィグを設定する

        if keyCode == KEY_H then
            sendKey(KEY_LEFT)
            return true
        elseif keyCode == KEY_J then
            sendKey(KEY_DOWN)
            return true
        elseif keyCode == KEY_K then
            sendKey(KEY_UP)
            return true
        elseif keyCode == KEY_L then
            sendKey(KEY_RIGHT)
            return true
        elseif keyCode == KEY_N then
            sendKey(KEY_DEL)
            return true
        elseif keyCode == KEY_M then
            sendKey(KEY_RIGHT)
            sendKey(KEY_DEL)
            return true
        elseif keyCode == KEY_SPACE then
            sendKey(KEY_ENTER)
            return true
        end
    end

    return false
end

local function handleKeyUp(keyCode)
    if keyCode == KEY_EISUU then
        -- 英数キーが入力中でない
        eisuuKeyPressing = false
    end
end

eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(event)
    local pressedKeyCode = event:getKeyCode()
    local eventType = event:getType()

    if eventType == hs.eventtap.event.types.keyDown then
        local fired = handleKeyDown(pressedKeyCode)
        print('fired:')
        print(fired)
        if fired then
            return true
        end
    elseif eventType == hs.eventtap.event.types.keyUp then
        -- キーが離されたとき
        handleKeyUp(pressedKeyCode)
    end
end)

eventtap:start()

-- ctrl + escapeのときの設定
hs.hotkey.bind({'ctrl'}, 30, 'esc',
    function() 
        sendKey(KEY_ESCAPE)
    end,
    nil,
    function()
        sendKey(KEY_ESCAPE)
    end
)