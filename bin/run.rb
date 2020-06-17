require_relative '../config/environment'

controller_instance = Controller.new()
logged_in_user = controller_instance.greetings()

until !logged_in_user.nil?
  sleep 2
  system "clear"
  theUserChoice = controller.instancegreetings()
end

controller_instance.user = logged_in_user

controller_instance.main_menu
