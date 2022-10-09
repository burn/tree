-- learn from a very small set of examples
local g=require"glua"
local gt,lt,obj = g.gt, g.lt, g.obj
local push,rint,sort = g.push, g.rint, g.sort

local the={bins=8}

local BIAS=obj"BIAS"

function BIAS:new(t)
  self.n, self.lst, self.indx = 0,{},{}
  for _,x in pairs(t or {}) do self:like(x) end end

function BIAS:like(x,n) --> nil; increment our like of x
  n = n or 1
  self.n         = self.n + n
  self.indx[x]   = self.indx[x] or push(self.lst, {w=0,x=x})
  self.indx[x].w = n + self.indx[x].w end 

function BIAS:any(t)
  self.lst = sort(self.lst,gt"w")
  return function()
    local r = rint(self.n)
    for i,wx in pairs(self.lst) do
      r = r - wx.w
      if r<=0 or i==#self.lst then return wx.x end end end end 


local function trees(top, rows, yfun)
  local function div(at,v1)
    local a,b = {},{}
    for _,row in pairs(rows) do
      local v2 = row.cells[at]
      if v2 ~="?" then
        push(v2<=v1 and a or b,row) end end end
  local p=PICK()
  for _,col in pairs(top.cols.x) do
    tmp = {}
    for _,row in pairs(rows) do
      tmp[col:discretize(row.cells[row.at])] = 1 end
    for v,_ in pairs(tmp) do p:like({at=col.at,v=v}) end end
  local function xpect(a,b)
    return (#a*sd(a,yfun) + #b*sd(b,yfun))/(#a + #b) end
  one = p:any()
  budget = 256
  while budget > 0 do
    local r = one()
    local a,b = div(r.at,v.v)
    tmp = xpect(a,b)
    if tmp > max then
      budget = budget * 1.2
      p:like(one)
      one = p:any() end end end 

p=PICK{1,1,1,1,2,2,3,3}
p=p:any(); for i=1,10^2 do print(p()) end
