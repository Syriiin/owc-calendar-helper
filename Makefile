help:  ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

update-calendars:  ## Update all calendars
	docker compose run --build owc-calendar-helper

update-readme:  ## Update README.md with calendar links
	scripts/update-readme-links.sh

build-site:  ## Build the website
	docker compose run owc-calendar-helper python website/generatesite.py
