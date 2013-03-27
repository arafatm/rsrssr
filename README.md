# Plan

## UI

### Articles

- Read articles
- Mark read
- auto-mark read when scrolling
- save article

### Feeds

- CRUD Feed
- Read all feeds

### Security

- Some Auth


# Quick setup for Dev
$ alias bundle-bootstrap='bundle install --binstubs=.bundle/bin --path=.bundle/gems --without production'

$ bundle-bootstrap

$ bundle exec ruby utils/seed.rb

$ bundle exec observr observr.rb
