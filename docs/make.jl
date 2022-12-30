using Bip39
using Documenter

DocMeta.setdocmeta!(Bip39, :DocTestSetup, :(using Bip39); recursive=true)

makedocs(;
    modules=[Bip39],
    authors="Mattia Careddu",
    repo="https://github.com/iskyd/Bip39.jl/blob/{commit}{path}#{line}",
    sitename="Bip39.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://iskyd.github.io/Bip39.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/iskyd/Bip39.jl",
    devbranch="dev",
    branch = "gh-pages",
)
