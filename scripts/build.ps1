$ProjectName = "SurfaceTool"

New-Item -ItemType Directory -Force -Path .\dist\

rojo build .\default.project.json -o .\dist\$ProjectName.rbxm
rojo build .\default.project.json -o .\dist\$ProjectName.rbxmx
