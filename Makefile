ERL=erl
ERLC=erlc
LIB=vorarbeiter

compile:
	@$(ERLC) -o ebin src/*.erl

clean:
	rm -f ebin/*.beam

docs:
	@$(ERL) -noshell -run edoc_run application '$(LIB)' '"."' \
	'[{private, true}]'

clean-docs:
	rm -f doc/edoc-info doc/*.html doc/*.css doc/*.png

test: compile
	@$(ERL) -pa ebin -eval "eunit:test({application,$(APP)})" \
	-noshell -s init stop
