module ImageValidation
  extend ActiveSupport::Concern

  private

  def file_is_img(file)
    if send(file).attached? && !send(file).content_type.in?(%w(image/jpeg image/png image/jpg))
      errors.add(file, "That file type is not allowed. Files must be JPEG, JPG, or PNG.")
    end
  end
end