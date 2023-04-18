module TestIdHelper
  def test_id(id)
    find("[data-test-id='#{id}']")
  end
end