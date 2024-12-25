local keymap = vim.keymap

keymap.set('i', '<C-c>', '<Esc>')

-- move screen left and right
keymap.set({ 'n', 'v' }, '<C-h>', '20zh')
keymap.set({ 'n', 'v' }, '<C-e>', '20zl')

-- J and K to move a line up or down (from ThePrimeagen)
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- copy to system clipboard (except also to local one? i can't get this to work properly)
keymap.set({ 'n', 'v' }, '<leader>y', '"+y')
keymap.set('n', '<leader>Y', '"+Y')
