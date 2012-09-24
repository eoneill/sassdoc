require 'date'

Gem::Specification.new do |gemspec|
  # Release Specific Information
  gemspec.version = '0.0.1'
  gemspec.date = Date.today

  # Gem Details
  gemspec.name = 'sassdoc'
  gemspec.authors = ["Eugene ONeill", "LinkedIn"]
  gemspec.summary = %q{code documentation for Sass}
  gemspec.description = %q{Documentation generator for Sass source code}
  gemspec.email = "oneill.eugene@gmail.com"
  gemspec.homepage = "https://github.com/eoneill/sassdoc/"
  gemspec.license = "Apache License (2.0)"
  gemspec.executables = %w(sassdoc)
  
  # Gem Files
  gemspec.files = %w(LICENSE README.md CHANGELOG.md)
  gemspec.files += Dir.glob("bin/**/*")
  gemspec.files += Dir.glob("lib/**/*")
  
  # Gem Bookkeeping
  gemspec.rubygems_version = %q{1.3.6}
  gemspec.add_dependency('json')
end
