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
-- かなキーが押下されている状態かどうか
local kanaKeyPressing = false
-- 最後に押されたキー
local lastTimeDownKey = null

-- 指定したキーを入力する
local function sendKey(keyCode)
    hs.eventtap.keyStroke({}, keyCode, 0)
end

local function handleKeyDown(keyCode)
    if keyCode == KEY_EISUU then
        -- 英数キー入力中
        eisuuKeyPressing = true
    end

    if keyCode == KEY_KANA then
        -- かなキー入力中
        kanaKeyPressing = true
    end

    if keyCode == KEY_EISUU or keyCode == KEY_KANA then
        if lastTimeDownKey == keyCode then
            -- (かなキー|英数キー)が２回連続で押されたときのみ(かな入力|英数入力)に移行する
            lastTimeDownKey = keyCode
            return false
        else
            lastTimeDownKey = keyCode
            return true
        end
    end

    local hotkeyFired = false

    if eisuuKeyPressing then
        -- ここで英数キーが押されている場合のキーコンフィグを設定する

        if keyCode == KEY_H then
            sendKey(KEY_LEFT)
            hotkeyFired = true
        elseif keyCode == KEY_J then
            sendKey(KEY_DOWN)
            hotkeyFired = true
        elseif keyCode == KEY_K then
            sendKey(KEY_UP)
            hotkeyFired = true
        elseif keyCode == KEY_L then
            sendKey(KEY_RIGHT)
            hotkeyFired = true
        elseif keyCode == KEY_N then
            sendKey(KEY_DEL)
            hotkeyFired = true
        elseif keyCode == KEY_M then
            sendKey(KEY_RIGHT)
            sendKey(KEY_DEL)
            hotkeyFired = true
        elseif keyCode == KEY_SPACE then
            sendKey(KEY_ENTER)
            hotkeyFired = true
        end
    end

    if kanaKeyPressing then
        -- ここでかなキーが押されている場合のキーコンフィグを設定する

        if keyCode == KEY_H then
            hs.eventtap.keyStroke({'cmd'}, KEY_LEFT, 0)
            hotkeyFired = true
        elseif keyCode == KEY_L then
            hs.eventtap.keyStroke({'cmd'}, KEY_RIGHT, 0)
            hotkeyFired = true
        elseif keyCode == KEY_J then
            -- 上手く動かないのでコメントアウト
            -- hs.eventtap.keyStroke({'fn'}, KEY_DOWN, 0)
            hotkeyFired = true
        elseif keyCode == KEY_K then
            -- 上手く動かないのでコメントアウト
            -- hs.eventtap.keyStroke({'fn'}, KEY_UP, 0)
            hotkeyFired = true
        end

    end

    lastTimeDownKey = keyCode
    if hotkeyFired then
        -- 設定したキーバインドが使用された場合は元のキーイベントは無効化する
        return true
    else 
        return false
    end
end

local function handleKeyUp(keyCode)
    if keyCode == KEY_EISUU then
        -- 英数キーが入力中でない
        eisuuKeyPressing = false
    elseif keyCode == KEY_KANA then
        -- かなキーが入力中でない
        kanaKeyPressing = false
    end

    -- キーアップイベントは常に成功する
    return false
end

eventtap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, function(event)
    local pressedKeyCode = event:getKeyCode()
    local eventType = event:getType()

    if eventType == hs.eventtap.event.types.keyDown then
        -- キーが押下されたとき
        return handleKeyDown(pressedKeyCode)
    elseif eventType == hs.eventtap.event.types.keyUp then
        -- キーが離されたとき
        return handleKeyUp(pressedKeyCode)
    end
end)

eventtap:start()

-- ctrl + [ = Escape
hs.hotkey.bind({'ctrl'}, 30, 'esc',
    function() 
        sendKey(KEY_ESCAPE)
    end,
    nil,
    function()
        sendKey(KEY_ESCAPE)
    end
)