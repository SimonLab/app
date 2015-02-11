#!/usr/bin/env ruby 
require 'octokit'
require 'json'
require 'optparse'

class App
  VERSION = '0.0.1'
  def initialize(arguments)
    @args = arguments
    @options = {}
  end
  
  def run
    if arguments_valid? && parsed_options?
      puts "ok lets go"
    else
      puts "wrong number arguments"
    end
  end



  protected

    def parsed_options?
      # Specify options
      opts = OptionParser.new 
      opts.on('-v', '--version')    { version ; exit 0 }
     # opts.on('-h', '--help')       { output_help }
      #opts.on('-V', '--verbose')    { @options.verbose = true }  
     # opts.on('-q', '--quiet')      { @options.quiet = true }
      # TO DO - add additional options
            
      opts.parse!(@arguments) rescue return false
      
      process_options
      true      
    end

    def version
      puts "version: #{VERSION}"
    end
      
    def arguments_valid?
      if @args.length == 1
        true
      else
        false
      end
    end

    def user_valid?
      #check if the user is in github
      #check if there is limit length to username
    end

    def favorite_language(user)
      #getLanguage
      #return the language(s) most used
    end
end

app = App.new(ARGV)
app.run
=begin
puts "username"
userN = gets.chomp
test = JSON.parse '{"test": "ok"}'
if (user = Octokit.user userN)
  puts user.name
else
  puts "The user doesn't exist"
end

=end
