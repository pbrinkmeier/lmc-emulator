elm:
	elm-make --warn src/Main.elm --output target/lmc-emulator.js

format:
	elm-format --yes src/
