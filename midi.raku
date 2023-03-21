#!/usr/bin/env raku

# --------------------------------------------------------------------
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

# --------------------------------------------------------------------
sub get_frames ($data-file) {
    my @frame;
    my @frames;

    for $data-file.IO.lines -> $l {
        my $line = $l.trim;

            # Ignore empty lines, comments ｢-｣, and sections ｢@｣.
        if $line.chars && $line !~~ /^ <[-@]> / {

                # Create a new frame.
            if $line.starts-with: '#' {
                if @frame.elems {
                    @frames.push: @frame.clone;
                    @frame = Empty;
                }
            }

                # Save a frame's row.
            else {
                my @row = $line.comb;
                @frame.push: @row;
            }
        }
    }
    @frames.push: @frame;
    return @frames;
}

# --------------------------------------------------------------------
sub get_notes($file) {
    my %notes;

    for $file.IO.lines -> $line {
        my $l = $line.trim;

        if $l.starts-with('n') {
            my @l = $l.split(/\s+/);
            %notes{@l[0]} = @l[1];
        }
    }

    return %notes;
}

# --------------------------------------------------------------------
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
