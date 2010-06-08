# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_thrift-cappuccino-example_session',
  :secret      => '0c3441d0db49d362cbfb31ddfe7822dfbd9e928c0ddd856147024659231c7a22d23608725b5bc8e7bed59285d1f504973f920af3e9fabc50673c2ebb69a34b96'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
