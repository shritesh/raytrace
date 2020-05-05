using Images

const image_width = 256
const image_height = 256

function color(i, j)
    (i / image_width, j / image_height, 0.25)
end

function render()
    [RGB(color(i, j)...) for j = image_height:-1:1, i = 1:image_width]
end

@time render()
