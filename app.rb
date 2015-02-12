require 'optparse'
require 'octokit'

class Application
  VERSION = '0.0.1'

  def initialize(args)
    @arguments = args
  end
  
  def run
    valid_arguments? ? parse_option : raise("Wrong arguments")
  end

protected

  def valid_arguments?
    first_arg = @arguments[0]
    case @arguments.length
    when 1
      #is it an option?
      /^-/ =~ first_arg
    when 2
      #is it the option -u or --user
      /(^-u$|^--user$)/ =~ first_arg
    else
      false
    end  
  end

  def parse_option
    opts = OptionParser.new
    opts.banner = "List of options:"
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
      list_lang = list_languages(username)
      #better display 
      p list_lang.max
    rescue  => e
      p e.message
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
      exit 1
    end
    user.login
  end

  def get_languages(user, repository)
    #if no languages it returns {}
    languages = Octokit.languages("#{user}/#{repository}")
  end

  def list_languages(user)
    repos = name_repositories(user)
    list_lang = {}
    #use thread for the api request?
    repos.each do |repo|
      languages = get_languages(user,repo)
      languages.each do |lang, size|
        list_lang.has_key?(lang) ? (list_lang[lang] += size) : (list_lang[lang] = size)
      end
    end
    raise "No languages find" if list_lang.empty?
    list_lang
  end
end


app = Application.new(ARGV)
app.run

