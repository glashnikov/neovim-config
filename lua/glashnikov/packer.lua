-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Fuzzy finder / Telescope
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	-- Colorscheme
	use ({ 
		"rose-pine/neovim", 
		as = "rose-pine",
		config = function() 
			vim.cmd('colorscheme rose-pine')
		end 
	})

	-- treesitter
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

	-- harpoon
	use('theprimeagen/harpoon')
	
	-- undotree
	use('mbbill/undotree')

	-- fugitive
	use({'lewis6991/gitsigns.nvim',
	config = function() 
		require('gitsigns').setup({
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, {expr=true})

				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, {expr=true})

				-- Actions
				map({'n', 'v'}, '<leader>gs', ':Gitsigns stage_hunk<CR>')
				map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
				map('n', '<leader>gS', gs.stage_buffer)
				map('n', '<leader>gu', gs.undo_stage_hunk)
				map('n', '<leader>gR', gs.reset_buffer)
				map('n', '<leader>gp', gs.preview_hunk)
				map('n', '<leader>gb', function() gs.blame_line{full=true} end)
				map('n', '<leader>gtb', gs.toggle_current_line_blame)
				map('n', '<leader>gd', gs.diffthis)
				map('n', '<leader>gD', function() gs.diffthis('~') end)
				map('n', '<leader>gtd', gs.toggle_deleted)

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end
		})
	end})
end)