require 'json'

thisplay = ARGV[0]

playlist = Dir.glob('json/*.json')

def list_speeches(thisplay)
  if thisplay.to_s =~ %r{json/(.*?)\.json$}
    play_name = $1
    print play_name
  else
    raise 'failed to parse play name'
  end
  thisplayhash = File.read(thisplay)
  event_list = JSON.parse(thisplayhash)
  firstline_hash = {}
  event_list.each do |this_event|
    if this_event['full_speech_number']
    #print_event(this_event, output_file)
      full_speech_number = this_event['full_speech_number']
      this_line = this_event['string']
      this_speaker = this_event['speaker']
      if firstline_hash[full_speech_number] == nil
        firstline_hash[full_speech_number] = this_line
        print "#{this_speaker}: #{this_line}  (#{full_speech_number})\n"
      end
      #print "full_speech_number #{full_speech_number}\n"
    end
  end
end

playlist.each do |thisplay|
  list_speeches(thisplay)
end
