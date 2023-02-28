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
      print "#{this_spoken_line}\n"
    elsif thisline =~ %r{(?m)<a\s+name="speech(\d+)">\s*<b>\s*(.*?)\s*</b>\s*</a>}
      speech_number = $1
      speaker = $2
    elsif thisline =~ %r{(?m)<blockquote>}
      print "#{speaker}: "
    elsif thisline =~ %r{(?m)</blockquote>}
      #print "ENDSPEECH\n"
      next
    elsif thisline =~ %r{(?m)^\s*$}
      #print "EMPTYLINE\n"
      next
    elsif thisline =~ %r{(?m)<p>\s*<i>\s*(.*?)\s*</i>\s*</p>}
      stage_instruction = $1
      #print "STAGEINSTRUCTION: #{stage_instruction}\n"
    elsif thisline =~ %r{(?m)<i>\s*(.*?)\s*</i>}
      stage_instruction = $1
      #print "STAGEINSTRUCTION: #{stage_instruction}\n"
      print "#{stage_instruction}\n"
    elsif thisline =~ %r{(?m)<h3>\s*(ACT\s+\w+)\s*</h3>}
      thisact = $1
      #print "BEGINACT: #{thisact}"
      type = 'displayact'
      string = thisact
      print "#{thisact}"
    elsif thisline =~ %r{(?m)<h3>\s*(SCENE\s+[^<]*?)\s*</h3>}
      thisscene = $1
      type = 'displayscene'
      string = thisscene
      print "#{thisscene}"
    elsif thisline =~ %r{(?m)<h3>\s*(PROLOGUE)\s*</h3>}
      thisscene = $1
      type = 'displayscene'
      #speaker = "PROLOGUE"
      #print "PROLOGUESPEAKER"
      string = thisscene
      print "#{thisscene}"
    elsif thisline =~ %r{(?m)<h3>\s*(INDUCTION)\s*</h3>}
      thisscene = $1
      type = 'displayscene'
      #print "PROLOGUESPEAKER"
      string = thisscene
      print "#{thisscene}"
    else
      #print "OTHER"
      raise "failed to parse: #{thisline}"
    end
  end
end

playlist.each do |thisplay|
  parseplay(thisplay)
end
