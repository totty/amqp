$:.unshift File.dirname(__FILE__) + '/../../lib'
require 'mq'

EM.run do

  count = 0

  MQ.basic_return do |e|
    print "Unroutable message: #{e.inspect}\n"
    EM.stop_event_loop if (count += 1) == 2
  end

  MQ.queue('foo').bind('foo').subscribe do |a,b|
    p "Got #{a} and #{b}"
  end

  MQ.direct('foo').publish('one', :immediate => true)
  MQ.direct('foo').publish('two', :mandatory => true)

  EM.add_timer(1) do
    MQ.direct('bar').publish('three', :immediate => true)
    MQ.direct('bar').publish('three', :mandatory => true)
  end

end
