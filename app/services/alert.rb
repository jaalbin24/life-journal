module Alert
  class Base
    def flash
      {
        title: @title,
        body: @body,
        style: @style
      }
    end

    def initialize(model: nil, title: nil, body: nil)
      @model = model
      @title = title || generate_title
      @body = body || generate_body
      @style = self.class.to_s.demodulize.downcase
    end

    def generate_title
      case @model.class.to_s.downcase.to_sym
      when :person
        "Saved"
      else
        "Success"
      end
    end

    def generate_body
      case @model.class.to_s.downcase.to_sym
      when :person
        "#{@model.summarize} was saved."
      else
        nil
      end
    end
  end

  class Success < Base

  end
  
  class Error < Base

  end

  class Info < Base

  end

  class Warning < Base

  end
end