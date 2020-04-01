require_relative 'lib/stiction/version'

Gem::Specification.new do |spec|
  spec.name = 'stiction'
  spec.version = Stiction::VERSION
  spec.authors = [ 'Scott Tadman' ]
  spec.email = ['tadman@postageapp.com']

  spec.summary = %q{Detects blocking calls or blockages in an Async application}
  spec.description = %q{Probes for interruptions to Async::Reactor}
  spec.homepage = 'https://github.com/postageapp/stiction'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/postageapp/stiction'
  spec.metadata['changelog_uri'] = 'https://github.com/postageapp/stiction'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'async'
end
