RSpec::Matchers.define :have_focus_on do |selector|
  match do |page|
    page.execute_script("return document.activeElement.matches('#{selector}')")
  end
end
