module Admin::ChannelsHelper
  def channel_actions channel
    "<a href='/admin/channels/#{channel.id}/edit' rel='tooltip' title='Edit User' data-no-turbolink='true'><i class='fa fa-3x fa-edit'></i></a><a href='/admin/channels/#{channel.id}' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete User'><i class='fa fa-3x fa-ban pull-right'></i></a>".html_safe
  end
end
