local folder_module = {}

function folder_module.new(name : string, parent : BasePart?)
    local f = Instance.new("Folder");
    f.Name = name;
    if parent then
        f.Parent = parent;
    end
    return f;
end

return folder_module;