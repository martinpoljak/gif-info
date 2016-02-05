# encoding: utf-8

Gem::Specification.new do |s|
    
  # base meta
  s.name = 'gif-info'
  s.version = "0.1.1"
  s.date = '2016-02-05'
  s.license = "MIT"
  s.summary = "Pure Ruby analyzer of the GIF image format. Performs complete analysis of internal GIF block structure and streams it as an objects stream with metainformations of each block. Also can interpret internal structure by providing the simple object-like interface to base image file informations. Works above seekable IO streams, so allows processing of the big files too. Doesn't perform LZW decompressing, returns raw data for both color tables and images."

  # author
  s.author = "Martin Poljak"
  s.email = 'martin@poljak.cz'
  s.homepage = "https://github.com/martinkozak/gif-info"
  
  # files & paths
  s.bindir = 'bin'
  s.require_paths = ["lib"]
  s.executables = ["gif-dump", "gif-info"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "CHANGES.txt"
  ]
  s.files = Dir[
    "lib/**/*",
    "bin/*",
    "LICENSE.txt",
    "README.md",
    "CHANGES.txt"
  ]
 
  # dependencies
  s.add_runtime_dependency(%q<struct-fx>, [">= 0.1.1"])
  s.add_runtime_dependency(%q<abstract>, [">= 1.0.0"])
  s.add_runtime_dependency(%q<frozen-objects>, [">= 0.2.0"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  s.add_development_dependency(%q<riot>, [">= 0.12.1"])

end