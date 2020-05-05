using Images, ProgressMeter

include("vec3.jl")


const image_width = 256
const image_height = 256

function color(i, j)
    Vec3(i / image_width, j / image_height, 0.25)
end

function render()
    @showprogress map(
        coords -> RGB(color(coords...)...),
        [(i, j) for j = image_height:-1:1, i = 1:image_width],
    )
end

render()
