class AuthenticationFilter
  @logger = RAILS_DEFAULT_LOGGER

  def self.filter(controller)
    unless controller.session[:user_id]
      receipt = controller.session[:casfilterreceipt]
      if receipt && receipt.user_name
        guid = receipt.attributes[:ssoGuid]
        user = User.find_by_globallyUniqueID(guid)
        if user.nil?
          @logger.info("User not found for ssoGuid: " + guid)
          #check for existing, pre-gcx users.
          user = User.find_by_username(receipt.user_name)
          if user.nil?
            @logger.info("User not found for user_name: " + receipt.user_name + "; creating new user")
            user = User.create(:username => receipt.user_name,
              :globallyUniqueID => guid,
              :createdOn => Time.now,
              :password => User.encrypt(Time.now.to_s))
          else
            @logger.info("Trusting user and associating guid " + guid + " with user " + user.username)
            #todo: prompt for old password (or verify email?)
            #for now, trust user and associate sso account with ssm
            user.globallyUniqueID = guid;
          end
        else #found user by guid
          if user.username != receipt.user_name
            @logger.info("Sso username different; changing username from " + user.username + " to " + receipt.user_name)
            user.username = receipt.user_name
          end
        end
        #stamp user login
        user.lastLogin = Time.now
        #set password if it is blank
        if user.password.blank?
          user.password = User.encrypt(Time.now.to_s)
        end
        user.save!
        person = user.person
        if person.nil?
          person = Person.create(:user => user,
            :firstName => receipt.attributes[:firstName],
            :lastName => receipt.attributes[:lastName],
            :dateCreated => Time.now,
            :dateChanged => Time.now,
            :createdBy => controller.application_name,
            :changedBy => controller.application_name)
          if receipt.attributes[:emplid] && !receipt.attributes[:emplid].empty?
            person.accountNo = receipt.attributes[:emplid]
            person.staff = Staff.find_by_accountNo(receipt.attributes[:emplid])
            person.isStaff = true
            if staff = Staff.find_by_accountNo(person.accountNo)
              staff.person = person
              staff.save!
            end
          end
          person.save!
        end
      
        controller.session[:user_id] = user.id
      else
        # Session probably expired, send them back to cas
        controller.send(:redirect_to, "#{CAS::Filter.login_url}?service=http://#{ActionMailer::Base.default_url_options[:host]}")
        return false
      end
      return true
    end
  end
end
