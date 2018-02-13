XPTemplate priority=lang mark=~^

let s:f = g:XPTfuncs()

XPTvar $TRUE          1
XPTvar $FALSE         0
XPTvar $NULL          NULL
XPTvar $UNDEFINED     NULL

XPTvar $VOID_LINE     # void
XPTvar $CURSOR_PH     # cursor


XPTvar $BRif          ' '
XPTvar $BRel          \n
XPTvar $BRloop        ' '
XPTvar $BRstc         ' '
XPTvar $BRfun         ' '

XPTvar $SPop          ''
XPTvar $SParg         ''

XPTinclude
      \ _common/common
      \ _printf/c.like

XPTvar $CS    #
XPTinclude
      \ _comment/singleSign


" ========================= Function and Variables =============================

let s:braceMap = {
            \   '`' : '`',
            \   '{' : '}',
            \   '[' : ']',
            \   '(' : ')',
            \  '{{' : '}}',
            \  '[[' : ']]',
            \  '((' : '))',
            \  '{ ' : ' }',
            \  '[ ' : ' ]',
            \  '( ' : ' )',
            \ '{{ ' : ' }}',
            \ '[[ ' : ' ]]',
            \ '(( ' : ' ))',
            \}

fun! s:f.sh_complete_brace()

    let v = self.V()
    let br = matchstr( v, '\V\^\[\[({`]\{1,2} \?' )
    if br == ''
        return ''
    elseif br == '`'
        return s:braceMap[ br ]
    else
        try
            let cmpl = s:braceMap[ br ]
            let cmplEsc = substitute( cmpl, ']', '\\[]]', 'g' )
            let tail = matchstr( v, '\V\%[' . cmplEsc . ']\$' )
            if tail == ' ' && br =~ ' '
                let tail = ''
            endif
            return cmpl[ len( tail ) : ]
        catch /.*/
            echom v:exception
        endtry
    endif

endfunction

" ================================= Snippets ===================================




XPT shebang " #!/bin/[ba|z|c]sh
XSET sh=ChooseStr( 'sh', 'bash', 'zsh', 'csh' )
#!/bin/~sh^

..XPT

XPT sb alias=shebang

XPT _shebang hidden " #!/bin/$_xSnipName
#!/bin/~$_xSnipName^

..XPT

XPT set_euo_pipefail " set -euo pipefail
set -euo pipefail # set exit on error, error use unitialized pipe fail error propagates

..XPT


XPT sh   alias=_shebang
XPT bash alias=_shebang
XPT zsh  alias=_shebang
XPT csh  alias=_shebang
XPT sane  alias=set_euo_pipefail


XPT echodate " echo `date +%...`
echo `date~ +~fmt^`

XPT _cond hidden
XSET condition|map=[ [
XSET condition|map=( (
~condition^~condition^sh_complete_brace()^


XPT printf	" printf\(...)
XSET elts|pre=Echo('')
XSET elts=c_printf_elts( R( 'pattern' ), ' '[ len( $SPop ) : ] )
printf "~pattern^"~elts^

XPT vars " special variables explanation
# $@, $*   # all aruments of script/function
# $1,..,$9 # n-th argument of script
# $?       # return value of last executed command
# $$       # pid of current process

XPT usage " usage function
PROGRAM=${0}
usage(){
cat <<EOF
    Usage: ${PROGRAM} [options] text

    options:
    -h, --help             dispaly this help
    -d, --dir=directory    cow directory [default] ${COW_DIR}

    text                   text the cows should display
EOF
}

XPT getopt
OPTIONS=$(getopt -o hd: --long help,dir: -- "$@")
if [ $? != 0 ] ; then
    echo "Parse options error  ..." 1>&2
    usage
    exit 1
fi
eval set -- "$OPTIONS"

while true ; do
    case "$1" in
    -h|--help)
        usage
        exit 0
        shift
        ;;
    -d|--dir)
        DIR=$2
        shift 2
        ;;
    --)
        shift
        break
    esac
done
# if at least one agument is needed even after getopt
if [ $# -lt 1 ] ; then
    echo "Not enough arguments" 1>&2
    usage
    exit 1
fi



XPT forin wrap " for .. in ..; do
for ~i^ in ~list^;~$BRloop^do
    ~cursor^
done

XPT for wrap " for (( i=0; i<len; i++ )); do
for ((~i^ = ~0^; ~i^ < ~len^; ~i^++));~$BRloop^do
    ~cursor^
done

XPT forr wrap " for (( i=n; i>=start; i++ )); do
for ((~i^ = ~n^; ~i^ >~=^ ~start^0^; ~i^--));~$BRloop^do
    ~cursor^
done

XPT here wrap " << END ..
<<~-~END^
~cursor^
~END^substitute( V(), '\v\^-', '', '' )^

XPT until wrap " until ..; do
until ~:_cond:^;~$BRloop^;do
    ~cursor^
done

XPT while wrap " while ..; do
while ~:_cond:^;~$BRloop^do
    ~cursor^
done

XPT while1 alias=while " while [ 1 ]; do
XSET condition=Next( '[ ~$TRUE^ ]' )

XPT case wrap " case .. in ..
case ~$~var^ in
    ~pattern^)
    ~cursor^
    ;;

esac

XPT if wrap " if ..; then
if ~:_cond:^;~$BRif^then
    ~cursor^
fi

XPT else wrap " else ..
else
    ~cursor^

XPT ife wrap=job " if ..; then .. else ..
if ~:_cond:^;~$BRif^then
    ~job^
else
    ~cursor^
fi

XPT elif wrap " elif .. ; then
elif ~:_cond:^;~$BRif^then
    ~cursor^

XPT fun wrap " .. () { .. }
~name^ ()~$BRfun^{
    ~cursor^
}
