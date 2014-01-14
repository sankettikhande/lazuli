module Admin::ChannelsHelper
  def channel_actions channel
    "<a class='btn-trans' href='/admin/channels/#{channel.id}/edit' rel='tooltip' title='Edit Channel' data-no-turbolink='true'><i class='fa fa-edit'></i></a><a class='btn-trans' href='/admin/channels/#{channel.id}' data-method='delete' data-confirm='Are you sure you want to delete?' rel='tooltip' title='Delete Channel'><i class='fa fa-ban'></i></a>".html_safe
  end
end
