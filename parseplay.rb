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
  #all_lines = File.readlines('Romeo and Juliet Entire Play.html')
  all_lines = File.readlines(thisplay)
  all_lines.each do |thisline|
    if thisline =~ %r{(?m)</table>}
      break
    end
  end

  speaker = "EMPTY"
  started = false
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
      type = 'spoken_line'
      string = this_spoken_line
      print_spoken_line(string)
    elsif thisline =~ %r{(?m)<a\s+name="speech(\d+)">\s*<b>\s*(.*?)\s*</b>\s*</a>}
      speech_number = $1
      speaker = $2
      type = 'display_speaker'
      string = speaker
      print_new_speaker(string)
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
      print_stage_instruction(string)
    elsif thisline =~ %r{(?m)<i>\s*(.*?)\s*</i>}
      stage_instruction = $1
      type = 'stage_instruction'
      string = stage_instruction
      print_stage_instruction(string)
    elsif thisline =~ %r{(?m)<h3>\s*(ACT\s+\w+)\s*</h3>}
      thisact = $1
      type = 'display_act'
      string = thisact
      print_act(string)
    elsif thisline =~ %r{(?m)<h3>\s*(SCENE\s+[^<]*?)\s*</h3>}
      thisscene = $1
      type = 'display_scene'
      string = thisscene
      print_scene(string)
    elsif thisline =~ %r{(?m)<h3>\s*(PROLOGUE)\s*</h3>}
      thisscene = $1
      type = 'display_scene'
      string = thisscene
      print_scene(string)
    elsif thisline =~ %r{(?m)<h3>\s*(INDUCTION)\s*</h3>}
      thisscene = $1
      type = 'displayscene'
      string = thisscene
      print_scene(string)
    else
      raise "failed to parse: #{thisline}"
    end
  end
end

def print_spoken_line(string)
  print "#{string}\n"
end

def print_new_speaker(string)
  print "#{string}\n"
end

def print_stage_instruction(string)
  print "#{string}\n"
end

def print_act(string)
  print "#{string}\n"
end

def print_scene(string)
  print "#{string}\n"
end

playlist.each do |thisplay|
  parseplay(thisplay)
end
