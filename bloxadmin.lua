-- 🎮 GACHA SHOP ACCESS TOOL
-- ⚠️ FOR EDUCATIONAL PURPOSES ONLY

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- تنظيف
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "GachaAccess" then
        gui:Destroy()
    end
end

-- واجهة صغيرة
local gui = Instance.new("ScreenGui")
gui.Name = "GachaAccess"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
frame.BorderSizePixel = 0
frame.Parent = gui

-- تحريك بالإصبع
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
title.Text = "🎮 GACHA ACCESS (اسحبني)"
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 12
title.Parent = frame

-- البحث عن زر الدخول
local function findEntryButton()
    return player.PlayerGui:FindFirstChild("Main") and
           player.PlayerGui.Main:FindFirstChild("Dialogue") and
           player.PlayerGui.Main.Dialogue:FindFirstChild("Option2")
end

-- البحث عن زر الشراء
local function findBuyButton()
    local path = {
        "GachaWindow", "HolidayGacha25", "Premium", 
        "MainGachaUI", "PurchaseFooter", "PreviewButton"
    }
    
    local current = player.PlayerGui
    
    for _, folder in ipairs(path) do
        current = current:FindFirstChild(folder)
        if not current then return nil end
    end
    
    return current
end

-- زر فتح المتجر
local openBtn = Instance.new("TextButton")
openBtn.Text = "🚪 OPEN GACHA SHOP"
openBtn.Size = UDim2.new(0.9, 0, 0, 35)
openBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.Parent = frame

-- زر شراء مباشر
local buyBtn = Instance.new("TextButton")
buyBtn.Text = "💰 DIRECT PURCHASE"
buyBtn.Size = UDim2.new(0.9, 0, 0, 35)
buyBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
buyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
buyBtn.TextColor3 = Color3.new(1, 1, 1)
buyBtn.Font = Enum.Font.SourceSansBold
buyBtn.Parent = frame

-- النتائج
local resultBox = Instance.new("TextLabel")
resultBox.Text = "👉 اضغط OPEN GACHA SHOP"
resultBox.Size = UDim2.new(0.9, 0, 0, 60)
resultBox.Position = UDim2.new(0.05, 0, 0.75, 0)
resultBox.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
resultBox.TextColor3 = Color3.new(1, 1, 1)
resultBox.TextWrapped = true
resultBox.Font = Enum.Font.SourceSans
resultBox.TextSize = 11
resultBox.Parent = frame

-- دالة الضغط على زر
local function clickButton(button)
    if not button then return false end
    
    -- طريقة 1: Fire click
    pcall(function() button:Fire("click") end)
    
    -- طريقة 2: استدعاء events
    if getconnections then
        pcall(function()
            local connections = getconnections(button.MouseButton1Click)
            for _, conn in pairs(connections) do
                conn:Fire()
            end
        end)
    end
    
    -- طريقة 3: تغيير مرئي
    if button:IsA("TextButton") then
        local original = button.Text
        button.Text = "⚡..."
        task.wait(0.1)
        button.Text = original
    end
    
    return true
end

-- فتح المتجر
openBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "🔍 جاري فتح متجر Gacha..."
    
    local entryButton = findEntryButton()
    if not entryButton then
        resultBox.Text = "❌ زر الدخول مش موجود\nافتح اللعبة أولاً"
        return
    end
    
    resultBox.Text = resultBox.Text .. "\n✅ وجدت زر الدخول"
    
    -- الضغط على زر الدخول
    local success = clickButton(entryButton)
    
    if success then
        resultBox.Text = resultBox.Text .. "\n🎯 نقرت على زر الدخول"
        
        -- انتظار تحميل المتجر
        task.wait(1)
        
        -- البحث عن زر الشراء بعد فتح المتجر
        local buyButton = findBuyButton()
        
        if buyButton then
            resultBox.Text = resultBox.Text .. "\n✅ وجدت زر الشراء!\n"
            resultBox.Text = resultBox.Text .. "📍 " .. buyButton.Name
            
            -- تغيير زر الشراء المباشر
            buyBtn.Text = "💰 BUY NOW (جاهز)"
            buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            resultBox.Text = resultBox.Text .. "\n❌ زر الشراء مخفي"
        end
    else
        resultBox.Text = "❌ فشل فتح المتجر"
    end
end)

-- شراء مباشر
buyBtn.MouseButton1Click:Connect(function()
    resultBox.Text = "💸 جاري محاولة شراء..."
    
    -- المحاولة 1: استخدام زر الشراء المباشر
    local buyButton = findBuyButton()
    if buyButton then
        clickButton(buyButton)
        resultBox.Text = resultBox.Text .. "\n✅ استخدمت زر الشراء"
    else
        resultBox.Text = resultBox.Text .. "\n❌ زر الشراء مخفي"
    end
    
    -- المحاولة 2: استخدام RemoteEvents
    task.wait(0.5)
    
    local shopRemotes = {
        "Shop",
        "SalesEvent", 
        "ServerSideBulkPurchaseEvent"
    }
    
    for _, remoteName in ipairs(shopRemotes) do
        local remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer({
                    product = "HolidayGacha25",
                    action = "purchase",
                    player = player,
                    timestamp = os.time()
                })
                resultBox.Text = resultBox.Text .. "\n📤 أرسلت عبر: " .. remoteName
            end)
        end
    end
    
    resultBox.Text = resultBox.Text .. "\n✅ انتهت محاولات الشراء"
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
    task.wait(2)
    
    resultBox.Text = "🔍 فحص تلقائي..."
    
    local entryButton = findEntryButton()
    if entryButton then
        resultBox.Text = resultBox.Text .. "\n✅ زر الدخول موجود"
    else
        resultBox.Text = resultBox.Text .. "\n❌ زر الدخول مش موجود"
    end
    
    local buyButton = findBuyButton()
    if buyButton then
        resultBox.Text = resultBox.Text .. "\n✅ زر الشراء موجود"
        buyBtn.Text = "💰 BUY NOW (جاهز)"
        buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        resultBox.Text = resultBox.Text .. "\n❌ زر الشراء مخفي/مش موجود"
    end
end)

print("========================================")
print("🎮 GACHA SHOP ACCESS LOADED")
print("🎯 Opens hidden Gacha shop")
print("⚠️  FOR EDUCATIONAL PURPOSES ONLY")
print("========================================")
