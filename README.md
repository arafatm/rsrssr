$ alias bundle-bootstrap='bundle install --binstubs=.bundle/bin --path=.bundle/gems --without production'

$ bundle-bootstrap

$ bundle exec ruby utils/seed.rb

$ bundle exec observr observr.rb
