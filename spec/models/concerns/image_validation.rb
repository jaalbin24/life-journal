
RSpec.shared_examples ImageValidation do |model_class|
  let(:model) { create model_class.to_s.underscore.to_sym }
  let(:image_attributes) { model_class.validate_images }
  let(:png) { File.read Dir.glob(Rails.root.join('spec', 'images', 'png.png')).sample }
  let(:jpg) { File.read Dir.glob(Rails.root.join('spec', 'images', 'jpg.jpg')).sample }
  let(:jpeg) { File.read Dir.glob(Rails.root.join('spec', 'images', 'jpeg.jpeg')).sample }
  let(:actually_an_exe) { File.read Dir.glob(Rails.root.join('spec', 'images', 'actually_an_exe.png')).sample }

  it "includes the ImageValidation concern" do
    expect(model_class.ancestors).to include ImageValidation
  end

  it "has defined some images to be validated" do
    expect(image_attributes.blank?).to be false
  end

  it "will permit PNG files" do
    image_attributes.each do |i_attr|
      model.send(i_attr).attach(io: StringIO.new(png), filename: "png.png")
      expect(model.save).to be_truthy
    end
  end

  it "will permit JPG files" do
    image_attributes.each do |i_attr|
      model.send(i_attr).attach(io: StringIO.new(jpg), filename: "jpg.jpg")
      expect(model.save).to be_truthy
    end
  end

  it "will permit JPEG files" do
    image_attributes.each do |i_attr|
      model.send(i_attr).attach(io: StringIO.new(jpeg), filename: "jpeg.jpeg")
      expect(model.save).to be_truthy
    end
  end

  it "will not permit a file masquerading as an image" do
    image_attributes.each do |i_attr|
      model.send(i_attr).attach(io: StringIO.new(actually_an_exe), filename: "actually_an_exe.png")
      expect(model.save).to be_falsey
    end
  end
end
  