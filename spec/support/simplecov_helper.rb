# spec/support/simplecov_helper.rb

require "simplecov"
SimpleCov.start "rails" do
  add_filter "/bin/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/spec/"
end
