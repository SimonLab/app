require 'optparse'
require 'octokit'

class Application
  VERSION = '0.0.1'

  def initialize(args)
    @arguments = args
  end
  
  def run
    if valid_arguments?
      parse_option
    else
      raise "wrong arguments, see -h for help"
    end
  end

protected

  def valid_arguments?
    arg_option = @arguments[0]
    case @arguments.length
    when 1
      #is it an option?
      /^-/ =~ arg_option
    when 2
      #is it the option -u or --user
      /(^-u$|^--user$)/ =~ arg_option
    else
      false
    end  
  end

  def parse_option
    opts = OptionParser.new
    opts.banner = "List of valid commads:"
    opts.on("-h", "--help") do
      puts opts
      exit 0
    end
    opts.on("-v", "--version") do
      puts VERSION
      exit 0
    end
  
    opts.on("-u", "--user USER") do |user|
      find_user(user)
    end
     opts.parse!(ARGV)  
  end

  def find_user(user)
    begin
      users = Octokit.user(user)
      p users
    rescue Octokit::NotFound => e
      p e
      exit 1
    end
  end

  def user_exist?

  end
  
end

begin
app = Application.new(ARGV)
app.run
rescue => e
  p e
end
