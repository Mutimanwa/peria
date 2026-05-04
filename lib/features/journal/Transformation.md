1- Refactor UX global (structure produit)

Refactorise complètement le module Journal de Peria pour adopter une architecture moderne inspirée des meilleures apps de journaling (Day One, Reflectly, DailyBean). L’objectif est de transformer l’expérience en un espace émotionnel fluide, minimaliste et centré sur l’écriture. Réorganise le module autour de 4 écrans principaux :

Home Journal (dashboard léger) avec accès rapide à l’écriture, dernier entry, mood rapide et résumé du jour,
Editor immersif plein écran sans distraction avec auto-save,
Timeline / Calendar pour explorer les entrées avec indicateurs visuels (mood, activité),
Insights pour afficher tendances émotionnelles simples (mood distribution, fréquence).
Assure une navigation claire (max 4 tabs), un bouton “New Entry” toujours accessible, et une expérience sans friction où écrire est l’action principale. L’interface doit être minimaliste, douce, et réduire la charge cognitive.

2- Editor premium (le cœur de l’app)

Reconcevoir totalement l’écran JournalEditor en expérience immersive. Supprimer la logique formulaire (Title, Mood en haut, etc.) et la remplacer par un éditeur centré sur l’écriture avec les règles suivantes :

Champ texte principal fullscreen avec placeholder émotionnel
Auto-save silencieux (aucun bouton save obligatoire)
Mood selector discret (en bas ou après écriture, optionnel)
Feedback “Saved” subtil
Suppression du champ Title (ou auto-généré depuis contenu)
Ajout de prompts optionnels (“Tu veux ajouter pourquoi ?”)
Support de drafts automatiques
Possibilité d’ajouter mood + tags + contexte après écriture
Le design doit réduire la “blank page anxiety” et favoriser l’écriture rapide et naturelle.

3 — Mood system unifié et puissant

Créer un système de mood unifié pour toute l’app (Journal + Symptoms). Remplacer les strings simples par une structure centralisée avec :

id, label, icon, color, tone
support single-select par défaut (rapide)
option multi-select (avancé)
possibilité d’intensité (1–5)
Créer un composant MoodSelector réutilisable avec pills visuelles (icône + couleur + animation). Le mood doit être sélectionnable en 1 clic maximum. Ajouter une cohérence totale entre les écrans (même couleurs, même comportements). Le système doit être rapide, non intrusif et émotionnel, pas médical.

4 — Quick Log → vraie feature stratégique

Transformer le QuickLog en fonctionnalité premium. Actuellement c’est une simple card — il doit devenir un point d’entrée majeur :

Version compacte (1 ligne + bouton)
Expansion en mini-editor inline
Suggestion de prompt automatique
Sélection mood rapide (emoji ou pill)
Auto-save ou save rapide
Animation fluide d’ouverture
Option avancée : ajouter capture vocale ou “quick thought”.
Objectif : permettre d’écrire en moins de 5 secondes.

5 — Recherche intelligente + filtres

Refactoriser complètement le système de recherche :

Ajouter filtres par mood (chips cliquables)
Ajouter filtres par date (semaine, mois)
Ajouter système de tags
Highlight du texte recherché dans les résultats
Tri intelligent (récent, pertinent)
Suggestions de recherche
Transformer la recherche en outil d’exploration, pas juste un filtre texte.

6 — Timeline avancée (lecture agréable)

Améliorer la liste des entrées (JournalScreen) pour en faire une vraie timeline émotionnelle :

Groupement par jour (headers clairs)
Indicateurs visuels (mood, cycle, tags)
Preview intelligent (extrait + mots clés)
Animation légère lors de l’apparition
Ajout d’un mode “compact” et “détaillé”
Possibilité de swiper (delete, edit)
Objectif : rendre la lecture agréable et naturelle.

7 — Insights (différenciateur produit)

Créer une nouvelle page JournalInsightsPage avec :

Mood distribution (pie chart simple)
Fréquence d’écriture
Tendances (semaine / mois)
Tags les plus utilisés
Suggestions (“Tu écris souvent quand tu es fatiguée”)
Les insights doivent rester simples, non médicaux et non intrusifs

8 — Emotional UX & micro-interactions

Améliorer toute l’expérience émotionnelle :

Animations douces (fade, scale)
Feedback subtil (saved, deleted)
Microcopy humain (“Tu peux écrire ce que tu veux”)
Empty states engageants
Suppression des erreurs techniques visibles
L’app doit donner une sensation de sécurité et de calme.

9 — Tags & contextual journaling

Ajouter un système de tags personnalisables :

tags libres (user-defined)
suggestions automatiques
auto-suggestion basée sur historique
tags liés au contexte (activité, sommeil, etc.)
Les tags doivent enrichir la réflexion sans ajouter de friction.

10 — Sécurité & confiance

Renforcer la perception de sécurité :

badge “Private by default” réel (pas juste visuel)
verrouillage journal fiable
gestion locale + sync optionnel
export des données
transparence stockage
La confiance est critique dans une app de journal.