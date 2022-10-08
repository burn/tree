# learn from a very small set of examples

local l=require"glua"

function order(i) --> fun; 
  return function(x,y)
           x=cells(t)[i]
           y=cells(t)[i]
           x=x=="?" and math.huge or x
           y=y=="?" and math.huge or y
           return x < y end end

function trees(rows,xs,yfun)
  local function cells(t) return t.cells and t.cells or t end
  yfun = yfun or function (t) return t.rank end
  for i=1,1000 do
    x   = any(xs)
    v1   = cells(any(row))[x]
    if v ~= "?" then
      a={},b={}
      for _,row in pairs(rows) do
        v2 = cells(row)[x]
        if v2 ~="?" then
          push(v2<=v1 and a or b,row) end end end
      asd = (#asd*sd(a,yfun) + #bsd*sd(b,yfun))/#rows
      bsd = sd(b,yfun)
    
    
