# == Schema Information
#
# Table name: survey_invitations
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  phone           :string
#  token           :string
#  used_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_survey_invitations_on_email            (email) UNIQUE
#  index_survey_invitations_on_organization_id  (organization_id)
#  index_survey_invitations_on_phone            (phone) UNIQUE
#  index_survey_invitations_on_token            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class SurveyInvitation < ApplicationRecord
  nilify_blanks
  before_validation :standardize_phone

  validates :organization, presence: true
  validates :name, presence: true
  validates :phone, uniqueness: { allow_nil: true }, numericality: true, length: {is: 10}
  validates :email, uniqueness: { allow_nil: true, case_sensitive: false }
  validate :has_contact_method

  has_secure_token :token

  belongs_to :organization

  scope :unused, -> { where("used_at IS NULL") }

private

  def standardize_phone
    return unless phone
    self.phone = phone.gsub(/^+1/, '').gsub(/[^0-9]/, '')
  end

  def has_contact_method
    errors.add(:base, "Either email or phone is required") if email.blank? && phone.blank?
  end

end
