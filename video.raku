#!/usr/bin/env raku

sub MAIN($file) {
    my @frames = get_frames($file);

    my $svg =  SVG_open();

    for 0..8 -> $i {
        $svg ~= SVG_open-group();

        for 0..11 -> $j {
            my $x = $j * 80;
            my $y = $i * 60;
            my $color = 'black';

            if @frames[25][$i][$j] ~~ '*' {
                $color = 'red';
            }
            elsif @frames[25][$i][$j] ~~ /<[a .. z]>/ {
                $color = 'pink';
            }
            elsif @frames[25][$i][$j] ~~ /<[1 .. 9]>/ {
                $color = 'blue';
            }
            elsif @frames[25][$i][$j] ~~ /<[A .. Z]>/ {
                $color = 'green';
            }
            elsif @frames[25][$i][$j] ~~ '0' {
                $color = 'yellow';
            }

            $svg ~= SVG_make-rectangle(90, 60, $x, $y, $color);
        }

        $svg ~= SVG_close-group();
    }

    $svg ~= SVG_close();

    spurt 'angklung.svg', $svg;
}

sub SVG_make-rectangle($width, $height, $x, $y, $fill) {
    return qq:to/END/;
            <rect width="$width" height="$height" x="$x" y="$y" style="fill: $fill" />
        END
}

sub SVG_open($width = 960, $height = 540, $background-color = 'black') {
    return qq:to/END/;
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="$width"
          height="$height"
          style="background-color: $background-color"
        >
        END
}

sub SVG_close()       { return "</svg>\n" }
sub SVG_open-group()  { return "  <g>\n"  }
sub SVG_close-group() { return "  </g>\n" }

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
