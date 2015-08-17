module Slugged
  def self.included base
    base.validates :slug, presence: true, uniqueness: true, format: /\A[a-z0-9\-_]+\z/
    base.before_validation :derive_slug
  end

  def derive_slug
    return true if slug.present?

    parts = Array slug_parts
    derived_slug = parts.shift.to_s.parameterize
    next_number = 2

    while self.class.where(slug: derived_slug).any?
      if next_part = parts.shift
        derived_slug += "-" + next_part.to_s.parameterize
      else
        derived_slug += "-#{next_number}"
        next_number += 1
      end
    end

    self.slug = derived_slug
  end

  def slug_parts
    [title]
  rescue NameError
    raise "Slugged concern defaults to `title` attr. Define `slug_parts` to change."
  end
end
