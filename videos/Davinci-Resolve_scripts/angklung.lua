local u = require("utilities")

    -- breakpoints.
    -- Timecode without the hour mark.
local timecodeOfBeats = {
        -- Kajar Intro
    '00:00:03', '00:00:09', '00:00:15', '00:00:22', '00:01:04', '00:01:10',
    '00:01:16', '00:01:22', '00:02:05', '00:02:11', '00:02:17', '00:02:23',
    '00:03:06', '00:03:12', '00:03:18', '00:04:00', '00:04:06', '00:04:13',
    '00:04:19', '00:05:01', '00:05:07', '00:05:13', '00:05:20', '00:06:02',
        -- Ostinato
    '00:06:08', '00:06:14', '00:06:20', '00:07:03', '00:07:09', '00:07:15',
    '00:07:21', '00:08:03', '00:08:10', '00:08:16', '00:08:22', '00:09:04',
    '00:09:10', '00:09:17', '00:09:23', '00:10:05', '00:10:11', '00:10:18',
    '00:11:00', '00:11:06', '00:11:12', '00:11:18', '00:12:01', '00:12:07',
        -- Build I
    '00:12:13', '00:12:19', '00:13:01', '00:13:08', '00:13:14', '00:13:20',
    '00:14:02', '00:14:08', '00:14:15', '00:15:03', '00:15:09', '00:15:15',
}

--for k, v in pairs(timecodeOfBeats) do
--    print( k .. ' | ' .. v .. ' | ' .. timecodeToFrame(v) )
--end

local comp = fusion:GetCurrentComp()

--local t = comp.ActiveTool
--local attrs = t:GetAttrs()
--u.dump(attrs)

local merge = comp:AddTool("Merge")
local rectangle = comp:AddTool("RectangleMask")
local rectangleBackground = comp:AddTool("Background")
local rectangleTransform = comp:AddTool("ofx.com.blackmagicdesign.resolvefx.Transform")
local output = comp:AddTool("MediaOut")
local background = comp:AddTool("Background")

merge:ConnectInput("Background", background)
rectangleBackground:ConnectInput("EffectMask", rectangle)
--rectangleTransform:ConnectInput("Source", rectangleBackground)
merge:ConnectInput("Foreground", rectangleBackground)
output:ConnectInput("Input", merge)

--local rectangleTransformComp = rectangleTransform:Comp()
--rectangleTransform.posX = rectangleTransformComp:AddTool('BezierSpline')
--rectangleTransform.posY = rectangleTransformComp:AddTool('BezierSpline')

u.setupBackgroundNodeForSolidColoring(background)
u.colorizeBackgroundNodeWithSolid(background, 0,   0.677, 0.331, 0.559, 1.0)
u.colorizeBackgroundNodeWithSolid(background, 100, 0.2,   1,     0.7,   0.4)

u.setupRectangleNodeForShaping(rectangle)

--rectangle.CenterX[0]   = 0.1
--rectangle.CenterX[100] = 0.9
--rectangle.CenterY[0]   = 0.5
--rectangle.CenterY[100] = 1

rectangle.Width[0] = 0.063
rectangle.Height[0] = 0.101
rectangle.CornerRadius[0] = 0.7

rectangle.Width[1000] = 0.063
rectangle.Height[1000] = 0.101
rectangle.CornerRadius[1000] = 0

    -- This works.
--rectangle.Center = {0.2, 0.9}


rectangle.Center[1]   = {0.2, 0.9}
rectangle.Center[100] = {0.9, 0.2}


--rectangle.Center:ConnectTo(comp:AddTool("Path"))
--local path = rectangle.Center:GetConnectedOutput():GetTool()
--path.Value[10] = {0.2, 0.2}
--path.Value[50] = {0.8, 0.8}



--rectangle.Center:SetKeyFrames({
--    [1] =   {0.2, 0.9},
--    [100] = {0.9, 0.2}
--})


--rectangleTransform.posX[0]    = 0
--rectangleTransform.posX[1000] = -4

--rectangleTransform.posY[0]    = 0
--rectangleTransform.posY[1000] = 0.5

--comp:SetKeyframe(rectangle, "Center", 0
--comp:SetKeyframe(rectangle, "Center", 100)

--rectangle.Center:SetKeyframe(0, {0.2, 0.5}, "Linear")
--rectangle.Center:SetKeyframe(100, {0.8, 0.5}, "Linear")

--rectangle:SetInput("Center", { x = 0.2, y = 0.2 }, 1)
--rectangle:SetInput("Center", { x = 0.5, y = 0.7 }, 10)

for k, v in pairs(timecodeOfBeats) do
    local frame = u.timecodeToFrame(v)
    rectangle.Width[frame] = 0.065
    rectangle.Height[frame] = 0.108
    rectangle.CornerRadius[frame] = 0.3
    rectangle.Width[frame + 1] = 0.063
    rectangle.Height[frame + 1] = 0.101
    rectangle.CornerRadius[frame + 1] = 0.7
end
