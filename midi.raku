#!/usr/bin/env raku

use MIDI::Make;

    # Note: Must be divisible by 2.
constant $PPQ = 960;

# --------------------------------------------------------------------
sub MAIN() {
    my $file;

        # Get score frames.
    $file = 'scores/angklung.score';
    my @frames = get_frames($file);

        # Get interpretative notes.
    $file = 'interpretations/angklung.interpretation';
    my %notes = get_notes($file);
    my $bpm = +($file.IO.slurp ~~ / ^^ bpm  \s+ (\d+) /)[0];
    my $nlen_percentage = +($file.IO.slurp ~~ / ^^ nlen \s+ ([\d+.]+) /)[0];

        # Variables.
    my $slot-length = ($PPQ / 2).Int;
    my $note-length = ($slot-length * $nlen_percentage).floor;
    my $rest-length = $slot-length - $note-length;

        # Setup MIDI.
    my $s  = Song.new(:PPQ($PPQ));
    my $t_tempo-map = Track.new(:name('tempo map'));
    my $t_voice1 = Track.new(:name('voice 1'), :ch(0));
    my $t_voice2 = Track.new(:name('voice 2'), :ch(1));
    my $t_voice3 = Track.new(:name('voice 3'), :ch(2));
    my $t_voice4 = Track.new(:name('voice 4'), :ch(3));
    my $t_voice5 = Track.new(:name('voice 5'), :ch(4));

        # Set panning
    $t_voice1.pan: 64;
    $t_voice2.pan: 40;
    $t_voice3.pan: 88;
    $t_voice4.pan: 10;
    $t_voice5.pan: 118;

        # Set tempo-map infos.
    $t_tempo-map.copyright: "Copyright 2023 Pierre-Emmanuel Levesque";
    $t_tempo-map.tempo: ♩$bpm;

    sub add_tempo-map-event ($marker, $time?) {
        $t_tempo-map.marker: $marker;
        $t_tempo-map.time($time) if $time.defined;
    }

    sub add_note-event ($track, $key) {
        if $key > -1 {
            $track.note-on: +%notes{$key};
            $track.dt: $note-length;
            $track.note-off: +%notes{$key};
            $track.dt: $rest-length;
        } else {
            $track.dt: $track.dt + $slot-length;
        }
    }

    for @frames.kv -> $iFrame, @frame {

            # Add tempo-map changes.
        given $iFrame {
            when 0  { add_tempo-map-event( 'Intro',   6\4 )}
            when 1  { add_tempo-map-event( 'I'            )}
            when 26 { add_tempo-map-event( 'I Tutti'      )}
            when 28 { add_tempo-map-event( 'II',      4\4 )}
            when 44 { add_tempo-map-event( 'II Tutti'     )}
            when 46 { add_tempo-map-event( 'III',     3\4 )}
        }

        for ^4 {
            for ^@frame[0].elems -> $iCol {

                $t_tempo-map.dt: $t_tempo-map.dt + $slot-length;

                my ($v1, $v2, $v3, $v4, $v5) = -1 xx *;

                for @frame.kv -> $iRow, @row {
                    given @row[$iCol] {
                        when '0'                { $v1 = $iRow }
                        when '*'                { $v2 = $iRow }
                        when / <[A .. H]> | Z / { $v3 = $iRow }
                        when / <[1 .. 9]>     / { $v4 = $iRow }
                        when / <[a .. h]> | z / { $v5 = $iRow }
                    }
                }

                add_note-event($t_voice1, $v1);
                add_note-event($t_voice2, $v2);
                add_note-event($t_voice3, $v3);
                add_note-event($t_voice4, $v4);
                add_note-event($t_voice5, $v5);
            }
        }
    }

        # Save MIDI file.
    $t_tempo-map.marker: 'End';
    $s.add-track($t_tempo-map.render);
    $s.add-track($t_voice1.render);
    $s.add-track($t_voice2.render);
    $s.add-track($t_voice3.render);
    $s.add-track($t_voice4.render);
    $s.add-track($t_voice5.render);
    spurt 'file.mid', $s.render;
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

        if $l ~~ / ^^ n\d+ \s+ \d+ / {
            my @l = $l.split(/\s+/);
            %notes{@l[0].substr(1)} = @l[1];
        }
    }

    return %notes;
}
