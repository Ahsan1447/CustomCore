# frozen_string_literal: true

BasicCategorySerializer.class_eval do
  attributes :only_admin_can_post,
            :emoji

  def emoji
    "https://community.salla.com/forum/#{object.id}.png"
  end

  def only_admin_can_post
    object.groups.exists?(name: "admins")
  end
end