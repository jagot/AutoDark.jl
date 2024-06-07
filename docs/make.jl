using AutoDark
using Documenter

DocMeta.setdocmeta!(AutoDark, :DocTestSetup, :(using AutoDark); recursive=true)

makedocs(;
    modules=[AutoDark],
    authors="Stefanos Carlström <stefanos.carlstrom@gmail.com> and contributors",
    sitename="AutoDark.jl",
    format=Documenter.HTML(;
        canonical="https://jagot.github.io/AutoDark.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jagot/AutoDark.jl",
    devbranch="main",
)
