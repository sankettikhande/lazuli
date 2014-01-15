module Admin::ChannelsHelper
  def channel_actions channel
    link_to(link_raw_field('fa fa-edit'), edit_admin_channel_path(channel), :rel=>'tooltip', :title => 'Edit Channel', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << link_to(link_raw_field('fa fa-ban'), admin_channel_path(channel), :rel=>'tooltip', :title => 'Delete Channel', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
  end
end
