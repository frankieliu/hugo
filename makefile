.PHONY: server deploy

server:
	xdg-open "http://localhost:1313/hugo/"
	hugo server -D

deploy:
	git add -A
	git commit -m"Adding content"
	git push
	./publish-to-ghpages.sh
