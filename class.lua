local Class = {}
Class.__index = Class

function Class:inherit()
    local Subclass = {}
    Subclass.__index = Subclass
    setmetatable(Subclass, self)
    return Subclass
end

function Class:initialize()
    error("this class cannot be initialized")
end

function Class:new(...)
    local instance = {}
    setmetatable(instance, self)
    self.initialize(instance, ...)
    return instance
end

return Class