class CustomDeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    @token = token
    @resource = record

    # Manually set the full URL for the reset password
    @reset_url = "http://127.0.0.1:5173/reset-password?token=#{@token}"  # Replace with your actual frontend URL

    opts[:subject] = "Reset Password Instructions"
    mail(to: @resource.email, subject: opts[:subject]) do |format|
      format.text { render plain: "Someone has requested a link to change your password. You can do this through the link below: #{@reset_url}" }
      format.html { render html: "<p>Someone has requested a link to change your password. You can do this through the link below: <a href='#{@reset_url}'>Change my password</a></p>".html_safe }
    end
  end

  def confirmation_instructions(record, token, opts = {})
    @token = token
    @resource = record

    # Construct your frontend URL for account confirmation
    @confirmation_url = "http://127.0.0.1:5173/confirm-account?token=#{@token}" # Replace with your frontend URL

    opts[:subject] = "Confirm Your Account"
    mail(to: @resource.email, subject: opts[:subject]) do |format|
      format.text { render plain: "Please confirm your account through the link: #{@confirmation_url}" }
      format.html { render html: "<p>Please confirm your account through the link: <a href='#{@confirmation_url}'>Confirm My Account</a></p>".html_safe }
    end
  end
end
