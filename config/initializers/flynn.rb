# this will add the .flynnrc file that is used by the flynn cli
if Rails.env.production?
  puts `flynn cluster add -p #{ENV.fetch('FLYNN_TLSPIN')} default #{ENV.fetch('FLYNN_DOMAIN')} #{ENV.fetch('FLYNN_KEY')}`
end