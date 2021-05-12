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

# Testing

Using docker-bbq:

    workspace=/docs run
    
Then once inside the container

    cd /docs && bundle install

This installs the required gems

    bundle exec jekyll serve
