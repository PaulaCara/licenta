module Licenta
  module Notifications
    class << self

      def intercept
        ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
          begin

            event = ActiveSupport::Notifications::Event.new *args

            ev_trail = EventTrail::Event.new

            crtUser = User.current.clone
            ev_trail.user =crtUser
            ev_trail.transaction_id = event.transaction_id
            ev_trail.target_type = event.name
            ev_trail.result = result_status(event.payload[:status]) ? 'SUCCESS' : 'FAILED'
            ev_trail.action = "#{event.payload[:controller]}/#{event.payload[:action]}"
            ev_trail.method = event.payload[:method]
            ev_trail.app_name = Rails.application.class.parent_name
            ev_trail.payload = Marshal.dump(ev_trail)

            ev_trail.save if crtUser
              #perhapse throw an exception if user does not exist

          rescue => ex
            Rails.logger.error(ex)
          end
        end

        ActiveSupport::Notifications.subscribe "request.active_resource" do |*args|
          begin

            event = ActiveSupport::Notifications::Event.new *args

            if event.payload[:method] != :get && !event.payload[:request_uri].to_s.ends_with?('/event_trail')
              require 'uri'

              ev_trail = EventTrail::Event.new

              crtUser = User.current.clone
              crtUser.password = nil
              ev_trail.user =crtUser
              ev_trail.transaction_id = event.transaction_id
              ev_trail.target_type = event.name
              ev_trail.result = event.payload[:result] && result_status(event.payload[:result].code) ? 'SUCCESS' : 'FAILED'
              ev_trail.action = URI.split(event.payload[:request_uri])[5][1..-1]
              ev_trail.method = event.payload[:method]
              ev_trail.app_name = Rails.application.class.parent_name
              ev_trail.payload = Marshal.dump(ev_trail)

              ev_trail.save if crtUser
              #perhapse throw an exception if user does not exist

            end
          rescue => ex
            Rails.logger.error(ex)
          end
        end
      end

      private
      def result_status(status)
        http_status = status.to_i
        http_status == 200 || http_status == 201
      end
    end
  end
end