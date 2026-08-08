" ------------------------------------------------------------------------------
" Színkódok
" ------------------------------------------------------------------------------
"
" Ez a parancs megadja, a kurzor poziciójában lévő karktert melyik syntax
" group szinezi ki:
"
" :echo synIDattr(synID(line('.'), col('.'), 1), 'name')
"
" #fabd2f   " Yellow
" #d65d0e   " Orange
" #fb4934   " Red
" #d3869b   " Magenta
" #7fa2ac   " Blue
" #83a598   " Cyan
" #98971a   " Green
" ------------------------------------------------------------------------------


" ------------------------------------------------------------------------------
" HEAD 
" ------------------------------------------------------------------------------
" \<                A szó eleje
" \>                A szó vége
" ------------------------------------------------------------------------------
syn match gvHeadRef /\<HEAD\>/ contained containedin=gvMeta
hi gvHeadRef ctermfg=175 guifg=#d3869b   " Magenta

" ------------------------------------------------------------------------------
" origin/HEAD
" ------------------------------------------------------------------------------
" \<                A szó eleje
" \>                A szó vége
" ------------------------------------------------------------------------------
syn match gvOriginHeadRef /\<origin\/HEAD\>/ contained containedin=gvMeta
hi gvOriginHeadRef ctermfg=175 guifg=#d3869b   " Magenta

" ------------------------------------------------------------------------------
" master 
" ------------------------------------------------------------------------------
" \(^\|[^/]\)       A sor eleje legyen: ^ vagy egy olyan karakter, ami nem /
" \zs               A tényleges match innen kezdődjön
" \<                A szó eleje
" \>                A szó vége
" ------------------------------------------------------------------------------
syn match gvMasterRef /\(^\|[^/]\)\zs\<master\>/ contained containedin=gvMeta
hi gvMasterRef ctermfg=203 guifg=#fb4934   " Red

" ------------------------------------------------------------------------------
" origin/master 
" ------------------------------------------------------------------------------
" \<                A szó eleje
" \>                A szó vége
" ------------------------------------------------------------------------------
syn match gvOriginMasterRef /\<origin\/master\>/ contained containedin=gvMeta
hi gvOriginMasterRef ctermfg=203 guifg=#fb4934   " Red

" ------------------------------------------------------------------------------
" Checked out branch
" ------------------------------------------------------------------------------
" \%(HEAD -> \)     Egy nem-rögzítő csoport \%( ... \), ami ezt a konkrét 
"                   szöveget jelenti: HEAD ->
"
" \@<=              Pozitív lookbehind Vim regexben. Azt mondja: csak akkor 
"                   legyen találat, ha közvetlenül előtte HEAD -> áll.
"
" [^,)]\+           Egy vagy több olyan karakter, ami nem: , )
" ------------------------------------------------------------------------------
syn match gvHeadBranchRef /\%(HEAD -> \)\@<=[^,)]\+/ contained containedin=gvMeta
hi gvHeadBranchRef ctermfg=166 guifg=#d65d0e   " Orange

" ------------------------------------------------------------------------------
" tag
" ------------------------------------------------------------------------------
" \%(tag: \)        Egy nem-rögzítő csoport \%( ... \), ami ezt a konkrét 
"                   szöveget jelenti: 'tag: '
"
" \@<=              Pozitív lookbehind Vim regexben. Azt mondja: csak akkor 
"                   legyen találat, ha közvetlenül előtte 'tag: ' áll.
" ------------------------------------------------------------------------------
syn match gvTagRef /\%(tag: \)\@<=[^,)]\+/ contained containedin=gvMeta,gvTag
hi gvTagRef ctermfg=100 guifg=#98971a   " Green

" ------------------------------------------------------------------------------
"  date
" ------------------------------------------------------------------------------
" [0-9]\{4\}        4 digits
" [0-9]\{2\}        2 digits
" \<                A szó eleje
" \>                A szó vége
" ------------------------------------------------------------------------------
syn match gvDateRef /\<[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\>/ contained containedin=gvDate
hi gvDateRef ctermfg=214 guifg=#fabd2f   " Yellow

" ------------------------------------------------------------------------------
" author
" ------------------------------------------------------------------------------
" (                 Literális nyitó kerek zárójel.
"
" [^()]*            Nulla vagy több olyan karakter, ami nem '(' és nem ')'.
"
" \%(               Nem-rögzítő csoport kezdete. A teljes belső '(...)' részt
"                   egy egységként kezeli.
"
" (                 Literális belső nyitó kerek zárójel.
"
" [^()]*            Nulla vagy több olyan karakter a belső zárójelen belül,
"                   ami nem '(' és nem ')'.
"
" )                 Literális belső záró kerek zárójel.
"
" \)                A \%( ... \) nem-rögzítő csoport vége.
"
" \?                Az előtte álló teljes belső '(...)' csoport opcionális.
"
" [^()]*            Nulla vagy több további olyan karakter, ami nem '(' és
"                   nem ')'.
"
" )                 Literális külső záró kerek zárójel.
"
" $                 A találatnak a sor végén kell végződnie.
"
" ------------------------------------------------------------------------------
syn match gvAuthorRef /([^()]*\%(([^()]*)\)\?[^()]*)$/ contained containedin=gvAuthor,gvMessage
hi gvAuthorRef ctermfg=108 guifg=#83a598   " Cyan
