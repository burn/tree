#  __                             
# /\ \__                          
# \ \ ,_\   _ __     __      __   
#  \ \ \/  /\`'__\ /'__`\  /'__`\ 
#   \ \ \_ \ \ \/ /\  __/ /\  __/ 
#    \ \__\ \ \_\ \ \____\\ \____\
#     \/__/  \/_/  \/____/ \/____/

MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell dirname $(shell git rev-parse --show-toplevel))

help: ## print help
	printf "\n#tree\nmake [OPTIONS]\n\nOPTIONS:\n"
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}\
	               {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

D=auto2 auto93 nasa93dem china coc1000 healthCloseIsses12mths0011-easy \
   healthCloseIsses12mths0001-hard pom #SSN SSM#
trees: ## DEMO. checks  if best breaks are at root of tree (level=1) or other
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g tree; )

sneaks: ## DEMO. checks  if best breaks are at root of tree (level=1) or other
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g sneak; )

sways: ## DEMO. checks  if best breaks are at root of tree (level=1) or other
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g sway; )

swaysneak: ## DEMO. checks  if best breaks are at root of tree (level=1) or other
	$(foreach d,$D, lua treego.lua -f $R/data/$d.csv -g swaysneak; )

f=nasa93dem
knowns:
	(lua treego.lua -f ../data/$f.csv -g sway; \
	lua treego.lua -f ../data/$f.csv -g sneak;  \
	lua treego.lua -f ../data/$f.csv -g swaysneak) #| grep KNOWN

README.md: treelib.lua tree.lua ## update readme
	printf "\n# TREE\nTree learner via recursive random projections\n" > README.md
	lua $R/readme/readme.lua tree.lua treelib.lua >> README.md

install: $R/dotrc $R/readme $R/data

$R/readme:; cd $R; git clone https://github.com/burn/readme
$R/data  :; cd $R; git clone https://github.com/burn/data
$R/dotrc :; cd $R; git clone https://github.com/burn/dotrc; 
	printf "\n\nSuggestion: consider cd $R/dotrc; make install\n\n"

itso: ## commit to Git. To add a message, set `y=message`.
	git commit -am "$y"; git push; git status
	cd ../dotrc; $(MAKE) push

~/tmp/%.pdf: %.lua  ## .lua ==> .pdf
	mkdir -p ~/tmp
	echo "pdf-ing $@ ... "
	a2ps                 \
		-Br                 \
		-l 100                 \
		--file-align=fill      \
		--line-numbers=1        \
		--borders=no             \
		--pro=color               \
		--left-title=""            \
		--pretty-print="$R/dotrc/lua.ssh" \
		--columns 3                  \
		-M letter                     \
		--footer=""                    \
		--right-footer=""               \
	  -o	 $@.ps $<
	ps2pdf $@.ps $@; rm $@.ps
	open $@


