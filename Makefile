include ../dotrc/Makefile

D=auto2 auto93 nasa93dem china coc1000 healthCloseIsses12mths0011-easy \
   healthCloseIsses12mths0001-hard pom #SSN SSM#
trees: ## trees test
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g tree; )

sneaks: ## sneak test
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g sneak; )

sways: ## sway test
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g sway; )

swaysneak: ## swaysneak
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g swaysneak; )

f=nasa93dem
knowns: ## compare items
	(lua treego.lua -f ../data/$f.csv -g sway; \
	lua treego.lua -f ../data/$f.csv -g sneak;  \
	lua treego.lua -f ../data/$f.csv -g swaysneak) #| grep KNOWN

README.md: tree.lua glua.lua ## update readme
	printf "\n# TREE\nTree learner via recursive random projections\n" > README.md
	lua $R/readme/readme.lua $^ >> README.md

local: $R/dotrc $R/readme $R/data  ## local install
	ln -sf $R/glua/glua.lua glua.lua
