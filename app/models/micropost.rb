class Micropost < ApplicationRecord
  default_scope ->{order created_at: :desc}
  scope :recent_posts, ->{order created_at: :desc}

  belongs_to :user

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost.content.max_length}
  validates :image,
            content_type: {in: Settings.micropost.content_type.type,
                           message: I18n.t(".content_message")},
            size: {less_than: Settings.micropost.images_size.less.megabytes,
                   message: I18n.t(".size_message")}

  def display_image
    image.variant resize_to_limit: Settings.micropost.images.max_size
  end
end
