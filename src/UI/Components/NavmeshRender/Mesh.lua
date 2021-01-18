local import = require(game.ReplicatedStorage.Lib.Import)

local Roact = import "Roact"

local Mesh = Roact.PureComponent:extend("Mesh")

Mesh.defaultProps = {
	transparency = 0.8,
	color = Color3.fromRGB(255, 255, 255),
	size = Vector3.new(),
	cframe = CFrame.new()
}

function Mesh:init()
	self.folderRef = Roact.createRef()
end

function Mesh:render()
	return Roact.createElement("Folder", {
		[Roact.Ref] = self.folderRef
	})
end

function Mesh:cloneMesh()
	local props = self.props

	if self.meshInstance then
		self.meshInstance:Destroy()
	end

	local templateMesh = import(props.importPath)
	local meshInstance = templateMesh:Clone()
	self.meshInstance = meshInstance

	self:updateMeshProps()
	meshInstance.Parent = self.parent
end

function Mesh:updateMeshProps()
	local props = self.props
	local meshInstance = self.meshInstance
	meshInstance.Transparency = props.transparency
	meshInstance.Color = props.color
	meshInstance.Size = props.size
	meshInstance.CFrame = props.cframe
end

function Mesh:didUpdate(oldProps)
	local props = self.props

	local importPathChanged = props.importPath ~= oldProps.importPath
	if importPathChanged then
		self:cloneMesh()
	else
		self:updateMeshProps()
	end
end

function Mesh:didMount()
	local folder = self.folderRef:getValue()
	self.parent = folder.Parent
	folder.Parent = nil

	self:cloneMesh()
end

function Mesh:willUnmount()
	if self.meshInstance then
		self.meshInstance:Destroy()
	end
end



return Mesh
