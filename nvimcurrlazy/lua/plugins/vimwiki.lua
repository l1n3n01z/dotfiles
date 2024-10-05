return {
  -- note, we might need dev branch for issue
  -- https://github.com/vimwiki/vimwiki/issues/1177
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      {
        path = "~/vimwiki/",
        syntax = "markdown",
        ext = ".md",
      },
      {
        path = "~/work/notes/",
        syntax = "markdown",
        ext = ".md",
      },
    }
    vim.g.vimwiki_ext2syntax = {
      [".md"] = "markdown",
      [".markdown"] = "markdown",
      [".mdown"] = "markdown",
    }
    vim.g.vimwiki_global_ext = 0
    vim.g.vimwiki_markdown_link_ext = 1
    --what is this?
    vim.g.taskwiki_markup_syntax = "markdown"
    vim.g.markdown_folding = 1
    -- turns out we don't need this, because our BROWSER env variable is set up correctly
    -- also, _G seems to be not handled anymore?
    -- vim._G.VimwikiLinkHandler = function(link)
    --   print("We are here", link)
    -- end
  end,
  -- need to add cmds because lazyness removes
  keys = {
    --see also keys for ./zk-nvim.lua
    --possibly replace vimwiki with zk ?
    --what are we actually using it for?
    --check out kiwi.nvim and wiki.vim ?
    -- call vimwiki#u#map_key('n', s:map_prefix . 'w', '<Plug>VimwikiIndex', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . 't', '<Plug>VimwikiTabIndex', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . 's', '<Plug>VimwikiUISelect', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . 'i', '<Plug>VimwikiDiaryIndex', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>i', '<Plug>VimwikiDiaryGenerateLinks', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>w', '<Plug>VimwikiMakeDiaryNote', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>t', '<Plug>VimwikiTabMakeDiaryNote', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>y', '<Plug>VimwikiMakeYesterdayDiaryNote', 2)
    -- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>m', '<Plug>VimwikiMakeTomorrowDiaryNote', 2)
    { "<leader>jw", "<Plug>VimwikiIndex<cr>", desc = "Wiki index" },
  },
}

-- " Declare global maps
-- " <Plug> global definitions
-- nnoremap <silent><script> <Plug>VimwikiIndex
--     \ :<C-U>call vimwiki#base#goto_index(v:count)<CR>
-- nnoremap <silent><script> <Plug>VimwikiTabIndex
--     \ :<C-U>call vimwiki#base#goto_index(v:count, 1)<CR>
-- nnoremap <silent><script> <Plug>VimwikiUISelect
--     \ :VimwikiUISelect<CR>
-- nnoremap <silent><script> <Plug>VimwikiDiaryIndex
--     \ :<C-U>call vimwiki#diary#goto_diary_index(v:count)<CR>
-- nnoremap <silent><script> <Plug>VimwikiDiaryGenerateLinks
--     \ :VimwikiDiaryGenerateLinks<CR>
-- nnoremap <silent><script> <Plug>VimwikiMakeDiaryNote
--     \ :<C-U>call vimwiki#diary#make_note(v:count, 5)<CR>
-- nnoremap <silent><script> <Plug>VimwikiTabMakeDiaryNote
--     \ :<C-U>call vimwiki#diary#make_note(v:count, 1)<CR>
-- nnoremap <silent><script> <Plug>VimwikiMakeYesterdayDiaryNote
--     \ :<C-U>call vimwiki#diary#make_note(v:count, 0,
--     \ vimwiki#diary#diary_date_link(localtime(), -1, v:count))<CR>
-- nnoremap <silent><script> <Plug>VimwikiMakeTomorrowDiaryNote
--     \ :<C-U>call vimwiki#diary#make_note(v:count, 0,
--     \ vimwiki#diary#diary_date_link(localtime(), 1, v:count))<CR>
-- call vimwiki#u#map_key('n', s:map_prefix . 'w', '<Plug>VimwikiIndex', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . 't', '<Plug>VimwikiTabIndex', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . 's', '<Plug>VimwikiUISelect', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . 'i', '<Plug>VimwikiDiaryIndex', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>i', '<Plug>VimwikiDiaryGenerateLinks', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>w', '<Plug>VimwikiMakeDiaryNote', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>t', '<Plug>VimwikiTabMakeDiaryNote', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>y', '<Plug>VimwikiMakeYesterdayDiaryNote', 2)
-- call vimwiki#u#map_key('n', s:map_prefix . '<Leader>m', '<Plug>VimwikiMakeTomorrowDiaryNote', 2)
