# frozen_string_literal: true

module SallaSerializers
  class EmailInterceptor
    ASSET_EXTENSIONS = %w[jpg jpeg png gif svg webp css js ico mp4 mp3 woff woff2 ttf otf].freeze

    def self.delivering_email(message)
      if message.html_part
        html = message.html_part.body.decoded
        sanitized_html = sanitize_links(html)

        message.html_part = Mail::Part.new do
          content_type 'text/html; charset=UTF-8'
          body sanitized_html
        end
      end

      if message.text_part
        text = message.text_part.body.decoded
        sanitized_text = sanitize_links(text)

        message.text_part = Mail::Part.new do
          content_type 'text/plain; charset=UTF-8'
          body sanitized_text
        end
      elsif message.body
        message.body = sanitize_links(message.body.decoded)
      end
    end

    def self.sanitize_links(content)
      return content unless content

      from_url = ENV["REWRITE_FROM_URL"]&.chomp("/")
      to_url = ENV["REWRITE_TO_URL"]&.chomp("/")

      return content unless from_url.present? && to_url.present?

      # Skip asset links (e.g. .jpg, .png, etc.)
      asset_pattern = /\.(#{ASSET_EXTENSIONS.join('|')})(\?.*)?(?=["'])/

      # Replace domain (but not for asset URLs)
      content = content.gsub(%r{#{Regexp.escape(from_url)}(?![^"'\s>]*#{asset_pattern})}) do |match|
        to_url
      end

      # Replace /t/ with /detail/ in links (but not for assets)
      content = content.gsub(%r{(?<!#{Regexp.escape(from_url)})/t/([^\s"'<>]+)(?![^"'\s>]*#{asset_pattern})}) do
        "/detail/#{$1}"
      end

      content
    end
  end
end