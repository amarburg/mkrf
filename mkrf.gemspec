# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mkrf"
require "rake"

Gem::Specification.new do |s|
  s.name        = "mkrf"
  s.version     = Mkrf::VERSION
  s.authors     = ["Kevin Clark"]
  s.email       = ["kevin.clark@gmail.com"]
  s.homepage    = "http://glu.ttono.us"
  s.summary     = %q{Generate Rakefiles to Build C Extensions to Ruby}
  s.description = %q{This proposed replacement to mkmf generates Rakefiles to build C Extensions.}

  s.rubyforge_project = "mkrf"

  s.has_rdoc = true
  s.rdoc_options << '--main' << 'README' << '--title' << 'mkrf'
#  s.autorequire = 'mkrf'

  s.extra_rdoc_files = [ "README", "MIT-LICENSE", "CHANGELOG" ]

  s.files = [ "Rakefile", "README", "CHANGELOG", "MIT-LICENSE" ]
  s.files = s.files + Dir.glob( "lib/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
  s.files = s.files + Dir.glob( "test/**/*" ).delete_if { |item| item.include?( "\.svn" ) }

#  s.files         = `git ls-files`.split("\n")
#  s.extensions    = FileList["ext/**/mkrf_conf.rb"]
#  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
#  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rake"

end
