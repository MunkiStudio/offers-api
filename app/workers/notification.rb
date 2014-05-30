
class NotificationWorker
	include Sidekiq::Worker

	def perform(sender,receive,where,verb)
		notification = Notification.new(
			verb:verb,
			subject:sender
			user:receive
			where:where
		)
		begin
			notification.save
			logger.info "Creada nueva notificacion for #{verb} user:#{user} sender:#{sender} where:#{where}"
   		rescue
   			logger.error "No se pudo crear la notificacion #{$!}"
   		end
	end
end
