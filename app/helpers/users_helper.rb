module UsersHelper


  
  def options_for_association_conditions(association)
    if association.name == :role
      ['roles.id != ?', Role.find_by_name('Admin').id] unless current_user.admin?
    else
      super
    end
  end
end
