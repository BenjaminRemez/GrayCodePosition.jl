using GrayCodePosition
using Documenter

DocMeta.setdocmeta!(GrayCodePosition, :DocTestSetup, :(using GrayCodePosition); recursive=true)

makedocs(;
    modules=[GrayCodePosition],
    authors="Benjamin Remez <bremez@gmail.com>",
    sitename="GrayCodePosition.jl",
    format=Documenter.HTML(;
        canonical="https://BenjaminRemez.github.io/GrayCodePosition.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/BenjaminRemez/GrayCodePosition.jl",
    devbranch="master",
)
