class ApplicationController < ActionController::Base
    before_action :set_current_user, :set_current_cart
    before_action :check_user_timeout

    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
        end

    private
  
    def set_current_user
      @current_user = current_user
    end

    #Create a new cart when a new session is started, or when
    #in our app a user clicks on empty cart, this triggers the setting of session[:cart_id] to nil which will be captured by this method
    #and a new cart will be created
    def set_current_cart
      if session[:cart_id] == nil
        @current_cart = Cart.create
        session[:cart_id] = @current_cart.id
      else
        cart = Cart.find_by(:id => session[:cart_id])
        @current_cart = cart
      end
      
    end

    def check_user_timeout
      if user_signed_in? && current_user.timeout_at.present? && current_user.timeout_at < Time.zone.now
        
        # Timeout scaduto
        # Esegui le azioni necessarie, ad esempio effettuare il logout dell'utente o reimpostare il timeout
        sign_out(current_user)
        flash[:alert] = "Timeout scaduto. Effettua nuovamente l'accesso."
        redirect_to new_user_session_path
      elsif user_signed_in?
        # Aggiorna il timeout ogni volta che l'utente compie un'azione
        current_user.update(timeout_at: Time.zone.now + 7.days)
      end
    end
end
