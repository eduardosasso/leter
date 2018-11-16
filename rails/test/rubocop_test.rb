class RubocopTest < ActiveSupport::TestCase
  require 'rubocop'
  # require 'bundler/audit/cli'

  # test 'no rubocop offenses' do
  #   cop = RuboCop::CLI.new
  #   args = [Rails.root.to_s]
  #   assert_equal 0, cop.run(args)
  # end

  # test 'no vulns in bundle' do
  #   `bundle audit update -q` # Update vulnerability database
  #   result = `bundle audit`  # Run the audit
  #   code = `echo $?`.squish  # Returns '0' if successful, otherwise '1'

  #   # Print the scan result as the error message if it fails.
  #   assert_equal '0', code, result

  #   # If successful, output the success message
  #   puts "\nMessage from bundler-audit: #{result}"
  # end
end
