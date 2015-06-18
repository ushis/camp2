module ApiHelper

  def set_auth_header(token)
    request.headers['Authorization'] = "Bearer #{token}"
  end

  def json
    @json ||= JSON.parse(response.body).deep_symbolize_keys
  end

  def session_json(user)
    profile_json(user).merge!({
      access_token: user.access_token
    })
  end

  def profile_json(user)
    user_json(user).merge!({
      email: user.email,
      created_at: user.created_at.as_json,
      updated_at: user.updated_at.as_json
    })
  end

  def users_json(users)
    users.map { |user| user_json(user) }
  end

  def user_json(user)
    {
      id: user.id,
      name: user.name
    }
  end

  def shares_json(shares)
    shares.map { |share| share_json(share) }
  end

  def share_json(share)
    {
      id: share.id,
      user: user_json(share.user),
      created_at: share.created_at.as_json,
      updated_at: share.updated_at.as_json
    }
  end

  def acception_json(acception)
    {
      id: acception.id,
      topic: topic_json(acception.topic),
      created_at: acception.created_at.as_json,
      updated_at: acception.updated_at.as_json
    }
  end

  def invitations_json(invitations)
    invitations.map { |invitation| invitation_json(invitation) }
  end

  def invitation_json(invitation)
    {
      id: invitation.id,
      email: invitation.email,
      expired: invitation.expired?,
      created_at: invitation.created_at.as_json,
      updated_at: invitation.updated_at.as_json
    }
  end

  def topics_json(topics)
    topics.map { |topic| topic_json(topic) }
  end

  def topic_json(topic)
    {
      id: topic.id,
      name: topic.name,
      shares_count: topic.shares_count,
      invitations_count: topic.invitations_count,
      lists_count: topic.lists_count,
      created_at: topic.created_at.as_json,
      updated_at: topic.updated_at.as_json
    }
  end

  def lists_json(lists)
    lists.map { |list| list_json(list) }
  end

  def list_json(list)
    {
      id: list.id,
      name: list.name,
      items_count: list.items_count,
      created_at: list.created_at.as_json,
      updated_at: list.updated_at.as_json
    }
  end

  def items_json(items)
    items.map { |item| item_json(item) }
  end

  def item_json(item)
    {
      id: item.id,
      name: item.name,
      comments_count: item.comments_count,
      created_at: item.created_at.as_json,
      updated_at: item.updated_at.as_json
    }
  end

  def comments_json(comments)
    comments.map { |comment| comment_json(comment) }
  end

  def comment_json(comment)
    {
      id: comment.id,
      comment: comment.comment,
      user: comment.user.nil? ? nil : user_json(comment.user),
      created_at: comment.created_at.as_json,
      updated_at: comment.updated_at.as_json
    }
  end
end
