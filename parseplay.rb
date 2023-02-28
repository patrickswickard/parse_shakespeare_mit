require 'json'

playlist = Dir.glob('original/*.html')

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
      print "#{thisact}"
    elsif thisline =~ %r{(?m)<h3>\s*(SCENE\s+[^<]*?)\s*</h3>}
      thisscene = $1
      print "#{thisscene}"
    elsif thisline =~ %r{(?m)<h3>\s*(PROLOGUE)\s*</h3>}
      speaker = "PROLOGUE"
      #print "PROLOGUESPEAKER"
    elsif thisline =~ %r{(?m)<h3>\s*(INDUCTION)\s*</h3>}
      speaker = "INDUCTION"
      #print "PROLOGUESPEAKER"
    else
      #print "OTHER"
      raise "failed to parse: #{thisline}"
    end
  end
end

playlist.each do |thisplay|
  parseplay(thisplay)
end
