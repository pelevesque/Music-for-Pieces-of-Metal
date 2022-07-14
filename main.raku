#!/usr/bin/env raku

sub MAIN($file) {
    my @frames = get_frames($file);
}

sub get_frames($file) {
    my @frame = [];
    my @frames = [];

    for $file.IO.lines -> $line {
        my $l = $line.trim;

          # Ignore empty lines, comments ｢-｣, and sections ｢@｣.
        unless ! $l.chars || $l ~~ /^[\-||\@]/ {

              # Create a new frame.
            if $l.starts-with('#') {
                if @frame.elems {
                    @frames.push(@frame.clone);
                    @frame = [];
                }
            }

              # Save a frame's row.
            else {
                my @row = $l.split('');
                @frame.push(@row);
            }
        }
    }

    @frames.push(@frame);

    return @frames;
}
