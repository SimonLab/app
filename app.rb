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
      favorite_language(user)
    end
     opts.parse!(ARGV)  
  end

  def favorite_language(user)
    begin
      username = get_username(user)
      list = list_languages(username)
      p list.max
    rescue  => e
      p e
      exit 1
    end
  end

  def name_repositories(user)
    repositories = Octokit.repositories(user)
    names_repo = []
    repositories.each do |repo|
      names_repo << repo.name
    end
    raise "No repositories" if names_repo.empty?
    names_repo
  end
  
  
  def get_username(user)
    begin
      user = Octokit.user(user)
    rescue Octokit::NotFound => e
      puts e.message
    end
    user.login
  end

  def get_languages(user, repository)
    languages = Octokit.languages("#{user}/#{repository}")
  end

  def list_languages(user)
    repos = name_repositories(user)
    list_lang = {}
    repos.each do |repo|
      languages = get_languages(user,repo)
      languages.each do |lang, size|
        if (list_lang.has_key? lang)
          list_lang[lang] += size
        else
          list_lang[lang] = size
        end
      end
    end
    list_lang
  end
end

begin
app = Application.new(ARGV)
app.run
rescue => e
  p e
end
