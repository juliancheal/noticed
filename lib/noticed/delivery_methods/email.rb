module Noticed
  module DeliveryMethods
    class Email < Base
      def deliver
        mailer.with(format).send(method.to_sym).send(delivery_time.to_sym)
      end

      private

      def mailer
        options.fetch(:mailer).constantize
      end

      def method
        options[:method] || notification.class.name.underscore
      end

      def delivery_time
        options[:deliver] || "deliver_later"
      end

      def format
        if (method = options[:format])
          notification.send(method)
        else
          notification.params.merge(
            recipient: recipient,
            record: record
          )
        end
      end
    end
  end
end
