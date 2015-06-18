class SessionSerializer < ProfileSerializer
  root :user

  attributes :access_token
end
