--Variables
local func = {}
--Functions
local isGood = function(a,b)
    if ((not a) or (not b)) then
        error("pack/unpack <input> <output>")
    end
    if not fs.exists(a) then
        error("Invalid input location")
    end
end
local subList = function(l,a,b)
    local out = {}
    for i = a,b do
        out[#out+1] = l[i]
    end
    return out
end
local joinL = function(...)
    local lists = {...}
    local out = {}
    for a = 1,#lists do
        for b = 1,#lists[a] do
            out[#out+1] = lists[a][b]
        end
    end
    return out
end
local replList = function(a,i,b)
    local l1 = subList(a,1,i-1)
    local l2 = subList(a,i+1,#a)
    return joinL(l1,b,l2)
end
local getSub
getSub = function(path,extra)
    local l = fs.list(path)
    local offset = 0
    for a = 1,#l do
        i = a+offset
        --print(fs.combine(path,l[i]),fs.isDir(fs.combine(path,l[i])))
        if fs.isDir(fs.combine(path,l[i])) then
            local oldlen = #l
            l = replList(l,i,getSub(fs.combine(path,l[i]),fs.combine(extra,l[i])))
            offset = offset+(#l-oldlen)
        else
            l[i] = fs.combine(extra,l[i])
        end
    end
    return l
end
func.pack = function(inp,out,data)
    isGood(inp,out)
    local files = getSub(inp,"")
    local output = {}
    output.meta = data
    for i = 1,#files do
        local f = fs.open(fs.combine(inp,files[i]),"r")
        local str = f.readAll()
        f.close()
        output[#output+1] = {files[i],str}
    end
    local f = fs.open(out,"w")
    f.write(textutils.serialize(output))
    f.close()
end
func.unpack = function(inp,out)
    isGood(inp,out)
    local f = fs.open(inp,"r")
    local tbl = textutils.unserialize(f.readAll())
    f.close()
    for i = 1,#tbl do
        local f = fs.open(fs.combine(out,tbl[i][1]),"w")
        f.write(tbl[i][2])
        f.close()
    end
end
func.uninstall = function(packed,root)
  local f = fs.open(packed,"r")
  tbl = textutils.unserialize(f.readAll())
  f.close()
  for i = 1,#tbl do
      fs.delete(fs.combine(root,tbl[i][1]))
      local path = fs.combine(root,tbl[i][1])
      while fs.getDir(path) ~= ".." and fs.getDir(path) ~= "" do
          if #fs.list(fs.getDir(path)) == 0 then
              fs.delete(fs.getDir(path))
              path = fs.getDir(path)
          else
              break
          end
      end
  end
end
func.getMeta = function(packed)
    local f = fs.open(packed,"r")
    local d = textutils.unserialize(f.readAll())
    f.close()
    return d.meta
end
--Code
--func.subList = subList
--func.replList = replList
--func.getSub = getSub
--func.joinL = joinL
return func
