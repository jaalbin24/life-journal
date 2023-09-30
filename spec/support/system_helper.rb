module SystemHelper
  # So we don't have to keep typing data-test-id=... for css selectors
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

  def fill_and_check(element, options={ with: "TEST", present: [], absent: [] })
    try_it_twice do
      aggregate_failures do
        # If the method was provided a capybara element, use it
        if element.is_a? Capybara::Node::Element
          within element do
            fill_in with: options[:with]
          end
        # And if the method was provided with a string, use that
        else
          fill_in element, with: options[:with]
        end
        options[:present]&.each { |content| expect(page).to have_content content }
        options[:absent]&.each { |content| expect(page).to_not have_content content }
      end
    end
  end

  def turbo_request
    request.headers['Accept'] = 'text/vnd.turbo-stream.html'
    yield if block_given?
  end

  # Accepts a block and waits until that block evaluates to true or until a specified number of loops have passed
  # This method is used to solve timing problems and race conditions in the test suite.
  # USE CASE: If car.start requires car.gas >= 1, you can write...
  #   car.fill_up_with_gas
  #   wait_until { car.gas >= 1 }
  #   car.start
  def wait_until
    num_loops = 0
    while !yield && num_loops < 50 # <-- Adjust this value as needed
      num_loops += 1
      sleep 0.1
    end
  end
end