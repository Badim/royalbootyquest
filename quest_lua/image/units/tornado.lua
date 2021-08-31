--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:96a93297cc2a7597df4d2e0ac6c5ae87:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- tornado_death/Frame00
            x=229,
            y=1,
            width=110,
            height=144,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 110,
            sourceHeight = 148
        },
        {
            -- tornado_death/Frame01
            x=235,
            y=146,
            width=106,
            height=144,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 110,
            sourceHeight = 148
        },
        {
            -- tornado_death/Frame05
            x=1,
            y=307,
            width=1,
            height=1,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 110,
            sourceHeight = 148
        },
        {
            -- tornado_go/Frame10
            x=118,
            y=156,
            width=116,
            height=150,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 120,
            sourceHeight = 154
        },
        {
            -- tornado_go/Frame11
            x=1,
            y=1,
            width=118,
            height=154,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 120,
            sourceHeight = 154
        },
        {
            -- tornado_go/Frame12
            x=120,
            y=1,
            width=108,
            height=148,

            sourceX = 12,
            sourceY = 4,
            sourceWidth = 120,
            sourceHeight = 154
        },
        {
            -- tornado_go/Frame13
            x=1,
            y=156,
            width=116,
            height=150,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 120,
            sourceHeight = 154
        },
    },
    
    sheetContentWidth = 342,
    sheetContentHeight = 342
}

SheetInfo.frameIndex =
{

    ["tornado_death/Frame00"] = 1,
    ["tornado_death/Frame01"] = 2,
    ["tornado_death/Frame05"] = 3,
    ["tornado_go/Frame10"] = 4,
    ["tornado_go/Frame11"] = 5,
    ["tornado_go/Frame12"] = 6,
    ["tornado_go/Frame13"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
