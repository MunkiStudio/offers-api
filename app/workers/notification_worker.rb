
class NotificationWorker
	include Sidekiq::Worker

	def perform(object_id,type)
		target 	= nil
		sender 	= nil
		obj		= nil
		recipient=nil
		verb	= nil
		case type
		when 'comment'
			obj     = Comment.find(object_id)
			target	= obj.offer
			sender	= obj.user
			recipient = target.user
			verb	= 'NEW_COMMENT'
		when 'group'
			obj = Membership.find(object_id)
			sender = User.find(obj.group.user_id)
	  		recipient = User.find(obj.user_id)
	  		target = obj.group 
	  		verb = 'ADDED_TO_GROUP'
		end
		
		begin
			Notification.create!(:sender => sender, :recipient => recipient,
				:target => target, :object => obj,:verb => verb)	
			logger.info "Creada nueva notificacion for #{verb} sender:#{sender} recipient:#{recipient} target:#{target} object:#{obj}"
   		rescue
   			logger.error "No se pudo crear la notificacion #{$!}"
   		end
	end
end
