# Use logger.warn to warn the team a potential malicious behavior of users

def create
  begin
    group.add_member(current_user)
    flash[:notice] = "Successfully joined #{scene.display_name}"
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "You are already a member of #{group.name}"
    logger.warn "A user tried to join a gropu twice. UI should not have allowed it."
  end

  redirect_to :back
end
