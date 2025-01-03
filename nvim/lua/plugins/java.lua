return {
	{
		"eatgrass/maven.nvim",
		cmd = { "Maven", "MavenExec" },
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("maven").setup({
				executable = "./mvnw", -- `mvn` should be in your `PATH`, or the path to the maven exectable, for example `./mvnw`
				cwd = nil, -- work directory, default to `vim.fn.getcwd()`
				settings = nil, -- specify the settings file or use the default settings
				commands = { -- add custom goals to the command list
					{ cmd = { "clean", "compile" }, desc = "clean then compile" },
				},
			})
		end,
	},
	{
		"oclay1st/gradle.nvim",
		cmd = { "Gradle", "GradleExec", "GradleInit" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {}, -- options, see default configuration
		keys = { { "<Leader>G", "<cmd>Gradle<cr>", desc = "Gradle" } },
	},
	{
		"elmcgill/springboot-nvim",
		depedencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-jdtls",
		},
		config = function()
			local springboot_nvim = require("springboot-nvim")
			springboot_nvim.setup({})
		end,
	},
}
