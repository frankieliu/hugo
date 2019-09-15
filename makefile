deploy:
	cd ~/github/hugo/public; \
	git add -A; \
	git commit -m"adding content"; \
	git push; \
	cd ~/github/hugo
server:
	hugo server -D
