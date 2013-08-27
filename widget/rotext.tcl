package require Tk
package require snit

# 2011 (c) Alexander Danilov  <alexander.a.danilov@gmail.com>
# Example at the end of file

# todo: scroll (up, down, page up, page down) is not working

snit::widgetadaptor widget::rotext {

    delegate option * to hull
    delegate method * to hull

    constructor args {
	installhull using text

	foreach t [bind Text] {
	    if {! [string match *Key* $t] && $t ni {<<Paste>> <<PasteSelection>> <<Clear>> <<Cut>>}} {
		bind ROText $t [bind Text $t]
	    }
	}

	bind ROText <Control-Key-Tab> [bind Text <Control-Key-Tab>]
	bindtags $win [linsert [lsearch -all -inline -not [bindtags $win] Text] 1 ROText]
	$self configurelist $args
    }
}


if {[info exists argv0] && [file tail [info script]] eq [file tail $argv0]} {
    proc showFile {w {filename ""}} {
	if {$filename eq ""} {
	    set filename [tk_getOpenFile -initialfile $filename -parent .]
	}
	.t delete 0.0 end
	set f [open $filename r]
	.t insert end [read $f]
	close $f
    }

    widget::rotext .t -bg lightblue
    label .lfilename -text Filename:
    entry .filename -textvariable filename
    button .browse -text Browse -command {showFile .t}

    button .quit -text Quit -command exit

    grid .t         -         -       -     -sticky nsew
    grid .lfilename .filename .browse .quit -sticky ew

    grid rowconfigure    . .t        -weight 1
    grid columnconfigure . .filename -weight 1

    bind . <Escape> exit
    bind .filename <Return> {showFile .t $filename}

    .t insert end "Try to input something here, cut or paste text.
I create some entry widget to check focus pass using <Tab>"
}
