module PubliclyIdentifiable
    extend ActiveSupport::Concern

    included do
        validates :public_id, presence: true
        before_validation :generate_public_id, on: :create 
        def to_param
            public_id
        end
    end
    private

    def generate_public_id
        loop do
            self.public_id = "#{self.class.name.demodulize.downcase}_#{SecureRandom.alphanumeric(16)}"
            return public_id if self.class.where(public_id: public_id).count == 0
        end
    end
end