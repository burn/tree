local l=require"glua"
local T=require"tree"
local any,cli,fmt,kap,lt,o,oo    = l.any, l.cli,l.fmt,l.kap,l.lt,l.o,l.oo
local per,pers,push,rnd,run,sort = l.per,l.pers,l.push,l.rnd,l.run,l.sort
local the=T.the
local DATA=T.DATA

local go={}
function go.the() oo(the) end

function go.rand()
  local t,a={},{10,20,30,40}
  for i=1,100 do push(t, l.rint(#a)) end end

function go.any() 
  local u={}
  for i=1,100 do  push(u,i) end; oo(sort(u)) end

function go.csv() 
  local i=1
  l.csv(the.file,function(row) i=i+1; if i<10 then oo(row) end end) end

function go.data() 
  local data=DATA(the.file) 
  oo(data.cols.x[1])
  return data.cols.x[1].hi == 8 end

function go.dist() 
  local data=DATA(the.file) 
  print(data:dist(data._rows[1],data._rows[2])) end 

function go.dists() 
  local data=DATA(the.file) 
  local all={}
  for _,row in pairs(data._rows) do
    push(all, rnd(data:dist(data._rows[1],row),3)) end 
  oo(sort(all)) end

function go.sorted()
  local data=DATA(the.file) 
  oo(data.cols.names)
  local rows=data:cheat() 
  for i = 1,#rows,1 do
    print(rows[i].rank, o(rows[i].cells)) end end

function go.clone() 
  local data1=DATA(the.file) 
  local data2=data1:clone(data1._rows)
  oo{b4=data1.cols.x[2].hi, now=data2.cols.x[2].hi}
  return data1.cols.x[2].hi == data2.cols.x[2].hi end 

function go.half()
  local data=DATA(the.file) 
  local xs,ys,x,y= data:half() 
  oo{dist=data:dist(x,y),  xsize=#xs._rows, ysize= #ys._rows}
  return data:dist(x,y)> .8 and 199== #xs._rows and 199 ==  #ys._rows end

function go.tree()
  local data=DATA(the.file)
  local _,parents= data:tree(4) 
  print("\n"..the.file,#data._rows)
  for _,parent in pairs(parents) do
     print(rnd(parent.gain,3), o{id=parent._id, level=parent.level, entropy=rnd(data:ent(parent._rows),3), nrows=#parent._rows}) end end

local function _rq1(fun)
  local out=  {[0]={}, [.25]={}, [.5]={}, [.75]={}}
  local known={[0]={}, [.25]={}, [.5]={}, [.75]={}}
  local rands={[0]={},[.25]={}, [.5]={}, [.75]={}}
  local usedys={}
  for i=1,20 do
    io.write(".");io.flush()
    local data=DATA(the.file)
    data:cheat()
    -- local tmp1={}
    fun(data)
     --._rows) do   push(tmp1,row.rank) end
    -- sort(tmp1); for k,v in pairs(out) do push(v, per(tmp1,k)) end

    local tmp2={}
    local n=0; for _,row in pairs(data._rows) do if row.usedy then push(tmp2,row.rank);  n=n+1 end end ; push(usedys,n) 
    sort(tmp2); for k,v in pairs(known) do push(v, per(tmp2,k)) end

    local tmp3={}
    for i=1,n/2 do local row=l.any(data._rows);push(tmp3,row.rank) end
    sort(tmp3); for k,v in pairs(rands) do push(v, per(tmp3,k)) end
    end

  local out1,known1,rands1 = {},{},{}
  --for k,v in pairs(out)   do push(out1,   fmt("%s(%s)", math.floor( k*100), per(sort(v), .5))) end 
  for k,v in pairs(known) do push(known1, fmt("%s(%s)", math.floor(k*100) , per(sort(v),.5))) end 
  for k,v in pairs(rands) do push(rands1, fmt("%s(%s)", math.floor(k*100) , per(sort(v),.5))) end 
  print("")
  print(the.file)
  --print("GUESSED",o(sort(out1)), l.fmt(" %-30s",the.file)) 
  print("KNOWN",o(sort(known1)))
  print("BASE",o(sort(rands1)))
  --out=sort(out); print("GUESSED",o(l.map({0,.1,.3,.5,.7,.9},function(p) return l.per(out,p) end)), l.fmt(" %-30s",the.file)) 
  --print(               "KNOWN  ",o(l.pers(sort(known), {0,.1,.3,.5,.7,.9})))
  sort(usedys); io.write(            "EVALED  ",o(l.pers(sort(usedys), {0,.1,.3,.5,.7,.9})))
end

local function _enough() return math.log(math.log(1- .95,2)/ math.log(1- .35/6),2) end

local function _rq2(fun)
  local found={}
  local rands={}
  local eval={}
  for i=1,20 do
    io.write(".");io.flush()
    local data=DATA(the.file)
    data:cheat()
    fun(data)
    local n=0; for _,row in pairs(data._rows) do if row.usedy then push(found,row.rank);  n=n+1 end end ; push(eval,n) 
    for i=1,n do local row=l.any(data._rows);push(rands,row.rank) end
  end
  print("")
  print(the.file, rnd(_enough(),2))
  print("FOUND",o(l.pers(sort(found),{0,.1,.3,.5,.7,.9})))
  print("RANDS",o(l.pers(sort(rands),{0,.1,.3,.5,.7,.9})))
  print("EVALS",o(l.pers(sort(eval),{0,.1,.3,.5,.7,.9})))
end

function go.sneak() _rq2(function(data) return data:sneak() end) end
function go.sway()  _rq2(function(data) return data:sway(.33) end) end
function go.swaysneak()  _rq2(function(data) return data:sneak():sway() end) end

function go.tree()
  local data=DATA(the.file)
  for _,row in pairs(data:split()) do print(row.guess) end end

the=cli(the)
os.exit(run(go,the))
