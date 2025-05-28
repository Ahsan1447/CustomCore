# frozen_string_literal: true

module SallaSerializers
  module EmailTemplatePatch
    def find_template(name, opts = nil)
      if name == "user_notifications/digest"
        path = File.expand_path("../overrides/email_templates/digest.html.erb", __FILE__)
        return Tilt::ERBTemplate.new(path)
      end

      super
    end
  end
end