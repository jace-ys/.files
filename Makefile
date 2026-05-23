export:
	cursor --list-extensions > cursor/extensions.txt
	code --list-extensions > vscode/extensions.txt

bootstrap:
	./setup.sh
