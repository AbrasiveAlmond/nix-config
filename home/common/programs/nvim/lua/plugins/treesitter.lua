return {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects'
		},
		event = 'BufReadPost',
		build = ':TSUpdate',
		opts = {
			ensure_installed = {
				'javascript',
				'typescript',
				'html',
				'css',
				'c',
				'cpp',
				'rust',
				'java',
				'kotlin',
				'nix',
				'lua',
				'json',
				'markdown',
				'arduino',
				'asm',
				'vue',
				'python'
			},
			highlight = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						['a='] = '@assignment.outer',
						['ilh'] = '@assignment.lhs',
						['irh'] = '@assignment.rhs',
						['aut'] = '@attribute.outer',
						['iut'] = '@attribute.inner',
						['ak'] = '@block.outer',
						['ik'] = '@block.inner',
						['aca'] = '@call.outer',
						['ica'] = '@call.inner',
						['acm'] = '@comment.outer',
						['icm'] = '@comment.inner',
						['acn'] = '@conditional.outer',
						['icn'] = '@conditional.inner',
						['af'] = '@function.outer',
						['if'] = '@funciton.inner',
						['alp'] = '@loop.outer',
						['ilp'] = '@loop.inner',
						['in'] = '@number.inner',
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['art'] = '@return.outer',
						['irt'] = '@return.inner'
					}
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>]a"] = "@parameter.inner"
					},
					swap_previous = {
						["<leader>[A"] = "@parameter.inner"
					}
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_end = {
						["]a"] = "@parameter.inner"
					},
					goto_previous_end = {
						["[a"] = "@parameter.inner"
					}
				}
			}
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPost",
		config = function()
			require("treesitter-context").setup({
				trim_scope = "inner",
				max_lines = 4,
				multiline_threshold = 1
			})
		end
	}
}
