elm:
	elm-make --warn src/Main.elm --output target/lmc-emulator.js
	cat js/*.js >> target/lmc-emulator.js

format:
	elm-format --yes src/

cssmin:
	cat css/*.css > target/all.css
	cat css/lmc/*.css >> target/all.css
	ycssmin target/all.css > target/i.min.css

uglify:
	make elm
	yuglify --terminal < target/lmc-emulator.js > target/i.min.js
