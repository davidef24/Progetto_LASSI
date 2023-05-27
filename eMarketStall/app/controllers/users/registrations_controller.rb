# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]


    def edit_profile
      @user = current_user
    end

    def update_profile
      @user = current_user

      if @user.update(user_params)
        redirect_to root_path, notice: 'Profilo aggiornato con successo.'
      else
        render :edit_profile
      end
    end

    def user_params
      params.require(:user).permit(:città, :num_telefono, :roles_mask, :cap_residenza, :via_residenza)
    end

    def show
      @user = current_user
    end
  
    def create
      super do |resource|
        roles_mask = roles_mask_from_params
        resource.roles_mask = roles_mask
        resource.save
      end
    end
    
    private
    
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :nome, :cognome, :roles_mask)
    end
    
    def roles_mask_from_params
      roles_mask = 0
      roles_mask |= 1 if params[:user][:roles_mask].include?('1')
      roles_mask |= 2 if params[:user][:roles_mask].include?('2')
      # Aggiungi ulteriori condizioni per gli altri ruoli, se necessario
    
      roles_mask
    end
  
    def update_resource(resource, params)
      if resource.provider == 'google_oauth2'
        params.delete('current_password')
        resource.password = params['password']
        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end
  

  # GET /resource/sign_up
  # def new
  #   super
  # end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
