require 'json'

playlist = Dir.glob('original/*.html')

# structure of html files for display purposes is such that every line is:
# 1.  display ACT number or PROLOGUE or similar
# 2.  display scene number
# 3.  stage direction
# 4.  new speaker name
# 5.  spoken line
# Additionally within the code each new speaker prompts a "speech number"
# for that act/scene "speech1" etc
# Also each spoken line is associated with a string which gives the
# act and scene and the line number within that scene
# e.g. Line 3.2.7 is the seventh spoken line of act 3 scene 2 and is part
# of speech2 spoken by PUCK in Midsummer Night's Dream
#
# for parsing purposes we need to be able to make sure all this information is stored or calculable
# for manipulation purposes we should perhaps not restrict the line numbers to actual numbers but to sortable versions thereof so insertions may be made at will
# e.g. 3.2.7a may be inserted between 3.2.7 and 3.2.8
# Note: the PROLOGUE from Romeo and Juliet and the INDUCTION from Henry IV pt 2 are treated differently

def parseplay(thisplay)
  if thisplay.to_s =~ %r{original/(.*?)\.html$}
    play_name = $1
  else
    raise 'failed to parse play name'
  end
  #all_lines = File.readlines('Romeo and Juliet Entire Play.html')
  all_lines = File.readlines(thisplay)
  all_lines.each do |thisline|
    if thisline =~ %r{(?m)</table>}
      break
    end
  end

  event_list = []
  speaker = "EMPTY"
  started = false
  event = 0
  current_speaker = nil
  current_speech = nil
  all_lines.each do |thisline|
    unless started
      if thisline =~ %r{(?m)</table>}
        started = true
        next
      else
        next
      end
    end
    if thisline =~ %r{(?m)<a\s+name="(\d+\.\d+\.\d+\w*)">\s*(.*?)\s*</a>}
      spoken_line_number = $1
      this_spoken_line = $2
      this_event = {}
      type = 'spoken_line'
      string = this_spoken_line
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => current_speaker,
        'speech' => current_speech,
        'spoken_line_number' => spoken_line_number,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<a\s+name="speech(\d+)">\s*<b>\s*(.*?)\s*</b>\s*</a>}
      speech_number = $1
      speaker = $2
      type = 'display_speaker'
      current_speaker = speaker
      current_speech = speech_number
      string = speaker
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => current_speaker,
        'speech' => current_speech,
        'spoken_line_number' => spoken_line_number,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<blockquote>}
      next
    elsif thisline =~ %r{(?m)</blockquote>}
      next
    elsif thisline =~ %r{(?m)^\s*$}
      next
    elsif thisline =~ %r{(?m)<p>\s*<i>\s*(.*?)\s*</i>\s*</p>}
      stage_instruction = $1
      type = 'stage_instruction'
      string = stage_instruction
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<i>\s*(.*?)\s*</i>}
      stage_instruction = $1
      type = 'stage_instruction'
      string = stage_instruction
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<h3>\s*(ACT\s+\w+)\s*</h3>}
      thisact = $1
      type = 'display_act'
      string = thisact
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<h3>\s*(SCENE\s+[^<]*?)\s*</h3>}
      thisscene = $1
      type = 'display_scene'
      string = thisscene
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<h3>\s*(PROLOGUE)\s*</h3>}
      thisscene = $1
      type = 'display_scene'
      string = thisscene
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    elsif thisline =~ %r{(?m)<h3>\s*(INDUCTION)\s*</h3>}
      thisscene = $1
      type = 'displayscene'
      string = thisscene
      this_event = {
        'type' => type,
        'string' => string,
        'speaker' => nil,
        'speech' => nil,
        'spoken_line_number' => nil,
      }
      event_list.push(this_event)
    else
      raise "failed to parse: #{thisline}"
    end
  end
  #event_list.each do |this_event|
  #  print_event(this_event)
  #end
  output_file = File.open("json/#{play_name}.json",'w')
  output_file.write(event_list.to_json)
  output_file.close
end

def print_event(this_event)
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
  print event_string
end

def print_spoken_line(this_event)
  spoken_line_number = this_event['spoken_line_number']
  string = this_event['string']
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
  return "<p>\n</p><h3>#{string}</h3>\n"
end

def print_scene(this_event)
  string = this_event['string']
  return "<p>\n</p><h3>#{string}</h3>\n"
end

playlist.each do |thisplay|
  parseplay(thisplay)
end
