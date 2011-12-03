ERL=erl
ERLC=erlc
LIB=vorarbeiter

compile:
	[[ -d ebin ]] || mkdir ebin
	@$(ERLC) -o ebin src/*.erl

clean:
	rm -f ebin/*.beam

docs:
	@$(ERL) -noshell -run edoc_run application '$(LIB)' '"."' \
	'[{private, true}]'

clean-docs:
	rm -f doc/edoc-info doc/*.html doc/*.css doc/*.png
