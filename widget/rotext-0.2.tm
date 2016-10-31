package require Tk
package require snit
package require widget::scrolledtext

# 2011 (c) Alexander Danilov  <alexander.a.danilov@gmail.com>
# Example at the end of file

snit::widgetadaptor widget::rotext {

    option -enablecopy -default true -type snit::boolean -readonly true
    delegate option * to hull
    delegate method * to hull

    constructor args {
        installhull using widget::scrolledtext

        set disabledEvents {<<Paste>> <<PasteSelection>> <<Clear>> <<Cut>>}
        $self configurelist $args
        if {!$options(-enablecopy)} {
            lappend disabledEvents {<<Copy>>}
        }
        foreach t [bind Text] {
            if {! [string match *Key* $t] && $t ni $disabledEvents} {
                bind ROText $t [bind Text $t]
            }
        }

        bind ROText <Control-Key-Tab> [bind Text <Control-Key-Tab>]
        bindtags $win.text [linsert [lsearch -all -inline -not [bindtags $win] Text] 1 ROText]
    }
}


if {[info exists argv0] && [file tail [info script]] eq [file tail $argv0]} {
    entry .e1
    entry .e2
    widget::rotext .t -bg lightblue
    entry .e3
    pack .e1 .e2 .t .e3

    bind . <Escape> exit

    .t insert end "Try to\n input something\n here, cut\n or paste text."
    .t delete 1.0 2.0
}