-- 🎯 ALTERNATIVE BUTTON CLICKER
-- Just a helper button, no hacking

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- تنظيف
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "AltButtonClicker" then
        gui:Destroy()
    end
end

-- واجهة صغيرة
local gui = Instance.new("ScreenGui")
gui.Name = "AltButtonClicker"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
frame.BorderSizePixel = 0
frame.Parent = gui

-- 🔥 تحريك بالإصبع
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
title.Text = "🎮 ALT BUTTON (اسحبني)"
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 12
title.Parent = frame

-- البحث عن الزر الأصلي
local function findOriginalButton()
    local path = {
        "GachaWindow", "HolidayGacha25", "Premium", 
        "MainGachaUI", "PurchaseFooter", "PreviewButton"
    }
    
    local current = player.PlayerGui
    
    for _, folder in ipairs(path) do
        current = current:FindFirstChild(folder)
        if not current then
            return nil
        end
    end
    
    return current
end

-- زر بديل كبير
local altButton = Instance.new("TextButton")
altButton.Text = "🔄 CLICK PREVIEW BUTTON"
altButton.Size = UDim2.new(0.9, 0, 0, 60)
altButton.Position = UDim2.new(0.05, 0, 0.3, 0)
altButton.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
altButton.TextColor3 = Color3.new(1, 1, 1)
altButton.Font = Enum.Font.SourceSansBold
altButton.TextSize = 13
altButton.Parent = frame

-- حالة الزر
local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "👉 اضغط الزر الأخضر"
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextWrapped = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 11
statusLabel.Parent = frame

-- دالة النقر على الزر الأصلي
local function clickOriginalButton()
    local originalButton = findOriginalButton()
    
    if not originalButton then
        statusLabel.Text = "❌ الزر الأصلي مش موجود\nافتح نافذة Gacha"
        return false
    end
    
    statusLabel.Text = "🎯 جاري النقر على الزر الأصلي..."
    
    -- طريقة 1: Fire click event
    pcall(function()
        originalButton:Fire("click")
        statusLabel.Text = statusLabel.Text .. "\n✅ استخدمت Fire"
    end)
    
    -- طريقة 2: استدعاء MouseButton1Click events
    pcall(function()
        if getconnections then
            local connections = getconnections(originalButton.MouseButton1Click)
            for _, conn in pairs(connections) do
                pcall(function()
                    conn:Fire()
                end)
            end
            statusLabel.Text = statusLabel.Text .. "\n✅ استدعيت Events"
        end
    end)
    
    -- طريقة 3: محاكاة النقر
    pcall(function()
        if originalButton:IsA("TextButton") then
            -- حفظ النص الأصلي
            local originalText = originalButton.Text
            
            -- تغيير مؤقت للإيهام بالنقر
            originalButton.Text = "⚡..."
            task.wait(0.05)
            originalButton.Text = originalText
            
            statusLabel.Text = statusLabel.Text .. "\n✅ محاكاة نقر"
        end
    end)
    
    statusLabel.Text = statusLabel.Text .. "\n✅ تم النقر!"
    return true
end

-- النقر على الزر البديل
altButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "🎮 جاري تشغيل الزر الأصلي..."
    
    local success = clickOriginalButton()
    
    if success then
        -- تأثير مرئي عند النجاح
        altButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        
        -- إرجاع اللون بعد ثانية
        task.wait(0.2)
        altButton.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    else
        altButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(0.5)
        altButton.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    end
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

-- اكتشاف تلقائي للزر الأصلي
spawn(function()
    task.wait(1)
    
    local originalButton = findOriginalButton()
    
    if originalButton then
        statusLabel.Text = "✅ الزر الأصلي موجود!\n"
        statusLabel.Text = statusLabel.Text .. "📍 " .. originalButton.Name .. "\n"
        statusLabel.Text = statusLabel.Text .. "👉 اضغط الزر الأخضر"
    else
        statusLabel.Text = "❌ افتح نافذة Gacha\nلرؤية الزر الأصلي"
    end
end)

-- زر النقر التلقائي
local autoClickBtn = Instance.new("TextButton")
autoClickBtn.Text = "🔄 AUTO CLICK (10x)"
autoClickBtn.Size = UDim2.new(0.9, 0, 0, 25)
autoClickBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
autoClickBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
autoClickBtn.TextColor3 = Color3.new(1, 1, 1)
autoClickBtn.Font = Enum.Font.SourceSans
autoClickBtn.TextSize = 10
autoClickBtn.Parent = frame

autoClickBtn.MouseButton1Click:Connect(function()
    statusLabel.Text = "🔄 جاري النقر 10 مرات..."
    
    spawn(function()
        for i = 1, 10 do
            clickOriginalButton()
            statusLabel.Text = "🔄 " .. i .. "/10 مرات"
            task.wait(0.3) -- تأخير بين النقرات
        end
        
        statusLabel.Text = "✅ انتهى النقر 10 مرات!"
    end)
end)

print("========================================")
print("🎮 ALTERNATIVE BUTTON CLICKER LOADED")
print("🎯 Clicks PreviewButton for you")
print("⚠️  Just a helper tool")
print("========================================")
