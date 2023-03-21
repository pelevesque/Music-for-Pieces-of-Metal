#!/usr/bin/env raku

# --------------------------------------------------------------------
class SvgImg {
    has $.svg is rw;

    method open (
        $width  = 960 * 4,
        $height = 540 * 4,
        $bg-color = 'black',
    ) {
        my $inst = self.bless;
        $inst.svg = qq:to/END/;
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="$width"
              height="$height"
              style="background-color: $bg-color"
            >
            END

        return $inst;
    }

    method close       { $!svg ~= "</svg>\n"; }
    method open-group  { $!svg ~= "  <g>\n"; }
    method close-group { $!svg ~= "  </g>\n"; }

    method rectangle ($width, $height, $x, $y, $fill) {
        $!svg ~= "    <rect width='$width' height='$height'";
        $!svg ~= " x='$x' y='$y' style='fill: $fill'/>\n";
    }

}

# --------------------------------------------------------------------
sub MAIN ($data-file, $dst-dir) {
    my @frames = get_frames($data-file);

        # Keep just the basename, truncating the extension.
    (my $basename = $data-file.IO.basename) ~~ s/ '.' .* //;

    my $rect-wyd = 90;
    my $rect-hyt = 60;

    for @frames.kv -> $iFrame, @frame {
        my $img = SvgImg.open;
        for @frame.kv -> $iRow, @row {
            $img.open-group();
            for @row.kv -> $iElem, $elem {
                my $y = $iRow * $rect-hyt;
                my $x = $iElem * $rect-wyd;
                my $color = do given $elem {
                    when '*'                { 'red' }
                    when '0'                { 'yellow' }
                    when / <[a .. h]> | z / { 'pink' }
                    when / <[A .. H]> | Z / { 'green' }
                    when / <[1 .. 9]> /     { 'blue' }
                    default                 { 'black' }
                };

                $img.rectangle(
                    $rect-wyd,
                    $rect-hyt,
                    $x,
                    $y,
                    $color,
                );

                    # Last played note marker.
                $img.rectangle(
                    $rect-wyd / 2,
                    $rect-hyt / 2,
                    $x + ($rect-wyd / 4),
                    $y + ($rect-hyt / 4),
                    'purple',
                ) if $elem eq 'z' | 'Z' | 9;

            }
            $img.close-group();
        }
        $img.close;
        spurt sprintf(
            "$dst-dir/$basename.%02d.svg",
            $iFrame + 1
        ), $img.svg;
    }

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
