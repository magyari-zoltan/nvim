syn match gvHeadRef /\<HEAD\>/ contained containedin=gvMeta
syn match gvOriginMasterRef /\<origin\/master\>/ contained containedin=gvMeta
syn match gvMasterRef /\(^\|[^/]\)\zs\<master\>/ contained containedin=gvMeta
syn match gvHeadBranchRef /\%(HEAD -> \)\@<=[^,)]\+/ contained containedin=gvMeta

hi gvHeadRef ctermfg=175 guifg=#d3869b
hi gvHeadBranchRef ctermfg=214 guifg=#fabd2f
hi gvMasterRef ctermfg=109 guifg=#83a598
hi gvOriginMasterRef ctermfg=109 guifg=#83a598
