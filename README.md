# Next Steps

- Display articles in webpage
- checkbox to Mark articles read
- save article
- auto-mark read when scrolling
  - steal from http://coding.pressbin.com/26/Create-a-Google-Reader-knockoff-using-Javascript
- share article with friend (provide rss feed of 'shared')
- Some Auth


# Quick setup for Dev
$ alias bundle-bootstrap='bundle install --binstubs=.bundle/bin --path=.bundle/gems --without production'

$ bundle-bootstrap

$ bundle exec ruby utils/seed.rb

$ bundle exec observr observr.rb
