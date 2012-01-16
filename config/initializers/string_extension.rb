class String
  def starts_or_ends_with?(substr)
    starts_with?(substr) || ends_with?(substr)
  end
end
