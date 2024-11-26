class Request < ApplicationRecord
  belongs_to :individual_ticket
  belongs_to :owner, class_name: "User"

  enum status: { pending: 0, approved: 1, rejected: 2 } 
  
  def localized_status
    I18n.t("enums.request.status.#{status}")
  end
  
end
