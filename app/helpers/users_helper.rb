module UsersHelper
  def hide_token(token)
    if token.length < 4
      token[0..3]
    else
      token[0..3] +  "*" * token[4..-1].chars.count
    end
  end
end
