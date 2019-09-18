# Introducing the Huawei_E3131 gem

    require 'huawei_e3131'


    notifier = ->() {puts 'incoming message'}
    e3 = HuaweiE3131.new(callback: notifier)

    e3.count
    #=> {"LocalUnread"=>"4", "LocalInbox"=>"9", "LocalOutbox"=>"0", "LocalDraft...

    e3.status
    #=> {"ConnectionStatus"=>"901", "SignalStrength"=>"44", "SignalIcon"=>"3", ...

    e3.notifications
    #=> {"UnreadMessage"=>"4", "SmsStorageFull"=>"0", "OnlineUpdateStatus"=>"10"}

    a = e3.messages.first['Content']
    #=> Hey, just testing, 1 2 3.

    e3.start
    #=> 'checking for new message every 3 seconds ...'

    # Receiving a new message
    #=> incoming message


## Resources

* huawei_e3131 https://rubygems.org/gems/huawei_e3131

huawei e3131 sms inbox dongle messages restclient api
