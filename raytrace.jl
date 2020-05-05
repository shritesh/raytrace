using Images

function render(image_width = 256, image_height = 256)
    [
        RGB(i / image_width, j / image_height, 0.2)
        for j = image_height:-1:1, i = 1:image_width
    ]
end

render()
