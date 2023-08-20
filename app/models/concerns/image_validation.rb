module ImageValidation
  extend ActiveSupport::Concern
  class_methods do
    def validate_images(*args)
      @images ||= []
      args.each {|arg| @images.append arg.to_sym}
      @images
    end
  end

  included do
    validate :files_are_images
  end

  private

  def files_are_images
    self.class.validate_images.each do |attribute|
      if send(attribute).attached? && !send(attribute).content_type.in?(%w(image/png image/jpg image/jpeg))
        errors.add(attribute, "Must be a JPG, JPEG, or PNG file")
      end
    end
  end
end