server:
	hugo server -D

deploy:
	git add -A
	git commit -m"Adding content"
	git push
	./publish-to-ghpages.sh
