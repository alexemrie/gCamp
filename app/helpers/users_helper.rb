module UsersHelper
  def hide_token(token)
    if token
      number_of_asterisks = '*'* (token.length - 4)
      token[0..3] + number_of_asterisks
    end
  end
end
