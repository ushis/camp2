class ProfileSerializer < UserSerializer
  root :user

  attributes :email, :created_at, :updated_at
end
