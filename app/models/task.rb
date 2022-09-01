# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :slug, uniqueness: true
  validate :slug_not_changed

  before_create :set_slug

  private

    def set_slug
      itr = 1
      loop do
        title_slug = title.parameterize
        slug_candidate = itr > 1 ? "#{title_slug}-#{itr}" : title_slug
        break self.slug = slug_candidate unless Task.exists?(slug: slug_candidate)

        itr += 1
      end
    end

    # We make use of column_name_changed? attribute method provided by ActiveModel::Dirty module.
    # In every controller, we can use t() method without including any additional modules since AbstractController::Translation is already included in ActionController::Base.

    def slug_not_changed
      if slug_changed? && self.persisted?
        errors.add(:slug, t("task.slug.immutable"))
      end
    end
end
