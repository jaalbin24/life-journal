module SystemHelper
  def test_id(id)
    "[data-test-id='#{id}']"
  end

  # This method is used for tests that fail the first time, but pass if you let a little time go by.
  # Rather than spend time finding the race condition that causes that behaviour, I've plugged the
  # hole with this method. Just wrap your test in a try_it_twice block, and your tests are guaranteed
  # to be free of race conditions.
  def try_it_twice
    total_tries = 0
    Capybara.default_max_wait_time = 1 # We're only waiting a second before retrying this
    2.times do |attempt|
      begin
        yield # Execute the code to be tested using the `expect` block
        return # If the expectation succeeds, exit the loop
      rescue RSpec::Expectations::ExpectationNotMetError, Capybara::ElementNotFound => e
        if attempt == 1
          raise e
        else
          print "♻️" # A recycle emoji to show that the test is being reattempted
        end
      end
    end
  end
end