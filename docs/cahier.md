CAHIER DES CHARGES – PERIA
Application de suivi du cycle féminin, d’éducation corporelle et de bien-être intime

1. IDENTITÉ ET VISION
Nom de l’application : Peria (à confirmer)
Slogan possible : “Ton corps, ton cycle, ton rythme”

Vision :
Créer un espace sécurisé, discret et bienveillant où chaque femme peut apprendre à connaître son corps, comprendre son cycle, suivre sa santé intime et se sentir accompagnée, sans jugement ni pression.

Valeurs fondamentales :

Bienveillance : aucun contenu culpabilisant, aucun jugement sur les choix ou le corps.

Discrétion : protection absolue des données personnelles, mode confidentiel.

Éducation : donner les clés pour comprendre, pas pour faire peur.

Autonomie : l’utilisatrice reste en contrôle de ses données et de son parcours.

Inclusivité : adaptée aux cycles irréguliers, aux adolescentes, aux femmes adultes.

Public cible :

Femmes de 13 à 50 ans (avec adaptation pour les mineures)

Priorité aux pays francophones et anglophones, puis swahili / lingala

Femmes ayant peu ou pas d’éducation sexuelle formelle

Femmes avec cycles irréguliers

Femmes en couple (fonction partenaire)

2. PERSONNALITÉ DE L’APP (ton et style)
3 adjectifs :
Douce – Savante – Discrète

Traduction en design et écriture :

Douce : couleurs pastel (rose, violet pâle), arrondis, animations fluides, illustrations 3D non agressives, notifications bienveillantes.

Savante : informations précises mais sans jargon, renvoi vers des sources ou un médecin, contenu validé par des professionnelles (à terme).

Discrète : icône neutre, accès biométrique, notifications génériques, aucune donnée partagée sans consentement, mode “carnet secret”.

Ce qu’on ne fait pas :

Ton médical froid

Jugement moral sur la sexualité ou les choix

Publicités intrusive

Promesses miracles (“prédiction parfaite”, “tomber enceinte à coup sûr”)

3. FONCTIONNALITÉS DÉTAILLÉES (par module)
3.1 Onboarding et installation
Écran	Contenu	Rôle
Welcome	Illustration + “Bienvenue sur Peria” + bouton Commencer	Accueil chaleureux
Slides	3-4 slides présentant les valeurs : suivi, éducation, bien-être, discrétion	Rassurer sur le positionnement
Création compte	Email / mot de passe (ou Google/Apple optionnel)	Identifiant minimal
Nom et date de naissance	Prénom (ou pseudo), date de naissance (pour adapter l’âge légal)	Personnalisation
Objectifs (optionnel)	“Pourquoi utilisez-vous Peria ?” (Suivre mon cycle, Mieux connaître mon corps, Tomber enceinte, Éviter une grossesse, Gérer mes douleurs, Autre)	Orienter les contenus
Dernières règles	Date du premier jour des dernières règles (ou “je ne sais pas”)	Point de départ du suivi
Confirmation	Résumé des infos + accepter la charte confidentialité	Validation
Règle métier :
Si l’utilisatrice a moins de 18 ans, demander un consentement parental (ou limiter certains contenus “plaisir”).

3.2 Module Cycle (cœur de l’app)
Accueil cycle (CycleHomeScreen actuel)

Élément	Description
Roue animée	Cercle avec 3 couches liquides (remplissage variable selon phase : règles, folliculaire, ovulation, lutéale). Animation continue, couleur par phase.
Texte central	Nom de la phase + durée (ex : “Règles – Jour 3”)
Badge sur l’anneau	Numéro du jour du cycle (positionné sur l’anneau extérieur, angle variable selon phase)
Calendrier semaine	7 jours avec le jour en cours surligné, affichage des prédictions simples
Boutons rapides	“Log Symptom” (ouvre SymptomsScreen), “Log Period” (ouvre EditCalendarScreen)
Articles suggérés	3 cartes horizontales (image + titre) sur des sujets de saison (ex : “Healthy diet”, “Skin care”, “Yoga tips”)
Calendrier mensuel (CalendarScreen)

Fonction	Description
Vue mois	Grille 7x5, avec marquage des règles, ovulation estimée, symptômes (icônes légères)
Navigation	Mois précédent / suivant
Clic sur un jour	Ouvre l’édition (EditCalendarScreen pour les règles, ou SymptomsScreen pour les symptômes)
Suivi des symptômes (SymptomsScreen)

Catégorie	Exemples
Physiques	Douleurs (localisation + intensité 1-5), seins tendus, fatigue, maux de tête, ballonnements
Émotionnels	Irritabilité, tristesse, euphorie, anxiété, calme
Autres	Glaire cervicale (optionnel), température (optionnel), poids, eau bue
Notes libres	Champ texte pour ajouter une info perso
Prédictions

Type	Règle
Prochaines règles	Calcul basé sur les 3 derniers cycles. Si irrégulier, afficher une fenêtre (ex : “entre le 8 et le 16”)
Fenêtre fertile	Affichée uniquement si l’utilisatrice l’active dans les paramètres. Mention obligatoire : “Ceci est une estimation, pas une contraception fiable”
Ovulation	Estimée à 14 jours avant la prochaine règle. Si cycle irrégulier, afficher “difficile à prévoir”
Paramètres cycle

Durée moyenne du cycle (modifiable)

Durée moyenne des règles

Notifications : rappel règles, rappel ovulation, rappel prise de pilule

Mode cycle irrégulier (désactive les prédictions strictes)

3.3 Module Assistant (IA / Chatbot)
Rôle : répondre aux questions simples, orienter vers le contenu éducatif, ne pas se substituer à un médecin.

Chatbot (AiChatScreen actuel)

Élément	Description
Persona	Prénom : “Peria” (ou “Luna”), avatar doux (cercle avec un symbole cycle), ton chaleureux mais neutre
Chat	Messages utilisatrice / assistant. Suggestions de questions sous forme de chips
Mots-clés déclencheurs	Cycle, règles, douleurs, ovulation, glaire, libido, stress, alimentation, consultation
Réponses types	Courtes (1-3 phrases), avec lien vers un article ou un conseil pratique. Si la question est médicale → “Je ne suis pas médecin. Si tu as un doute, consulte un professionnel.”
Limitations	Pas de diagnostic, pas de prescription, pas de jugement
Suggestion de questions (pills) :

“Comment fonctionne mon cycle ?”

“Pourquoi j’ai mal ?”

“Quand est-ce que j’ovule ?”

“C’est normal d’avoir des caillots ?”

“Comment soulager mes douleurs ?”

Fonctionnalités avancées (optionnelles plus tard) :

Upload de résultats de labo (l’IA interprète grossièrement et propose des liens)

Prise de rendez-vous avec un professionnel (partenaire)

Limitation importante : l’IA ne stocke pas les conversations personnelles (ou seulement localement avec consentement).

3.4 Module Journal
Rôle : espace intime et sécurisé pour noter ce qu’on ne veut pas partager.

Fonction	Description
Carnet de notes	Éditeur de texte simple, date automatique. Possibilité d’ajouter une humeur (émoji)
Verrouillage	Accès par code / empreinte digitale (paramétrable)
Recherche	Par mot-clé ou date
Export	Possibilité d’exporter ses notes en texte brut (optionnel)
Suppression	Supprimer une note ou tout le carnet
Règle de confidentialité :
Les notes ne sont jamais envoyées à un serveur. Stockage local uniquement. Pas de synchronisation cloud par défaut.

3.5 Module Éducation / Self-care (SelfCareHomeScreen actuel)
Rôle : apprendre son corps, gérer son bien-être, déconstruire les tabous.

Contenu par catégories :

Catégorie	Exemples de sujets
Comprendre son cycle	Phases, ovulation, règles, cycles irréguliers
Santé intime	Douleurs normales / anormales, glaire, infections, consultation
Bien-être	Alimentation selon le cycle, gestion du stress, sommeil
Plaisir (accès optionnel)	Anatomie du plaisir, masturbation, consentement, types d’orgasme. À débloquer par l’utilisatrice (mode “je suis majeure”)
Première règle	Témoignages anonymes, ce qui est normal, comment se préparer
Méditation / Yoga	Exercices audio ou vidéo courts (respiration, relaxation)
Skincare	Soins selon les phases (acné, peau terne)
Force / Sport	Exercices légers adaptés aux règles
Format :

Articles courts (3-5 min de lecture)

Vidéos (2-3 min)

Fiches pratiques (checklist)

Exercices guidés (respiration, mouvements)

Contenu : pour le MVP, textes statiques rédigés par toi ou des sources fiables (à valider plus tard par des professionnelles). À terme, collaboration avec des sages-femmes ou gynécologues.

3.6 Module Partenaire
Rôle : permettre à l’utilisatrice de partager certaines informations (symptômes, cycle, humeurs) avec son conjoint, de manière contrôlée.

Flows (déjà présents dans le code) :

Écran	Fonction
Gestion partenaire	Voir si un partenaire est connecté, bouton “Inviter”
Invitation	Générer un code à partager (ou lien). Le partenaire installe Peria (mode partenaire) et entre le code
Demande en attente	L’utilisatrice valide ou refuse la connexion
Connecté	Le partenaire voit ce que l’utilisatrice a accepté de partager (ex : calendrier, symptômes, notes)
Paramètres de partage	Choisir précisément ce qui est partagé : cycle, symptômes, notes, humeurs
Révoquer	À tout moment, l’utilisatrice peut couper l’accès
Règles de confidentialité :

Le partenaire ne peut pas modifier les données

Le partenaire ne voit pas l’identité des autres professionnels (médecins)

L’utilisatrice peut suspendre le partage sans supprimer la connexion

3.7 Module Paramètres et confidentialité
Section	Contenu
Profil	Prénom, date de naissance, objectifs (modifiables)
Notifications	Master toggle, rappel règles, rappel ovulation, rappel prise pilule
Sécurité	Code d’accès / biométrie, mode discret (icône + notifications), verrouillage du journal
Apparence	Thème clair / sombre, police (optionnelle)
Langue	Français, anglais, swahili, lingala (selon disponibilité)
Données	Supprimer toutes les données, exporter ses données (CSV)
À propos	Mentions légales, confidentialité, version, contact
Modes spéciaux :

Mode adolescente : désactive les contenus “plaisir”, ajoute un consentement parental

Mode cycle irrégulier : adapte les prédictions et les conseils

4. CONTRAINTES TECHNIQUES (pour mémoire, sans code)
Stockage : local par défaut (SQLite chiffré). Synchronisation cloud optionnelle plus tard (avec chiffrement de bout en bout).

Sécurité : pas de données personnelles sans consentement. Conforme RGPD (ou équivalent local).

Performances : temps de chargement des écrans < 1s. Animations fluides.

Hors ligne : l’app doit fonctionner sans internet pour le suivi de base et le journal.

5. CONTENUS ÉDUCATIFS PRIORITAIRES (à rédiger ou valider)
Thème	Titre provisoire	Public
Cycle	“Les 4 phases de ton cycle”	Toutes
Règles	“Pourquoi j’ai mal et que faire ?”	Toutes
Ovulation	“Reconnaître les signes de l’ovulation”	Toutes
Cycle irrégulier	“Mon cycle n’est pas une horloge”	Cycles longs / SOPK
Douleurs	“Quand faut-il s’inquiéter ?”	Toutes
Première règle	“Ce que j’aurais aimé savoir”	Adolescentes
Plaisir	“Le clitoris, ce grand méconnu”	+18
Consentement	“Dire oui, dire non”	Toutes
Consultation	“Comment parler à mon médecin”	Toutes
6. ROADMAP (phases)
Phase 1 (MVP actuel – déjà codé en grande partie)
✅ Onboarding

✅ Authentification (UI)

✅ Cycle home + calendrier + symptômes (UI)

✅ Assistant (UI, réponses statiques)

✅ Journal (UI, stockage local à implémenter)

✅ Self-care (UI statique)

✅ Partenaire (UI statique)

✅ Profil / paramètres (UI)

Phase 2 (connexion réelle)
Authentification fonctionnelle

Stockage local des cycles / symptômes / journal

Remplacer réponses statiques de l’IA par un moteur simple (règles)

Vérifier le mode discret et la biométrie

Phase 3 (contenu et confiance)
Rédiger les articles éducatifs (ou les faire valider par des pros)

Ajouter des vidéos courtes (exercices, méditation)

Tester avec un groupe d’utilisatrices (dont Blessing)

Corriger les bugs et améliorer l’UX

Phase 4 (ouverture)
Mode cycle irrégulier

Synchronisation cloud optionnelle

Communauté anonyme (forum modéré)

Version web ou PWA

7. INDICATEURS DE SUCCÈS (pour toi)
Objectif	Comment mesurer
L’utilisatrice se sent en sécurité	Taux de rétention, commentaires positifs sur la discrétion
Elle comprend mieux son cycle	Utilisation du calendrier, questions posées à l’IA
Elle revient régulièrement	Nombre de connexions par mois, saisie des symptômes
Elle recommande l’app	Net Promoter Score (enquête simple)
8. CE QUE TU NE DOIS JAMAIS FAIRE (valeurs non négociables)
Vendre ou partager des données personnelles

Faire de la publicité intrusive

Donner des conseils médicaux sans clause “consultez un médecin”

Juger les choix sexuels ou corporels

Minimiser les douleurs ou les inquiétudes

Promettre des prédictions parfaites (surtout cycles irréguliers)

9. RÉSUMÉ POUR GARDER LE CAP
Peria est une application douce, savante et discrète qui aide les femmes à comprendre leur cycle, leur corps et leur bien-être, sans pression ni jugement, avec une attention particulière à la confidentialité et à l’éducation.

