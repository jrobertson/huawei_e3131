#!/usr/bin/env ruby

# file: huawei_e3131.rb

require 'rexle'
require 'rest_client'
require 'rexle-builder'



# HOWTO: Switching the Huawei E3131  to network controller mode
#
# 1. Plug in the Huawei E3131 dongle
# 2. `sudo apt-get install sg3-utils`
# 3. `sudo /usr/bin/sg_raw /dev/sr0 11 06 20 00 00 00 00 00 01 00`
#
# 4. edit /etc/network/interfaces and add the following:
#
#     allow-hotplug eth1
#     iface eth1 inet dhcp
#
# 5. observe IP address 192.168.1.1 is now reachable from eth1
#
# credit: [Huawei E3131 on Wheezy](https://www.raspberrypi.org/forums/viewtopic.php?p=210958)

class HuaweiE3131

  def initialize(host='192.168.1.1', callback: nil, autostart: false)
    
    @host, @callback = host, callback
    
    start if autostart
    
  end

  def check_notifications()

    query 'monitoring/check-notifications'

  end

  alias notifications check_notifications

  def connection_status()

    query 'monitoring/status'

  end

  alias status connection_status

  def messages()

    options = {PageIndex: 1, ReadCount: 20, BoxType: 1, SortType: 0, 
               Ascending: 0, UnreadPreferred: 0}

    a = RexleBuilder.new(options, debug: false).to_a
    a[0] = 'request'
    xml = Rexle.new(a).xml(declaration: false)    
    
    response = RestClient.post "http://#{@host}/api/sms/sms-list", xml.to_s, 
        :content_type => "text/xml"        

    Rexle.new(response.body).root.xpath('Messages/Message').map do |message|

      message.xpath('./*').inject({}) do |r,x|
        x.text ? r.merge(x.name => x.text.unescape) : r
      end

    end

  end
  
  # read an SMS message
  #
  def read(idx=1)  
    messages[idx.to_i-1]
  end

  def sms_count()

    query 'sms/sms-count'

  end

  alias count sms_count

  # continuously check for new messages
  #
  def start()
    
    unread = notifications()['UnreadMessage'].to_i

    @thread = Thread.new do
      loop do

        unread_messages = notifications()['UnreadMessage'].to_i

        if unread_messages > unread then

          @callback.call if @callback
          unread = unread_messages

        end

        sleep 3

      end
    end

    'checking for new message every 3 seconds ...'

  end

  def stop()

    @thread.stop
    @thread.kill

    'message checker stopped'
  end

  private

  # returns a Hash object from the flat XML records returned from the response
  #
  def query(s)

    response = RestClient.get "http://#{@host}/api/" + s

    Rexle.new(response.body).root.xpath('./*').inject({}) do |r,x|
      x.text ? r.merge(x.name => x.text.unescape) : r
    end

  end

end
