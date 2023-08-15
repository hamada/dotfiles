vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', { noremap = true })
-- if you yank words, it's shared with clipboard
vim.opt.clipboard = 'unnamed'
