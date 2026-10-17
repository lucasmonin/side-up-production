#!/usr/bin/env bash
# Prépare une vidéo brute pour le Monteur.
# Usage : ./preparer.sh <video> <dossier-projet>
# Produit <projet>/assets/main.mp4 (SDR bt709, sans bandes noires, 1080 de large)
# et <projet>/assets/bg.mp4 (fond flouté 1080x1920, sans son).
set -euo pipefail
src="$1"; proj="$2"
mkdir -p "$proj/assets" "$proj/out"

# 1. HDR iPhone (HLG / PQ, bt2020) : on retague en bt709, sinon HyperFrames passe en rendu HDR et casse la mise en page.
trc=$(ffprobe -v error -select_streams v:0 -show_entries stream=color_transfer -of csv=p=0 "$src" || true)
color=""
if [[ "$trc" == "arib-std-b67" || "$trc" == "smpte2084" ]]; then
  echo "HDR détecté ($trc) : conversion en bt709"
  color="setparams=color_primaries=bt709:color_trc=bt709:colorspace=bt709,"
fi
tags=(-color_primaries bt709 -color_trc bt709 -colorspace bt709)

# 2. Bandes noires
crop=$(ffmpeg -v info -ss 2 -i "$src" -t 8 -vf cropdetect=24:2:0 -f null - 2>&1 \
  | grep -o "crop=[0-9:]*" | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')
crop="${crop:-crop=iw:ih:0:0}"
echo "Recadrage : $crop"

# 3. Vidéo principale (garde le son) et fond flouté
ffmpeg -v error -y -i "$src" -vf "${color}${crop},scale=1080:-2" -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p "${tags[@]}" -c:a aac -b:a 192k "$proj/assets/main.mp4"
ffmpeg -v error -y -i "$src" -an -vf "${color}${crop},scale=-2:1920,crop=1080:1920,boxblur=30:3,eq=brightness=-0.25:saturation=1.2" -c:v libx264 -crf 28 -preset veryfast -pix_fmt yuv420p "${tags[@]}" "$proj/assets/bg.mp4"

ffprobe -v error -select_streams v:0 -show_entries stream=width,height:format=duration -of compact "$proj/assets/main.mp4"
echo "Prêt. Rendu : cd $proj && npx -y hyperframes@0.8.168 render --sdr -o out/<nom>.mp4"
