----------------------------------------------------------------------

print("Test")

local function colorizeBackground(obj, r, g, b, a)
    obj.TopLeftRed = r
    obj.TopLeftGreen = g
    obj.TopLeftBlue = b
    obj.TopLeftAlpha = a
end

    -- Load fusion.
    -- local fusion = Fusion()
local comp = fusion:GetCurrentComp()

    -- Clear all tools.
local tools = comp:GetToolList(true) -- Get all tools in the flow
for _, tool in ipairs(tools) do
    comp:RemoveTool(tool) -- Remove each tool
end

    -- Generate metronome blocks.
local multiMerge = comp:AddTool("MultiMerge")
local tbg = comp:AddTool("Background")

colorizeBackground(tbg, 0, 0, 0, 0)

multiMerge:ConnectInput("Background", tbg)
for i = 1, 6 do
    local r = comp:AddTool("RectangleMask")

    -- r:SetInput("Width", 0.1)
    -- r:SetInput("Height", 0.2)
    r.Width = 0.1
    r.Height = 0.2
    r.Center = { 0.1 * i, 0.2 * i }
    -- r:SetInput("Center", { 0.1 * i, 0.2 * i })

    local b = comp:AddTool("Background")
    b:ConnectInput("EffectMask", r)
    multiMerge:ConnectInput("Layer" .. tostring(i) .. ".Foreground", b)
end

local merge = comp:AddTool("Merge")
local bg = comp:AddTool("Background")

colorizeBackground(bg, 0, 0.6, 0, 1)

merge:ConnectInput("Foreground", multiMerge)
merge:ConnectInput("Background", bg)

local output = comp:AddTool("MediaOut")

output:ConnectInput("Input", merge)

----------------------------------------------------------------------












--local flow = comp.CurrentFrame.FlowView
--comp:SetActiveTool(output)
--output:SetCurrentView(2)
--comp:RefreshView()


-- comp:SetPreview(output)

-- comp:ActiveViewer():ViewNode(comp:FindTool("MediaOut1"))

        -- comp:SetViewMode(output, "Right") -- 1 corresponds to RightView, 0 to LeftView


-- output:SetAttrs({TOOLBOX_RightView = true})


-- output:SetAttrs({["ViewRight"] = true})

 -- output:SetCurrentView(2)

--output:ViewOn(2)


-- output.RightView = 1

-- output.RightView = true

--[[
    -- Optional: set a default color (e.g., white)
    -- Color format is {R, G, B, A} with values from 0 to 1
    background:SetInput("TopColor", {R = 1, G = 1, B = 1, A = 1})
--]]

--[[

local r = comp:AddTool("RectangleMask", 1)
local bg1 = comp:AddTool("Background", 1)
local mo = comp:AddTool("MediaOut", 1)

bg1:ConnectInput("EffectMask", r)
mo:ConnectInput("Input", bg1)

-- Configure the rectangle properties
r.Width = 0.5
r.Height = 0.25
r.Center = {0.5, 0.5} -- Center of the screen
r.CornerRadius = 0.05 -- Optional: Rounded corners

bg1.TopLeftRed = 1
bg1.TopLeftGreen = 0
bg1.TopLeftBlue = 0

print("angklung script ended...")

]]--

--[[

-- https://www.youtube.com/watch?v=0RwKTNj6CpU

local operator = "GroupOperator"
local toolName = "MYTEXTTOOL"

local mainInput = "EffectMask"
local mainOutput = "Output"
local sourceTool = "Text1"
local input = {"StyledText", "Font", "Style", "Size"}

local macro = {
    Tools = {}
}
macro.Tools = table.ordered()
macro.Tools[toolName] = { __ctor = operator }
local tools = macro.Tools[toolName]

tools.ViewInfo = { __ctor = "GroupInfo" }
tools.Inputs = {}
tools.Inputs = table.ordered()
tools.Outputs = {}
table.Outputs = table.ordered()

local function addInputToTool(targetInputName, targetSource)
    tools[toolName].Inputs[targetInputName] = {
        __ctor = "InstanceInput",
        SourceOp = sourceTool,
        Source = targetSource,
        ControlGroup = 1,
        Page = "Text"
    }
end

addInputToTool(maintInput, "EffectMask")

for _, v in ipairs(inputs) do
    addInputToTool(v, v)  
end

tools[toolName].Outputs[mainOutput] = {
    __ctor = "InstanceOutput",
    SourceOp = sourceTool,
    Source = "Output"
}

local selected = comp:GetToolList(true)
t = comp:CopySettings(selected)
tools[toolName].Tools = t.Tools

comp:Paste(macro)

--]]
