# Monteur IA

Tu donnes ta vidéo, l'agent fait le montage avec le motion design (HyperFrames) et rend un MP4 9:16.

- `CLAUDE.md` : les consignes de l'agent.
- `projets/test-sco/` : premier montage test, à partir de `sco.mov`.

Rendre un projet :

```bash
cd monteur/projets/test-sco
mkdir -p assets && cp ../../../sco.mov assets/source.mov
ffmpeg -y -i assets/source.mov -vf "crop=1920:812:0:134,scale=1080:-2" -c:v libx264 -crf 18 -c:a aac assets/main.mp4
ffmpeg -y -i assets/source.mov -an -vf "crop=1920:812:0:134,scale=-2:1920,crop=1080:1920,boxblur=30:3,eq=brightness=-0.25:saturation=1.2" -c:v libx264 -crf 28 -pix_fmt yuv420p assets/bg.mp4
npx -y hyperframes@0.8.168 render -o out/test-sco.mp4
```
