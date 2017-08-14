# this will add the .flynnrc file that is used by the flynn cli
return unless Rails.env.production?

flynnrc = File.join(ENV['HOME'], '.flynnrc')
return if File.file?(flynnrc)

html = File.open(Rails.root.join('vendor', 'flynnrc.erb')).read
template = ERB.new(html)
File.open(flynnrc, 'w') do |f|
  f.puts template.result
end