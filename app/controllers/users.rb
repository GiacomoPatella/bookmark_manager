require 'securerandom'

get '/users/new' do
  @user = User.new
  erb :"users/new", :layout => !request.xhr?
end

post '/users' do
  @user = User.new(:email => params[:email],
                   :password => params[:password],
                   :password_confirmation => params[:password_confirmation]
                  )
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/forgotten_pwd' do
  erb :"users/forgotten_pwd"
end


post '/users/forgotten_pwd' do
  user = User.first(:email => params[:email])
  if user
    user.send_password_recovery_email    
    flash[:notice] = "Your password has been sent to your email"
    redirect to('/')
  else
    flash[:notice] = "Your email was not found in the db"
    erb :"users/forgotten_pwd"  
  end
end


get '/users/reset_password/:token' do 
  @token = params[:token]
  erb :"users/reset_password"
end


post '/users/reset_password' do
  #reset their password and create
  token = params[:token]
  user = User.first(:password_token => token)
  user.update(:password => params[:password],
              :password_confirmation => params[:password_confirmation] )
  if user.save
    flash[:notice] = "Thank you, your password has been reset"
    redirect to '/sessions/new'
  else
    flash[:error] = "Password was incorrect, please enter again"
    erb :"users/reset_password"
  end

end
