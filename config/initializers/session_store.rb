# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cron-checker_session',
  :secret      => 'c9d2210b76d964eaafe248b99ff991361f4878a48333f638d9ef64113057fffcdff38f6b620278b4079f43ba7fded355e0dc2df3cdf777ca188401ca5b0eb912'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
