# 
#  Copyright (c) 2005 Zed A. Shaw with portions by Kevin Clark
#  You can redistribute it and/or modify it under the same terms as Ruby.
# 

module Mkrf
  @all_libs = []

  def self.all_libs
    @all_libs
  end

  def self.all_libs=(a)
    @all_libs = a
  end
end


def rake(rakedir, args = nil)
  Dir.chdir(rakedir) do
    if args
      sh "rake #{args}"
    else
      sh 'rake'
    end
  end
end


def mkrf_conf(dir)
  Dir.chdir(dir) do ruby "mkrf_conf.rb" end
end


def setup_tests
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
  end
end


def setup_clean otherfiles
  files = ['build/*', '**/*.o', '**/*.so', '**/*.a', 'lib/*-*', '**/*.log'] + otherfiles
  CLEAN.include(files)
end


def setup_rdoc files
  Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options << '--line-numbers'
    rdoc.rdoc_files.add(files)
  end
end


def setup_extension(dir, extension)
  ext_dir = "ext/#{dir}"
  ext_so = "#{ext_dir}/#{extension}.#{RbConfig::CONFIG['DLEXT']}"

  ext_files = FileList[
    "#{ext_dir}/**/*.c*",
    "#{ext_dir}/**/*.h*",
    "#{ext_dir}/mkrf_conf.rb",
    "#{ext_dir}/Rakefile",
    "lib"
  ] 

  task "lib" do
    directory "lib"
  end

  Mkrf::all_libs << extension.to_sym

  desc "Builds just the #{extension} extension"
  task extension.to_sym => ["#{ext_dir}/Rakefile", ext_so ]

  file "#{ext_dir}/Rakefile" => ["#{ext_dir}/mkrf_conf.rb"] do
    mkrf_conf "#{ext_dir}"
  end

  file ext_so => ext_files do
    rake "#{ext_dir}"
    cp ext_so, "lib"
  end

  namespace extension.to_sym do

    desc "Run \"rake clean\" in #{ext_dir}"
    task :clean do
      rake ext_dir, 'clean'
    end

    desc "Run \"rake clobber\" in #{ext_dir}"
    task :clobber do
      rake ext_dir, 'clobber'
    end
  end


end


def base_gem_spec(pkg_name, pkg_version)
  rm_rf "test/coverage"

  pkg_version = pkg_version
  pkg_name    = pkg_name
  pkg_file_name = "#{pkg_name}-#{pkg_version}"
  Gem::Specification.new do |s|
    s.name = pkg_name
    s.version = pkg_version
    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.extra_rdoc_files = [ "README" ]

    s.files = %w(Rakefile) +
      Dir.glob("{bin,doc/rdoc,ext,examples}/**/*") + 
      Dir.glob("tools/*.rb") +
      Dir.glob(RUBY_PLATFORM !~ /mswin/ ? "lib/**/*.rb" : "lib/**/*")

    s.require_path = "lib"
    s.bindir = "bin"
  end
end

def setup_gem(pkg_name, pkg_version)
  spec = base_gem_spec(pkg_name, pkg_version)
  yield spec if block_given?


  Rake::GemPackageTask.new(spec) do |p|
    p.gem_spec = spec
    p.need_tar = true if RUBY_PLATFORM !~ /mswin/
  end
end

def sub_project(project, *targets)
  targets.each do |target|
    Dir.chdir "projects/#{project}" do
      sh %{rake --trace #{target.to_s} }
    end
  end
end

# Conditional require rcov/rcovtask if present
begin
  require 'rcov/rcovtask'
  
  Rcov::RcovTask.new do |t|
    t.test_files = FileList['test/test*.rb']
    t.rcov_opts << "-x /usr"
    t.output_dir = "test/coverage"
  end
rescue Object
end
