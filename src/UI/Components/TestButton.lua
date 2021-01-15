local import = shared.___navmesh_tool_import

local Roact = import "Roact"
local e = Roact.createElement
local RoactKetchup = import "RoactKetchup"

local function TestButton(props)
    local enabled = props.enabled
    local pushToStore = props.pushToStore

    local color = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    return e("TextButton", {
        Text = "Hello!",
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = color,
        Size = UDim2.fromOffset(75, 75),
        [Roact.Event.Activated] = function()
            print("Activated! Setting enabled to", not enabled)
            pushToStore({
                enabled = not enabled
            })
        end
    })
end

return RoactKetchup.connect(
    function(state, props)
        print("Enabled is", state.enabled)
        return {
            enabled = state.enabled
        }
    end
)(TestButton)