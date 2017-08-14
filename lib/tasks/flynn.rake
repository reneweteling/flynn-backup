namespace :flynn do 
  task test: :environment do 

    return unless Rails.env.production?

    flynnrc = File.join(ENV['HOME'], '.flynnrc-test')
    return if File.file?(flynnrc)
  
    html = File.open(Rails.root.join('vendor', 'flynnrc.erb')).read
    template = ERB.new(html)
    File.open(flynnrc, 'w') do |f|
      f.puts template.result
    end

  end 
end





