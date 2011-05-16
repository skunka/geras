module UsersHelper

  def options_for_association_conditions(association)
    if association.name == :role_id
      ['roles.id != ?', Role.find_by_id(:role_id).name]
    else
      super
    end
  end
end
