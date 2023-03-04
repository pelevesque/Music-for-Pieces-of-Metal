#!/usr/bin/env raku

sub MAIN() {
    my $file;

        # Get score frames.
    $file = 'scores/angklung.score';
    my @frames = get_frames($file);

        # Get interpretative notes.
    $file = 'interpretations/angklung.interpretation';
    my %notes = get_notes($file);
    my $tempo = get_tempo($file);
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
                my @row = $l.comb;
                @frame.push(@row);
            }
        }
    }

    @frames.push(@frame);

    return @frames;
}

sub get_notes($file) {
    my %notes;

    for $file.IO.lines -> $line {
        my $l = $line.trim;

        if $l.starts-with('n') {
            my @l = $l.split(' ');
            %notes{substr(@l[0], 1)} = @l[1], @l[2];
        }
    }

    return %notes;
}

sub get_tempo($file) {
        # Default.
    my $tempo = 60;

    for $file.IO.lines -> $line {
        my $l = $line.trim;

        if $l.starts-with('bpm') {
            my @l = $l.split(' ');
            $tempo = @l[1];
        }
    }

    return $tempo;
}
