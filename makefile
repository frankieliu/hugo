deploy:
	cd ~/github/hugo/public; \
	git add -A; \
	git commit -m"adding content"; \
	git push; \
	cd ~/github/hugo

server:
	hugo server -D

publish:
	git add -A
	git commit -m"Adding content"
	git push
	./publish-to-ghpages.sh
