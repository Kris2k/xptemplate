XPTemplate priority=lang

let s:f = g:XPTfuncs()


XPTinclude
      \ _common/common


fun! s:f.fff()
  let v = self.V()
  if v == 'aa'
    return ''
  else
    return ', another'
  endif
endfunction




XPTemplateDef



XPT bb " tips
XSET cursor=123
what `a^ `cursor^

XPT q " tips
XSET $a=3
`p`{$a}`p^-`p^

XPT x " tips
XSET $a=3
`p`p`p^-`p^

XPT t " tips
XSET $a=5
`:x({ 'p' : '\`{$a}\`' }):^

XPT aa " paste at end test
`f^`aa...{{^pp`}}^`l^Echo( Context().history[-1].item.name )^
