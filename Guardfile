guard 'rspec', :version => 2, cmd: "bundle exec rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end
# guard 'cucumber' do
#   watch(%r{^features/.+\.feature$})
#   watch(%r{^features/support/.+$})          { 'features' }
#   watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
# end

# guard 'livereload' do
#   watch(%r{app/views/.+\.(erb|haml|slim)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{public/.+\.(css|js|html)})
#   watch(%r{config/locales/.+\.yml})
#   # Rails Assets Pipeline
#   watch(%r{(app|vendor)/assets/\w+/(.+\.(css|js|html)).*})  { |m| "/assets/#{m[2]}" }
# end

# guard 'bundler' do
#   watch('Gemfile')
# end

# guard 'puma' do
#   watch('Gemfile.lock')
#   watch(%r{^config|lib/.*})
# end

# # Possible options are :port, :executable, and :pidfile
# guard 'redis'

# ### Guard::Resque
# #  available options:
# #  - :task (defaults to 'resque:work' if :count is 1; 'resque:workers', otherwise)
# #  - :verbose / :vverbose (set them to anything but false to activate their respective modes)
# #  - :trace
# #  - :queue (defaults to "*")
# #  - :count (defaults to 1)
# #  - :environment (corresponds to RAILS_ENV for the Resque worker)
# guard 'resque', :environment => 'development' do
#   watch(%r{^app/(.+)\.rb$})
#   watch(%r{^lib/(.+)\.rb$})
# end