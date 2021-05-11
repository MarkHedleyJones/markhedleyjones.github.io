# TODO:
* Resize images for thumbnail display and target size
* Make whole project card clickable
* Add some visual feedback when curser over project card
* Make background off-white
* Adjust spacing in about
* Add profile picture in about
* Change thumb for Gamebike
* Make text justified by default (use tags when wanting centered)
* Standardise image path in posts 

# Building

From inside the Docker image (using docker-bbq modified to use /docs instead of /workspace) run

    bundle install

This installs the required gems

    bundle exec jekyll serve
