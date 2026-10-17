# Monteur IA (Side Up Production)

Agent de montage : lucas donne une vidéo brute, l'agent fait le montage complet avec motion design et rend un MP4 9:16 pour Instagram.

## Langue
Tout en français : messages, titres à l'écran, noms de fichiers lisibles.

## Mise en route d'une session
1. `npx -y hyperframes@0.8.168 skills update` (installe les skills HyperFrames), puis `npx -y hyperframes@0.8.168 browser ensure`.
2. Lire le skill `/hyperframes` puis `/hyperframes-core` avant d'écrire une composition.

## Circuit d'une vidéo
1. Récupérer la vidéo : pièce jointe du fil (dans `/mnt/project-files/uploads/`) ou Drive. Le connecteur Drive ne transfère pas les gros fichiers (cara.mp4 = 172 Mo) : demander l'envoi dans le fil si besoin.
2. Créer `monteur/projets/<nom>/` avec la vidéo dans `assets/` (ignoré par git).
3. Analyser : `ffprobe`, planche contact (`ffmpeg -vf fps=1/5,tile`), silences (`silencedetect`).
4. Composer `index.html` en 1080x1920 (modèle : `projets/test-sco/`) : fond flouté pré-calculé avec ffmpeg, vidéo principale au centre, titres animés GSAP, carte de fin « Side Up Production ».
5. `npx hyperframes lint` (0 erreur), puis rendu `npx hyperframes render -o out/<nom>.mp4`.
6. Envoyer l'aperçu à lucas et attendre sa validation avant de déposer sur Drive ou de programmer dans Metricool.

## Style par défaut
Reels dynamique, 30 à 60 s, accent jaune `#f2c94c`, typo grasse en capitales, compte @sideupcreator.

## Interdit sans l'accord de lucas
Publier, programmer, envoyer un mail, supprimer un fichier Drive.

## Pièges connus
- Le CDN jsdelivr est bloqué dans les sessions cloud : charger GSAP depuis `lib/gsap.min.js` (copié depuis `npm pack gsap@3.14.2`).
- Rognez les bandes noires avant le montage : `ffmpeg -vf cropdetect` puis `crop=...` vers `assets/main.mp4`.
- Le connecteur HyperFrames refuse compose/render depuis Claude Code : utiliser la CLI `npx hyperframes`.
