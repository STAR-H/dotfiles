return {
  default_config = {
    single_file_support = true,
    useLibraryCodeForTypes = false,

    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = false,
          typeCheckingMode = "basic",
          diagnosticMode = 'openFilesOnly',
        },
        pythonPath = "/opt/homebrew/bin/python3"
      },
    },
  },
}
