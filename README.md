# parse_shakespeare_mit

This includes moderately cleaned up files from http://shakespeare.mit.edu/ 

These are in a nice format and regular enough (after some cleanup) to read in, parse into a json file, and manipulate.

The script parseplay.rb reads the files into json files (one per play), convering them into a series of events.

The json files can be used to analyze, manipulate, or reprint the plays in a nice format similar to the original.

The script printplay.rb takes the json files created by parseplay as an input and outputs an html version similar to the original that was parsed.

Both of these scripts are works in progress.  Data may be further cleaned up and scripts may be reformatted or simplified, given more functionality, etc.
