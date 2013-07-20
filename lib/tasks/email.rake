namespace :spam do
  desc "Gets the inputs from the corpus of emails"
  task :read_input => :environment do
    EmailProcessor.process! 
  end
end
