require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'
require 'rubygems'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'mkrf'


task :default => ["test:units"]

namespace :test do
  
  desc "Run basic tests"
  Rake::TestTask.new("units") { |t|
    t.pattern = 'test/unit/test_*.rb'
    t.verbose = true
    t.warning = true
  }
  
  desc "Run integration tests"
  Rake::TestTask.new("integration") { |t|
    t.pattern = 'test/integration/test_*.rb'
    t.verbose = true
    t.warning = true
  }
  
  namespace :samples do
    
    BASE_DIR = File.dirname(__FILE__) + '/test/sample_files'
    
    SAMPLE_DIRS = {
      :trivial => BASE_DIR + '/libtrivial/ext/',
      :syck => BASE_DIR + '/syck-0.55/ext/ruby/ext/syck/',
      :libxml => BASE_DIR + '/libxml-ruby-0.3.8/ext/xml/',
      :cpp_bang => BASE_DIR + '/cpp_bang/ext/'
    }
    
    task :default => [:all]
    
    desc "Try to compile all of the sample extensions"
    task :all => [:trivial, :libxml, :syck, :cpp_bang]
    
    desc "Try to compile a trivial extension"
    task :trivial do
      sh "cd #{SAMPLE_DIRS[:trivial]}; ruby extconf.rb; rake"
    end
    
    desc "Try to compile libxml"
    task :libxml do
      sh "cd #{SAMPLE_DIRS[:libxml]}; ruby extconf.rb; rake"
    end
    
    desc "Try to compile syck"
    task :syck do
      sh "cd #{SAMPLE_DIRS[:syck]}; ruby extconf.rb; rake"
    end
    
    desc "Try to compile cpp_bang"
    task :cpp_bang do
      sh "cd #{SAMPLE_DIRS[:cpp_bang]}; ruby mkrf_config.rb; rake"
    end

    desc "Clean up after sample tests"
    task :clobber do
      if ENV['PROJECT']
        if File.exist?(SAMPLE_DIRS[ENV['PROJECT'].to_sym] + "/Rakefile")
          sh "cd #{SAMPLE_DIRS[ENV['PROJECT'].to_sym]}; rake clobber; rm Rakefile"
        end
      else
        SAMPLE_DIRS.each_value do |test_dir|
          next unless File.exist?(test_dir + "/Rakefile")
          sh "cd #{test_dir}; rake clobber; rm Rakefile"
        end
      end
    end
    
  end  

end

#Rake::RDocTask.new do |rd|
#  rd.main = "README"
#  rd.rdoc_files.include("README", "lib/**/*.rb")
#end

