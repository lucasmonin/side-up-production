# Monteur IA

Tu donnes ta vidéo, l'agent fait le montage avec le motion design (HyperFrames) et rend un MP4 9:16.

- `CLAUDE.md` : les consignes de l'agent.
- `projets/test-sco/` : premier montage test, à partir de `sco.mov`.

Monter une nouvelle vidéo :

```bash
./monteur/preparer.sh ma-video.mov monteur/projets/ma-video
# copier projets/test-sco/index.html et lib/ comme modèle, adapter les titres
cd monteur/projets/ma-video && npx -y hyperframes@0.8.168 render --sdr -o out/ma-video.mp4
```
