.PHONY: h help

h help:
	bash ./install.sh -h

gm gitmerge:
	@git switch master && git merge --no-ff -m "merge dev" dev && git push && git switch dev

