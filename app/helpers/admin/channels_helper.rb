module Admin::ChannelsHelper
	def destroy_action_channel channel
		if can? :destroy, channel
		  link_to(link_raw_field('fa fa-ban'), admin_channel_path(channel), :rel=>'tooltip', :title => 'Delete Channel', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
		else
			link_to(link_raw_field('fa fa-ban'), "#", :disabled => true, :rel=>'tooltip', :title => 'Delete Channel', :class=>'btn-trans', :data =>{'no-turbolink'=>'true', :method => 'delete', :confirm => 'Are you sure you want to delete?'})
		end
	end
  def channel_actions channel
    link_to(link_raw_field('fa fa-edit'), edit_admin_channel_path(channel), :rel=>'tooltip', :title => 'Edit Channel', :class=>'btn-trans', :data =>{'no-turbolink'=>'true'}) << destroy_action_channel(channel)
  end
end
