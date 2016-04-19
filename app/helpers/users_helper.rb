module UsersHelper
  def gravatar_for(user, options = { size: 80 })
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_ur1 = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_ur1, alt: user.name, class: "gravatar")
  end
end