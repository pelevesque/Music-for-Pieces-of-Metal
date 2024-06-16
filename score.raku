sub MAIN() {
    my $file;

        # Get score frames.
    $file = 'scores/angklung.score';
    my @frames = get_frames($file, [26, 27, 44, 45, 59]);

    # Set this up.
    my $num-rows = @frames[0].elems;
}

# --------------------------------------------------------------------
sub get_frames ($score-file, $frame-numbers?) {
    my $grabbing = False;
    my @frame;
    my @frames;

    for $score-file.IO.lines -> $l {
        my $line = $l.trim;

            # Ignore empty lines, comments ｢-｣, and sections ｢@｣.
        if $line.chars && $line !~~ /^ <[-@]> / {

                # Create a new frame and set grabbing.
            if $line.starts-with: '#' {
                if @frame.elems {
                    @frames.push: @frame.clone;
                    @frame = Empty;
                }

                if (
                    ! $frame-numbers.defined ||
                    $line.comb(/\d/).join.Int ~~ any @$frame-numbers
                ) {
                    $grabbing = True;
                } else {
                    $grabbing = False;
                }
            }

            elsif $grabbing {
                    # Save a frame's row.
                my @row = $line.comb;
                @frame.push: @row;
            }
        }
    }

    if @frame.elems {
        @frames.push: @frame.clone;
    }

    return @frames;
}
