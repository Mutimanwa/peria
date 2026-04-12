import 'package:perla_app/features/educatif/data/models/education_article.dart';


/// Base de données statique des articles éducatifs
/// Couvre les 10-15 questions les plus fréquentes avec des réponses claires et utiles
class EducationArticleDatabase {
  static final List<EducationArticle> articles = [
    // ════════════════════════════════════════════════════════════════
    // AXE 1: COMPRENDRE LE CYCLE (Phases, durée, irrégularité)
    // ════════════════════════════════════════════════════════════════

    EducationArticle(
      id: 'cycle-001',
      title: 'Les 4 phases du cycle menstruel',
      shortDescription: 'Menstruation, phase folliculaire, ovulation, phase lutéale',
      axis: EducationAxis.cycleBasics,
      explanation:
          'Le cycle menstruel dure environ 28 jours (de 21 à 35 jours est normal). Il comporte 4 phases:\n\n'
          '1. Menstruation (jours 1-5): Élimination de la muqueuse utérine. Saignements rouges vifs.\n\n'
          '2. Phase folliculaire (jours 1-13): Montée d\'énergie, peau lumineuse, envie de socialiser.\n\n'
          '3. Ovulation (jour 14): Libération d\'un ovule. Température corporelle légèrement ↑. Risque maximal de grossesse.\n\n'
          '4. Phase lutéale (jours 15-28): Progestérone ↑. Peut entraîner fatigue, envies alimentaires, irritabilité.',
      observations:
          'Observez vos saignements (couleur, débit), votre énergie, humeur et douleurs.\n'
          'Un cycle régulier aide à prédire l\'ovulation et les prochaines règles.',
      advice:
          'Notez les dates de vos règles dans l\'app. Après 3 mois, vous connaîtrez votre cycle.\n'
          'Adaptez vos activités à vos phases: plus d\'exercice en phase folliculaire, du repos en phase lutéale.',
      whenToConsult:
          'Si votre cycle est régulièrement < 21 jours ou > 35 jours, consultez un professionnel.',
      tags: ['cycle', 'phases', 'menstruation', 'bases'],
      readingTimeMinutes: 6,
    ),

    EducationArticle(
      id: 'cycle-002',
      title: 'Pourquoi mon cycle est irrégulier?',
      shortDescription: 'Causes courantes des variations de cycle',
      axis: EducationAxis.cycleBasics,
      explanation:
          'Les irrégularités sont normales, surtout si vous êtes jeune. Causes courantes:\n\n'
          '• Stress: Décale ou supprime l\'ovulation (impact immédiat)\n'
          '• Changements de poids: Perte ou gain rapide affecte les hormones\n'
          '• Exercice intense: Peut retarder les règles\n'
          '• Voyage/changement de fuseau horaire: Perturbe l\'horloge biologique\n'
          '• Alimentation: Carences en fer, zinc ou calories\n'
          '• Hormones naturelles: Après grossesse, allaitement ou arrêt de contraception\n'
          '• Âge: Les cycles sont irréguliers à la puberté et à la préménopause',
      observations:
          'Notez les variations et cherchez des corrélations: avez-vous eu un événement stressant?\n'
          'Une maladie? Un changement de vie? Ces indices aident le diagnostic.',
      advice:
          'Réduisez le stress (yoga, méditation, sommeil). Maintenez un poids stable et une alimentation équilibrée. '
          'Données dans l\'app = tendances claires sur plusieurs mois.',
      whenToConsult:
          'Si l\'irrégularité persiste > 3 mois, si vous sautez 2+ règles, ou cycles < 21 ou > 35 jours.',
      tags: ['irrégularité', 'stress', 'hormones', 'cycles'],
      readingTimeMinutes: 7,
    ),

    EducationArticle(
      id: 'cycle-003',
      title: 'Durée du cycle: quand devrais-je m\'inquiéter?',
      shortDescription: 'Plages normales et signaux d\'alerte',
      axis: EducationAxis.cycleBasics,
      explanation:
          'Normal: 21–35 jours (majorité: 28 jours)\n\n'
          'Variation acceptée: Tant que l\'intervalle entre 2 règles est similaire (ex: 30 jours ± 2 jours).\n\n'
          'Signaux d\'alerte:\n'
          '• < 21 jours: Peut indiquer problème hormonal ou inflammation\n'
          '• > 35 jours: Ovulation retardée ou absente\n'
          '• Variation extrême: Passe de 23 à 40 jours = consulter\n'
          '• Arrêt complet: > 3 mois sans règles = situation urgente',
      observations:
          'Suivez 3+ cycles pour identifier VOS normes. Ne comparez pas aux autres.\n'
          'Chaque corps est différent.',
      advice:
          'Si cycles courts (< 23 jours): Plus de repos, moins de stress intense.\n'
          'Si cycles longs (> 35 jours): Assurez-vous d\'une alimentation riche en micronutriments.',
      whenToConsult:
          'Dès que vous sortez régulièrement de 21–35 jours, consultez un gynécologue.',
      tags: ['durée', 'cycle-court', 'cycle-long', 'normal'],
      readingTimeMinutes: 5,
    ),

    // ════════════════════════════════════════════════════════════════
    // AXE 2: OVULATION ET FERTILITÉ
    // ════════════════════════════════════════════════════════════════

    EducationArticle(
      id: 'fertility-001',
      title: 'Signes d\'ovulation: comment les reconnaître?',
      shortDescription: 'Température, glaire cervicale, douleur, tests',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'L\'ovulation, c\'est la libération de l\'ovule. Signes biologiques:\n\n'
          '1. Température basale ↑ de 0.4–0.8°C (mesure au réveil avant lever)\n'
          '2. Glaire cervicale devient clair, fluide, élastique (comme blanc d\'œuf)\n'
          '3. Douleur latérale basse (appelée "Mittelschmerz") pendant quelques heures\n'
          '4. Sensibilité accrue des seins\n'
          '5. Légère augmentation de libido\n\n'
          'L\'ovulation dure ~12–24h. La fenêtre fertile = 5 jours avant + jour de l\'ovulation.',
      observations:
          'Observez votre glaire chaque jour. Photographiez la texture si utile.\n'
          'Notez vos douleurs et humeur. Les signes combinent pour une image claire.',
      advice:
          'Si vous cherchez à concevoir: rapports sexuels pendant la fenêtre fertile (jours 12–16 pour cycle de 28j).\n'
          'Si vous voulez l\'éviter: abstinence pendant cette période.\n'
          'Tests d\'ovulation disponibles en pharmacie (urine) pour plus de certitude.',
      whenToConsult:
          'Si vous n\'observez aucun signe d\'ovulation pendant 3+ mois, consultez.',
      tags: ['ovulation', 'fertilité', 'glaire', 'température', 'fenêtre-fertile'],
      readingTimeMinutes: 8,
    ),

    EducationArticle(
      id: 'fertility-002',
      title: 'Fenêtre fertile: quand suis-je fertile?',
      shortDescription: 'Calcul rapide et fiable de vos jours fertiles',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'La fenêtre fertile = 5 jours AVANT ovulation + jour de l\'ovulation.\n\n'
          'Raison: L\'ovule vit 12–24h après libération, mais spermatozoïdes vivent 5 jours.\n\n'
          'Pour un cycle de 28 jours:\n'
          '• Ovulation attendue: jour 14\n'
          '• Fenêtre fertile: jours 9–14\n\n'
          'Pour un cycle de 35 jours:\n'
          '• Ovulation attendue: jour 21\n'
          '• Fenêtre fertile: jours 16–21\n\n'
          'Formule simple: Durée cycle - 14 = jour d\'ovulation (approximativement)',
      observations:
          'Votre app calcule automatiquement votre fenêtre selon vos données historiques.\n'
          'La précision ↑ avec plus de données.',
      advice:
          'Planification: Rapports sexuels tous les 2–3 jours pendant la fenêtre (sans stress du timing).\n'
          'Réduction du risque: Évitez cette période si contraception naturelle.\n'
          'Rappel: Cette méthode n\'est 100% fiable (85% avec discipline)',
      whenToConsult:
          'Si vous essayez de concevoir sans succès après 1 an (ou 6 mois si > 35 ans).',
      tags: ['fertilité', 'fenêtre-fertile', 'conception', 'grossesse'],
      readingTimeMinutes: 6,
    ),

    EducationArticle(
      id: 'fertility-003',
      title: 'Mythes sur la fertilité (démystifiés)',
      shortDescription: 'Vérités vs fausses croyances',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'MYTHE 1: "Je ne peux tomber enceinte que pendant l\'ovulation"\n'
          'VÉRITÉ: Les spermatozoïdes survivent 5 jours, donc vous êtes fertile 5 jours AVANT ovulation.\n\n'
          'MYTHE 2: "Un cycle de 28 jours = ovulation jour 14"\n'
          'VÉRITÉ: Varie énormément. L\'ovulation est 14j avant les prochaines règles (pas j14 du cycle).\n\n'
          'MYTHE 3: "Je dois avoir un orgasme pour concevoir"\n'
          'VÉRITÉ: Non scientifiquement prouvé. La fécondation est indépendante du plaisir.\n\n'
          'MYTHE 4: "La position change les chances de grossesse"\n'
          'VÉRITÉ: Peu d\'impact documenté. La constance du timing compte plus.\n\n'
          'MYTHE 5: "Je suis protégée juste après mes règles"\n'
          'VÉRITÉ: Faux! Surtout avec cycles courts, ovulation peut arriver vite.',
      observations:
          'La science evolue. Ces mythes persistent car l\'éducation sexuelle est souvent insuffisante.',
      advice:
          'Fiez-vous aux données objectives: température, glaire, signes combinés.\n'
          'L\'app vous aide à ignorer les croyances et suivre la réalité.',
      whenToConsult:
          'Si confusion persiste sur votre fertilité, parlez-en à un gynécologue ou sage-femme.',
      tags: ['mythes', 'fertilité', 'conception', 'éducation'],
      readingTimeMinutes: 6,
    ),

    // ════════════════════════════════════════════════════════════════
    // AXE 3: RÈGLES ET SYMPTÔMES
    // ════════════════════════════════════════════════════════════════

    EducationArticle(
      id: 'menstruation-001',
      title: 'Douleurs menstruelles: normal ou pas?',
      shortDescription: 'Dysménorrhée légère, modérée, sévère',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Les crampes sont dues à la contraction de l\'utérus pour éliminer la muqueuse.\n\n'
          'LÉGER (normal): Douleur sourde 1–2 jours, soulage avec chauffage.\n\n'
          'MODÉRÉ: Douleur plus intense, affecte activités mais gérable avec antidouleurs.\n'
          'Cause possible: Prostaglandines (molécules qui causent contractions).\n\n'
          'SÉVÈRE: Douleur débilitante, nausées, vomissements, sans soulagement médicaments.\n'
          'Causes possibles: Endométriose, polypes, fibromes, infection.\n\n'
          'ANORMAL: Douleur soudainement extrême si habituellement légère = consulter IMMÉDIATEMENT.',
      observations:
          'Notez: intensité (1–10), durée, jour du cycle, ce qui soulage/aggrave, symptômes associés.',
      advice:
          'LÉGER–MODÉRÉ:\n'
          '• Chauffage (coussin chauffant 20min)\n'
          '• Ibuprofène 400mg (mieux pour crampes que paracétamol)\n'
          '• Exercice léger (marche, yoga)\n'
          '• Hydratation + aliments riches en magnésium (chocolat noir, amandes)\n\n'
          'SÉVÈRE:\n'
          '• Anti-inflammatoires plus forts\n'
          '• Patches chauffants\n'
          '• Repos horizontal',
      whenToConsult:
          'Si douleur devient soudainement extrême, ou si antidouleurs inefficaces pendant 3+ mois.',
      tags: ['douleur', 'crampes', 'menstruation', 'dysménorrhée'],
      readingTimeMinutes: 7,
    ),

    EducationArticle(
      id: 'menstruation-002',
      title: 'Flux menstruel: quantités normales',
      shortDescription: 'Léger, normal, abondant - repères simples',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Un cycle menstruel normal: 30–40mL de sang (4–5 cuillères à soupe).\n\n'
          'LÉGER (5–10mL): Saignement clair, peu de tampons/serviettes, 2–3 jours.\n'
          'Possible avec: Contraception hormonale, jeune âge, stress.\n\n'
          'NORMAL (20–40mL): Flux modéré, change tout les 3–4h, 4–5 jours.\n'
          'Couleur: Rouge vif à brun foncé (normal).\n\n'
          'ABONDANT (> 40mL): Changement de protection toutes les 2h ou moins.\n'
          'Caillots > pièce de monnaie = signe de flux important.\n'
          'Causes: Fibromes, polypes, déséquilibre hormonal, défaut de coagulation.\n\n'
          'TRÈS ABONDANT (> 80mL): Saignement qui affecte vie quotidienne + anémie = urgent.',
      observations:
          'Comptez: nombre de tampons/serviettes/jours. Notez présence/absence de caillots.',
      advice:
          'LÉGER: Normal, aucune action.\n\n'
          'NORMAL: Bon équilibre, aucune action.\n\n'
          'ABONDANT:\n'
          '• Fer alimentaire ↑ (risque anémie)\n'
          '• Utilisez tampons/coupes/disques (moins de fuites)\n'
          '• Consulter pour investigation',
      whenToConsult:
          'Flux soudainement ↑, durée > 7 jours, fatigue/essoufflement (anémie), ou impact sur vie sociale.',
      tags: ['flux', 'saignement', 'abondant', 'menstruation'],
      readingTimeMinutes: 6,
    ),

    EducationArticle(
      id: 'menstruation-003',
      title: 'SPM et symptômes cycliques: c\'est psychologique?',
      shortDescription: 'Syndrome prémenstruel: causes biologiques réelles',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Non, ce n\'est PAS psychologique! Les variations hormonales causent des symptômes réels.\n\n'
          'PHASE LUTÉALE (après ovulation):\n'
          '• Progestérone ↑ → fatigue, appétit ↑, envies sucrées\n'
          '• Sérotonine ↓ → irritabilité, tristesse, anxiété\n'
          '• Sensibilité au sel ↑ → rétention d\'eau, ballonnements\n\n'
          'SYMPTÔMES COURANTS (SPM léger à modéré):\n'
          '• Fatigue, sommeil perturbé\n'
          '• Sensibilité des seins\n'
          '• Ballonnements, constipation\n'
          '• Irritabilité, anxiété, dépression légère\n'
          '• Maux de tête, migraines\n'
          '• Envies alimentaires (sucre, sel)\n\n'
          'SPM SÉVÈRE (TDPM = Trouble Dysphorique Prémenstruel):\n'
          '• Dépression ou désespoir marqués\n'
          '• Anxiété intense\n'
          '• Agressivité anormale\n'
          '• Désintérêt complet pour activités = nécessite traitement',
      observations:
          'Notez symptômes et jours. Un calendrier clair montre le lien avec le cycle.',
      advice:
          'LÉGER–MODÉRÉ:\n'
          '• Calcium + Vitamine D ↑ (études scientifiques)\n'
          '• Magésium ↑ (réduit fatigue et irritabilité)\n'
          '• Exercice aérobie 30min (améliore humeur)\n'
          '• Sommeil régulier (7–9h)\n'
          '• Sucres raffinés ↓\n\n'
          'SÉVÈRE:\n'
          '• Antidépresseurs (efficacité prouvée)\n'
          '• Thérapie cognitivo-comportementale',
      whenToConsult:
          'Si SPM affecte travail/relations ou si sévère, consultez psychiatre/gynécologue.',
      tags: ['SPM', 'prémenstruel', 'humeur', 'fatigue', 'syndrome'],
      readingTimeMinutes: 8,
    ),

    // ════════════════════════════════════════════════════════════════
    // AXE 4: NORMAL VS PAS NORMAL
    // ════════════════════════════════════════════════════════════════

    EducationArticle(
      id: 'abnormal-001',
      title: 'Pertes de sang entre les règles: quand m\'inquiéter?',
      shortDescription: 'Spotting, hémorragies, rupture de contraception',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'Léger spotting: Marques très légères, quelques gouttes, sans flux.\n\n'
          'NORMAL (spotting léger):\n'
          '• Ovulation (jour 14, quelques heures)\n'
          '• Rupture de contraception hormonale (1–2j)\n'
          '• Après rapport sexuel vigoureux (irritation cervicale)\n'
          '• Quelques jours après ovulation\n\n'
          'À SURVEILLER (spotting répété):\n'
          '• Hémorragie utérine anormale\n'
          '• Polypes ou fibromes\n'
          '• Infection\n'
          '• Problème de coagulation\n'
          '• Contraception mal adaptée\n\n'
          'URGENT:\n'
          '• Saignement abondant entre règles\n'
          '• Douleur associée\n'
          '• Perte de conscience\n'
          '• Fièvre + saignement',
      observations:
          'Notez: quantité, couleur, durée, cycle (avant/après ovulation), douleur associée.',
      advice:
          'Spotting isolé le jour d\'ovulation: Normal, observez.\n'
          'Répétition: Notez pendant 2 cycles, puis consultez.',
      whenToConsult:
          'Spotting répété entre cycles, saignement abondant entre règles, ou symptômes alarme.',
      tags: ['spotting', 'saignement', 'anormal', 'entre-règles'],
      readingTimeMinutes: 6,
    ),

    EducationArticle(
      id: 'abnormal-002',
      title: 'Odeur forte, couleur bizarre: c\'est une infection?',
      shortDescription: 'Repères pour distinguer normal d\'infection',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'NORMAL:\n'
          '• Couleur: Rouge vif → brun foncé (oxydation du sang)\n'
          '• Odeur: Légère, métallique (sang + bactéries vaginales normales)\n'
          '• Texture: Caillots OK si < pièce de monnaie\n\n'
          'SUSPECT D\'INFECTION (consultez):\n'
          '• Odeur nauséabonde, très forte (poisson pourri = Vaginose bactérienne)\n'
          '• Couleur étrange: Gris, vert\n'
          '• Pertes épaisses, mousseuses\n'
          '• Démangeaisons, brûlures mictionnelles\n'
          '• Douleur pelvienne\n'
          '+ ces symptômes = Infection probable\n\n'
          'Causes courantes:\n'
          '• Vaginose bactérienne\n'
          '• Candidose (levure)\n'
          '• IST (trichomonase, chlamydia)\n'
          '• Syndrome de Choc Toxique (TSS, rare mais grave)',
      observations:
          'Odeur d\'une personne n\'existe que pour elle-même (anosmie). Pas de honte à consulter.',
      advice:
          'Normal: Pas d\'action.\n'
          'Suspect: Rendez-vous médecin, préparez description exacte.\n'
          'TSS (rare): Fièvre > 39°C + malaise général = URGENCE',
      whenToConsult:
          'Odeur ou couleur anormale, surtout si symptômes associés (démangeaisons, douleur).',
      tags: ['odeur', 'infection', 'vaginose', 'normal'],
      readingTimeMinutes: 5,
    ),

    EducationArticle(
      id: 'abnormal-003',
      title: 'Pas de règles depuis 2-3 mois: aménorrhée',
      shortDescription: 'Quand l\'absence de règles est inquiétante',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'Aménorrhée = absence de règles > 3 mois (ou 2 cycles manqués).\n\n'
          'CAUSES NON-GRAVES (courantes):\n'
          '• Stress intense, changement de vie\n'
          '• Perte de poids rapide (< 10% du poids)\n'
          '• Exercice excessif (athlètes)\n'
          '• Changement de contraception\n'
          '• Voyage, changement de fuseau horaire\n\n'
          'CAUSES GRAVES (médicales):\n'
          '• Grossesse\n'
          '• Problème thyroïdien\n'
          '• Déséquilibre hormonal (SOPK, hyperprolactinémie)\n'
          '• Malnutrition sévère\n\n'
          'SITUATION URGENTE:\n'
          '• Aménorrhée + douleur abdominale intense = grossesse extra-utérine?\n'
          '• + perte de poids drastique = trouble alimentaire?',
      observations:
          'Notez: date du dernier cycle, événements récents (stress, perte poids, changement vie).',
      advice:
          'Test de grossesse d\'abord (même si protection).\n'
          'Si négatif: Notez facteurs de stress, poids, exercice.\n'
          'Réduisez le stress, augmentez le repos et calories si utile.',
      whenToConsult:
          'Immédiatement si douleur sévère. Sinon, si absence > 3 mois sans explication claire.',
      tags: ['aménorrhée', 'pas-de-règles', 'absence', 'hormones'],
      readingTimeMinutes: 7,
    ),

    // ════════════════════════════════════════════════════════════════
    // AXE 5: SOLUTIONS ET BIEN-ÊTRE
    // ════════════════════════════════════════════════════════════════

    EducationArticle(
      id: 'wellness-001',
      title: 'Comment soulager les crampes: techniques prouvées',
      shortDescription: 'Chauffage, exercice, suppléments, médecines alternatives',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Crampes = contractions utérines. Solutions existent, plusieurs niveaux d\'efficacité.\n\n'
          'PLUS EFFICACE (études scientifiques):\n'
          '1. Chauffage: Coussin/patch 20–30 min = réduit douleur comme ibuprofène\n'
          '2. Ibuprofène 400mg: Meilleur AINS pour crampes (pris dès premiers signes)\n'
          '3. Exercice léger: Yoga, marche = relâche prostaglandines\n\n'
          'MODÉRÉMENT EFFICACE:\n'
          '4. Acupuncture: Données mitigées mais soulage pour certaines\n'
          '5. Massage abdominal: 15–20 min soulage légèrement\n'
          '6. Magnésium: 400mg/jour = réduit de 20–30% (prendre chaque jour, pas juste avant)\n\n'
          'MOINS PROUVÉ SCIENTIFIQUEMENT:\n'
          '7. Vitamines B, oméga-3: Réduisent inflammation (long terme)\n'
          '8. Tisanes: Gingembre, cannelle légèrement utiles\n\n'
          'NON EFFICACE:\n'
          '• Repos complet (mouvements légers mieux)\n'
          '• Paracétamol seul (moins bon pour crampes que ibuprofène)',
      observations:
          'Chacun réagit différemment. Ce qui soulage l\'une ne soulage pas l\'autre.',
      advice:
          'PLAN D\'ACTION:\n'
          '1. Ibuprofène 400mg + coussin chauffant = base\n'
          '2. + léger exercice si motivée\n'
          '3. + magnésium (long terme, si récurrent)\n'
          '4. Testez acupuncture si chroniques\n\n'
          'Ne pas attendre la douleur: prenez AINS dès premiers signes.',
      whenToConsult:
          'Si douleur persiste malgré antidouleurs + chauffage, cherchez autre cause (endométriose?).',
      tags: ['soulagement', 'crampes', 'douleur', 'bien-être'],
      readingTimeMinutes: 7,
    ),

    EducationArticle(
      id: 'wellness-002',
      title: 'Alimentation et cycle: comment adapter votre assiette',
      shortDescription: 'Nutriments clés par phase du cycle',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Votre corps a des besoins différents selon la phase du cycle.\n\n'
          'PHASE MENSTRUELLE + PHASE FOLLICULAIRE (jours 1–14):\n'
          '• Fer ↑ (compensation perte sanguin): Viande rouge, légumes feuillus, lentilles\n'
          '• Calories: Augmentez légèrement (métabolisme ↓ fin phase lutéale)\n'
          '• Aliments: Légers, énergisants, colorés\n\n'
          'PHASE OVULATOIRE (jours 12–16):\n'
          '• Apports normaux: Votre métabolisme est au peak\n'
          '• Protéines: Pour soutenir hausse énergétique\n'
          '• Aliments: Frais, légers (votre système digère bien)\n\n'
          'PHASE LUTÉALE (jours 15–28):\n'
          '• Calories ↑ de 200–300kcal/jour (métabolisme basal ↑)\n'
          '• Magnésium ↑ (déficit naturel): Cacao, graines, noix\n'
          '• Sucres complexes: Riz complet, avoine (stabilisent sérotonine)\n'
          '• Aliments: Plus copieux, chauds, réconfortants\n\n'
          'À ÉVITER TOUJOURS:\n'
          '• Caféine excessive (aggrave douleurs)\n'
          '• Sucres raffinés (pics glucose → baisse → irritabilité)\n'
          '• Sodium excessif (rétention d\'eau)',
      observations:
          'Notez: aliments, humeur, énergie, douleurs. Corrélations deviennent évidentes.',
      advice:
          'Adaptez progressivement. Semaine 1–2: aliments légers + fer. Semaines 3–4: plus copieux + magnésium.\n'
          'App peut suggérer recettes par phase.',
      whenToConsult:
          'Si changements alimentaires ne soulagent pas SPM après 2 cycles, consultez nutritionniste.',
      tags: ['alimentation', 'nutrition', 'cycle', 'bien-être'],
      readingTimeMinutes: 8,
    ),

    EducationArticle(
      id: 'wellness-003',
      title: 'Exercice et cycle: quand bouger, quand reposer',
      shortDescription: 'Activités optimales par phase',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Le type d\'exercice devrait varier selon la phase pour optimiser récupération et performance.\n\n'
          'PHASE MENSTRUELLE (jours 1–5): REPOS + LÉGER\n'
          '• Estrogène/Progestérone ↓ → énergie ↓\n'
          '• Recommandé: Yoga doux, marche, stretching, Pilates\n'
          '• Évitez: Cardio intense, musculation lourde\n'
          '• Bénéfice: Chauffage + mouvement = soulagement douleur\n\n'
          'PHASE FOLLICULAIRE (jours 6–13): INTENSITÉ ↑\n'
          '• Estrogène ↑ → énergie ↑, récupération rapide\n'
          '• Recommandé: HIIT, course, crossfit, musculation progressive\n'
          '• C\'est VOTRE moment de peak performance\n\n'
          'PHASE OVULATOIRE (jours 12–16): INTENSITÉ MAX\n'
          '• Testostérone + estrogène ↑ → force, endurance optimales\n'
          '• Recommandé: Entraînements compétitifs, défis\n'
          '• Meilleur moment pour nouveaux records\n\n'
          'PHASE LUTÉALE (jours 15–28): INTENSITÉ MODÉRÉE\n'
          '• Progestérone ↑ → métabolisme ↑ mais énergie capricieuse\n'
          '• Semaine 1 (jours 15–21): Modéré, renforcement\n'
          '• Semaine 2 (jours 22–28): Léger, surtout si fatigué\n'
          '• Évitez: Entraînement excessif (risque surmenage)\n\n'
          'RÈGLE D\'OR: Écoutez votre corps. Pas forcer si fatigue ou douleur.',
      observations:
          'Notez: type exercice, intensité, comment vous vous sentez, récupération.',
      advice:
          'Adaptez progressivement. Téléchargez un calendrier cycle + exercices recommandés.\n'
          'La clé: Respect du cycle naturel = meilleures résultats LONG TERME.',
      whenToConsult:
          'Si fatigue extrême même en phase de repos, consultez pour dépistage anémie.',
      tags: ['exercice', 'sport', 'activité', 'cycle', 'bien-être'],
      readingTimeMinutes: 8,
    ),

    EducationArticle(
      id: 'wellness-004',
      title: 'Sommeil cyclique: améliorez votre repos selon votre phase',
      shortDescription: 'Horaires, qualité, hygiene du sommeil adaptés',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'La qualité du sommeil fluctue avec le cycle. Adapter vos habitudes = meilleur repos.\n\n'
          'PHASE MENSTRUELLE + PHASE FOLLICULAIRE (jours 1–14):\n'
          '• Sommeil profond normal\n'
          '• Respect horaires réguliers\n'
          '• 7–8h suffisent\n\n'
          'PHASE LUTÉALE (jours 15–28):\n'
          '• Sommeil ↓ en qualité naturellement\n'
          '• Progestérone ↑ → microréveils, sommeil léger\n'
          '• Besoin réel: 8–9h (ou plus!)\n'
          '• Couchez-vous plus tôt, pas besoin de forcer\n\n'
          'CONSEILS PHASE LUTÉALE:\n'
          '• Lumière bleue ↓ (écrans −1h avant lit)\n'
          '• Chambre plus froide (17–19°C optimal)\n'
          '• Magésium le soir (400mg) = aide endormissement\n'
          '• Évitez caféine après 14h\n'
          '• Bain chaud 1h avant lit',
      observations:
          'Notez: heure coucher/lever, qualité perçue, nombre d\'heures réelles.',
      advice:
          'Donnez-vous permission de dormir plus en phase lutéale. Ce n\'est pas paresse, c\'est biologie.',
      whenToConsult:
          'Insomnies sévères phase lutéale → Peut indiquer SPM sévère, demander aide.',
      tags: ['sommeil', 'repos', 'cycle', 'bien-être', 'qualité'],
      readingTimeMinutes: 6,
    ),
  ];

  /// Récupère tous les articles d\'une catégorie
  static List<EducationArticle> getArticlesByAxis(EducationAxis axis) {
    return articles.where((article) => article.axis == axis).toList();
  }

  /// Récupère un article par ID
  static EducationArticle? getArticleById(String id) {
    try {
      return articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Recherche par tags
  static List<EducationArticle> searchByTag(String tag) {
    return articles
        .where((article) => article.tags.contains(tag.toLowerCase()))
        .toList();
  }

  /// Retourne toutes les catégories groupées
  static List<EducationCategory> getAllCategories() {
    return [
      EducationAxis.cycleBasics,
      EducationAxis.ovulationFertility,
      EducationAxis.menstruationSymptoms,
      EducationAxis.normalVsAbnormal,
      EducationAxis.solutionsWellbeing,
    ]
        .map((axis) => EducationCategory(
          axis: axis,
          articles: getArticlesByAxis(axis),
        ))
        .toList();
  }
}
