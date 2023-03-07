require 'json'

thisplay = ARGV[0]

playlist = Dir.glob('json/*.json')

def printplay(thisplay)
  if thisplay.to_s =~ %r{json/(.*?)\.json$}
    play_name = $1
    #print play_name
  else
    raise 'failed to parse play name'
  end
  thisplayhash = File.read(thisplay)
  event_list = JSON.parse(thisplayhash)
  output_file = File.open("cleaned/#{play_name}.html",'w')
  if play_name =~ %r{^(.*?)\s+Entire\s+Play$}
    play_name_clean = $1
    title_string = "<h1>#{play_name_clean}</h1>\n"
    output_file.write(title_string)
  else
    raise 'could not parse play name'
  end
  #output_file.write(event_list.to_json)
  event_list.each do |this_event|
    print_event(this_event, output_file)
  end
  output_file.close
end

def print_event(this_event,output_file)
  case this_event['type']
  when 'spoken_line'
    event_string = print_spoken_line(this_event)
  when 'display_speaker'
    event_string = print_new_speaker(this_event)
  when 'stage_instruction'
    event_string = print_stage_instruction(this_event)
  when 'display_act'
    event_string = print_act(this_event)
  when 'display_scene'
    event_string = print_scene(this_event)
  end
  output_file.write(event_string)
end

def print_spoken_line(this_event)
  spoken_line_number = this_event['spoken_line_number']
  string = this_event['string']
  # put stage directions in spoken lines in italics
  string = string.to_s.gsub(/\[/,'<i>[').gsub(/\]/,']</i>')
  return "<a name=\"#{spoken_line_number}\">#{string}</a><br>\n"
end

def print_new_speaker(this_event)
  speech_number = this_event['speech']
  string = this_event['string']
  return "</blockquote>\n\n<a name=\"speech#{speech_number}\"><b>#{string}</b></a>\n<blockquote>\n"
end

def print_stage_instruction(this_event)
  string = this_event['string']
  return "<p><i>#{string}</i></p>\n"
end

def print_act(this_event)
  string = this_event['string']
  return "</blockquote>\s<p>\n</p><h3>#{string}</h3>\n"
end

def print_scene(this_event)
  string = this_event['string']
  return "</blockquote>\s<p>\n</p><h3>#{string}</h3>\n"
end

playlist.each do |thisplay|
  printplay(thisplay)
end
