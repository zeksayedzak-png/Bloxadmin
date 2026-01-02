-- ⚡ INSTANT OPTION1 CLICK BYPASS
-- ⚠️ FOR EDUCATIONAL PURPOSES ONLY

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- تنظيف
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "InstantClick" then
        gui:Destroy()
    end
end

-- واجهة
local gui = Instance.new("ScreenGui")
gui.Name = "InstantClick"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
frame.BorderSizePixel = 0
frame.Parent = gui

-- تحريك
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local title = Instance.new("TextLabel")
title.Text = "⚡ INSTANT CLICK (اسحبني)"
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 12
title.Parent = frame

-- زر التفعيل
local activateBtn = Instance.new("TextButton")
activateBtn.Text = "🔓 ACTIVATE INSTANT CLICK"
activateBtn.Size = UDim2.new(0.9, 0, 0, 35)
activateBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
activateBtn.TextColor3 = Color3.new(1, 1, 1)
activateBtn.Font = Enum.Font.SourceSansBold
activateBtn.TextSize = 12
activateBtn.Parent = frame

-- زر النقر المتكرر
local rapidBtn = Instance.new("TextButton")
rapidBtn.Text = "🔄 RAPID CLICKS (10x)"
rapidBtn.Size = UDim2.new(0.9, 0, 0, 30)
rapidBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
rapidBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
rapidBtn.TextColor3 = Color3.new(1, 1, 1)
rapidBtn.Font = Enum.Font.SourceSansBold
rapidBtn.TextSize = 11
rapidBtn.Parent = frame

-- النتائج
local resultBox = Instance.new("TextLabel")
resultBox.Text = "👉 اضغط ACTIVATE أولاً"
resultBox.Size = UDim2.new(0.9, 0, 0, 60)
resultBox.Position = UDim2.new(0.05, 0, 0.7, 0)
resultBox.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
resultBox.TextColor3 = Color3.new(1, 1, 1)
resultBox.TextWrapped = true
resultBox.Font = Enum.Font.SourceSans
resultBox.TextSize = 11
resultBox.Parent = frame

-- البحث عن زر Option1
local function findOption1()
    return player.PlayerGui:FindFirstChild("Main") and
           player.PlayerGui.Main:FindFirstChild("Dialogue") and
           player.PlayerGui.Main.Dialogue:FindFirstChild("Option1")
end

-- دالة تجاوز وقت الانتظار
local function bypassWaitTime()
    local button = findOption1()
    
    if not button then
        resultBox.Text = "❌ Option1 مش موجود"
        return false
    end
    
    resultBox.Text = "🔧 جاري تجاوز وقت الانتظار...\n"
    
    -- الطريقة 1: البحث عن LocalScripts
    local foundScript = false
    
    for _, script in pairs(button:GetDescendants()) do
        if script:IsA("LocalScript") then
            pcall(function()
                local source = script.Source:lower()
                if source:find("wait") or source:find("delay") or source:find("cooldown") then
                    resultBox.Text = resultBox.Text .. "🎯 وجدت: " .. script.Name .. "\n"
                    
                    -- تعديل وقت الانتظار
                    script.Source = script.Source:gsub("wait%(%d+%.?%d*%)", "wait(0)")
                    script.Source = script.Source:gsub("task%.wait%(%d+%.?%d*%)", "task.wait(0)")
                    
                    resultBox.Text = resultBox.Text .. "✅ وقت الانتظار = 0"
                    foundScript = true
                end
            end)
        end
    end
    
    -- الطريقة 2: تعطيل events
    if getconnections and not foundScript then
        pcall(function()
            local connections = getconnections(button.MouseButton1Click)
            
            for _, conn in pairs(connections) do
                local funcInfo = debug.getinfo(conn.Function)
                local source = tostring(funcInfo.source):lower()
                
                if source:find("wait") or source:find("delay") then
                    conn:Disable()
                    resultBox.Text = resultBox.Text .. "⚡ عطلت فحص الوقت\n"
                    
                    -- إضافة وظيفة جديدة
                    button.MouseButton1Click:Connect(function()
                        resultBox.Text = "⚡ نقرت بدون انتظار!"
                    end)
                    
                    foundScript = true
                end
            end
        end)
    end
    
    if foundScript then
        resultBox.Text = resultBox.Text .. "\n✅ يمكنك النقر بدون انتظار!"
        return true
    else
        resultBox.Text = resultBox.Text .. "❌ ما لقيت كود انتظار"
        return false
    end
end

-- دالة النقر على Option1
local function clickOption1()
    local button = findOption1()
    
    if not button then
        resultBox.Text = "❌ زر Option1 مش موجود"
        return false
    end
    
    pcall(function()
        -- طريقة 1: Fire click
        button:Fire("click")
        
        -- طريقة 2: Events
        if getconnections then
            local connections = getconnections(button.MouseButton1Click)
            for _, conn in pairs(connections) do
                pcall(function() conn:Fire() end)
            end
        end
        
        -- طريقة 3: Remote مباشر
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:find("Option") then
                pcall(function()
                    remote:FireServer({
                        option = 1,
                        player = player,
                        instant = true
                    })
                end)
            end
        end
        
        resultBox.Text = "⚡ نقرت على Option1!"
        return true
    end)
    
    return false
end

-- تفعيل الاختراق
activateBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "🔓 جاري تفعيل النقر الفوري..."
    
    local success = bypassWaitTime()
    
    if success then
        activateBtn.Text = "✅ INSTANT CLICK ACTIVE"
        activateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        rapidBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        activateBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- نقر متكرر
rapidBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "🔄 جاري النقر 10 مرات...\n"
    
    spawn(function()
        for i = 1, 10 do
            clickOption1()
            resultBox.Text = resultBox.Text .. i .. ". نقرت\n"
            task.wait(0.1) -- تأخير قصير
        end
        
        resultBox.Text = resultBox.Text .. "\n✅ انتهى النقر 10 مرات!"
    end)
end)

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "✕"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -20, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- فحص تلقائي
spawn(function()
    task.wait(1)
    
    local button = findOption1()
    if button then
        resultBox.Text = "✅ زر Option1 موجود!\n"
        resultBox.Text = resultBox.Text .. "👉 اضغط ACTIVATE"
    else
        resultBox.Text = "❌ زر Option1 مش موجود\n"
        resultBox.Text = resultBox.Text .. "🔍 تأكد من فتح اللعبة"
    end
end)

print("========================================")
print("⚡ INSTANT OPTION1 CLICK LOADED")
print("🎯 Bypasses wait time between clicks")
print("⚠️  FOR EDUCATIONAL PURPOSES ONLY")
print("========================================")
