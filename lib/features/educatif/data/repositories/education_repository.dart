import 'package:peria_app/features/educatif/data/models/education_article.dart';

/// Static, reviewed-for-risk educational copy.
///
/// This content has not yet been clinically reviewed or formally sourced.
/// See docs/EDUCATION_CONTENT_REVIEW.md before publishing medical claims.
class EducationArticleDatabase {
  static final List<EducationArticle> articles = [
    // Cycle basics
    EducationArticle(
      id: 'cycle-001',
      title: 'Les phases du cycle menstruel',
      shortDescription:
          'Menstruation, phase folliculaire, ovulation et phase lutéale',
      axis: EducationAxis.cycleBasics,
      explanation:
          'Le cycle commence le premier jour des règles et se termine la veille '
          'des règles suivantes. Sa durée varie selon les personnes; 28 jours '
          'est un exemple, pas une norme à atteindre.\n\n'
          'On décrit souvent les règles, la phase folliculaire, l’ovulation et '
          'la phase lutéale. La phase folliculaire commence aussi le premier '
          'jour des règles. Le moment de l’ovulation varie et ne peut pas être '
          'confirmé par un calendrier seul. Les sensations et la durée peuvent '
          'changer d’un cycle à l’autre.',
      observations:
          'Si tu le souhaites, note le premier jour des règles et les symptômes '
          'qui comptent pour toi. Ces notes peuvent aider à repérer des tendances, '
          'mais ne permettent pas de poser un diagnostic.',
      advice:
          'Utilise les estimations de l’application comme des repères, pas comme '
          'une confirmation de l’ovulation ou une méthode de contraception. '
          'Choisis tes activités selon ton confort; il n’est pas nécessaire de '
          'suivre un programme différent à chaque phase.',
      whenToConsult:
          'Demande conseil si un changement persiste ou t’inquiète, si les '
          'saignements sont très abondants, si la douleur est importante, ou '
          'si une grossesse est possible après un retard de règles.',
      tags: ['cycle', 'phases', 'menstruation', 'bases'],
      readingTimeMinutes: 5,
    ),
    EducationArticle(
      id: 'cycle-002',
      title: 'Pourquoi mon cycle varie-t-il ?',
      shortDescription: 'Des facteurs possibles et des repères prudents',
      axis: EducationAxis.cycleBasics,
      explanation:
          'La durée et le moment des règles peuvent varier. L’âge, une grossesse, '
          'l’allaitement, une contraception hormonale, une maladie, le stress, '
          'des changements importants d’activité ou de poids, ainsi que d’autres '
          'facteurs de santé peuvent jouer un rôle. Une application ne peut pas '
          'déterminer la cause d’une variation.',
      observations:
          'Tu peux noter les dates et les changements importants si cela t’aide. '
          'Une coïncidence dans le journal ne prouve pas qu’un facteur a causé '
          'la variation.',
      advice:
          'Évite de te blâmer ou de modifier seule un traitement. Si une variation '
          'est nouvelle, se répète ou t’inquiète, apporte tes notes à un '
          'professionnel de santé.',
      whenToConsult:
          'Demande conseil en cas de changements répétés, de règles manquantes '
          'ou de symptômes qui perturbent ta vie quotidienne. Si une grossesse '
          'est possible, un test et un avis de santé peuvent aider.',
      tags: ['irrégularité', 'stress', 'hormones', 'cycles'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'cycle-003',
      title: 'Durée du cycle : quand demander conseil ?',
      shortDescription: 'Des repères personnels, sans diagnostic automatique',
      axis: EducationAxis.cycleBasics,
      explanation:
          'La durée d’un cycle peut différer d’une personne à l’autre et changer '
          'au cours de la vie. L’âge, la contraception et la santé générale '
          'peuvent modifier les saignements. Une seule durée ou variation ne '
          'suffit pas à diagnostiquer un problème; les applications donnent '
          'uniquement des estimations.',
      observations:
          'Pour décrire ton expérience, note le premier jour de chaque période '
          'de règles et tout symptôme important. Compare tes propres cycles '
          'plutôt que de te fixer sur une durée universelle.',
      advice:
          'Si tu consultes, ces dates peuvent aider à raconter ce qui a changé. '
          'Ne commence pas de complément ou de traitement sur la base d’une '
          'estimation de l’application.',
      whenToConsult:
          'Demande conseil si les changements se répètent, si plusieurs règles '
          'manquent, ou si les saignements ou la douleur t’inquiètent. Une douleur '
          'soudaine et intense, un évanouissement ou des saignements abondants '
          'nécessitent une aide urgente.',
      tags: ['durée', 'cycle-court', 'cycle-long', 'normal'],
      readingTimeMinutes: 4,
    ),

    // Ovulation and fertility
    EducationArticle(
      id: 'fertility-001',
      title: 'Ovulation : quels signes peut-on observer ?',
      shortDescription: 'Des indices possibles, qui ne confirment pas l’ovulation',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'L’ovulation est la libération d’un ovule. Certaines personnes remarquent '
          'des changements de glaire cervicale ou une gêne passagère. La '
          'température basale peut augmenter après l’ovulation et aider à repérer '
          'une tendance a posteriori. Les tests urinaires repèrent une variation '
          'hormonale, mais aucun de ces signes ne confirme à lui seul une '
          'ovulation ni ne prédit précisément le jour pour tout le monde.',
      observations:
          'Observe seulement ce avec quoi tu es à l’aise. Il n’est pas nécessaire '
          'de prendre des photos ou de consigner des détails intimes pour utiliser '
          'l’application.',
      advice:
          'Les signes et les prévisions du calendrier ne sont pas une méthode '
          'pour éviter une grossesse. Si tu souhaites concevoir ou choisir une '
          'contraception, demande un conseil adapté à ta situation.',
      whenToConsult:
          'Parle à un professionnel de santé si tu as des questions sur '
          'l’ovulation, la fertilité ou la contraception, ou si des symptômes '
          't’inquiètent.',
      tags: ['ovulation', 'fertilité', 'glaire', 'température', 'fenêtre-fertile'],
      readingTimeMinutes: 5,
    ),
    EducationArticle(
      id: 'fertility-002',
      title: 'Fenêtre fertile : que signifie cette estimation ?',
      shortDescription: 'Pourquoi le calendrier ne peut pas prédire un jour exact',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'Une grossesse est possible autour de l’ovulation, mais son moment '
          'varie et il est difficile à prévoir exactement à partir des seules '
          'dates des règles. Les spermatozoïdes peuvent rester fécondants '
          'plusieurs jours et l’ovule ne l’est que pendant une courte période. '
          'La fenêtre affichée par l’application est une estimation, pas une '
          'mesure de la fertilité réelle.',
      observations:
          'Les cycles passés ne garantissent pas le moment du prochain cycle. '
          'Une prévision peut être décalée, même si les cycles semblaient '
          'réguliers auparavant.',
      advice:
          'Ne te fie pas à l’application ou au calendrier pour éviter une '
          'grossesse. Pour choisir une contraception ou obtenir de l’aide pour '
          'concevoir, parle à un professionnel de santé ou à un service de santé '
          'reproductive.',
      whenToConsult:
          'Demande conseil si tu veux choisir une méthode contraceptive, si tu '
          'penses être enceinte ou si tu as des questions sur la fertilité.',
      tags: ['fertilité', 'fenêtre-fertile', 'conception', 'grossesse'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'fertility-003',
      title: 'Fertilité : quelques idées reçues à vérifier',
      shortDescription: 'Ce que les dates seules ne permettent pas de savoir',
      axis: EducationAxis.ovulationFertility,
      explanation:
          'Idée reçue : un cycle de 28 jours signifie toujours une ovulation au '
          'jour 14. En réalité, le moment varie.\n\n'
          'Idée reçue : on ne peut pas tomber enceinte juste après les règles. '
          'Les dates seules ne permettent pas d’exclure une grossesse.\n\n'
          'Un orgasme ou une position sexuelle particulière n’est pas nécessaire '
          'pour qu’une grossesse survienne. Les signes corporels et les '
          'applications peuvent aider à suivre un cycle, mais ne confirment pas '
          'l’ovulation et ne remplacent pas une contraception.',
      observations:
          'Les signes corporels varient et peuvent avoir plusieurs explications. '
          'Évite de conclure à une grossesse, à une infertilité ou à une ovulation '
          'sur la base d’un seul signe.',
      advice:
          'Pour une information adaptée à ton âge, ta santé et tes projets, '
          'adresse-toi à un professionnel de santé ou à un service de santé '
          'reproductive.',
      whenToConsult:
          'Demande conseil si tu as besoin d’une contraception, si une grossesse '
          'est possible ou si tu souhaites parler de fertilité.',
      tags: ['mythes', 'fertilité', 'conception', 'éducation'],
      readingTimeMinutes: 4,
    ),

    // Periods and symptoms
    EducationArticle(
      id: 'menstruation-001',
      title: 'Douleurs menstruelles : quand demander de l’aide ?',
      shortDescription: 'La douleur varie; tu n’as pas à la minimiser',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Des crampes peuvent survenir pendant les règles et leur intensité '
          'varie. Une douleur forte, nouvelle ou qui gêne les activités mérite '
          'd’être prise au sérieux. Une application ne peut pas en déterminer '
          'la cause.',
      observations:
          'Si tu le souhaites, note quand la douleur arrive, combien de temps '
          'elle dure, son effet sur tes activités et ce qui semble t’aider. '
          'Ces informations peuvent faciliter une consultation.',
      advice:
          'Une source de chaleur, du repos ou des mouvements doux peuvent '
          'soulager certaines personnes. Les médicaments ne conviennent pas à '
          'tout le monde : demande conseil à un pharmacien ou à un professionnel '
          'de santé et suis la notice. N’augmente pas une dose de toi-même.',
      whenToConsult:
          'Demande conseil si la douleur revient, s’aggrave ou t’empêche de vivre '
          'normalement. Cherche une aide urgente en cas de douleur soudaine et '
          'intense, d’évanouissement, de fièvre, ou de douleur avec saignement '
          'lorsqu’une grossesse est possible.',
      tags: ['douleur', 'crampes', 'menstruation', 'dysménorrhée'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'menstruation-002',
      title: 'Flux menstruel : quand demander conseil ?',
      shortDescription: 'Observer les changements sans mesurer en millilitres',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Le flux, sa durée et sa couleur peuvent varier. Il est difficile de '
          'mesurer le volume à la maison, et les protections n’ont pas toutes la '
          'même capacité. La couleur seule ne permet pas de diagnostiquer un '
          'problème.',
      observations:
          'Tu peux noter les jours de saignement, les changements par rapport à '
          'ton habitude, les fuites et l’effet sur tes activités. Il n’est pas '
          'nécessaire de compter précisément chaque protection.',
      advice:
          'Choisis les protections qui te conviennent et change-les selon leur '
          'notice et ton confort. Si tu te sens faible ou très fatiguée, ou si le '
          'flux a changé, demande un avis de santé plutôt que de commencer du fer '
          'ou un autre complément seule.',
      whenToConsult:
          'Demande conseil si les saignements sont beaucoup plus abondants ou '
          'plus longs que d’habitude, s’ils traversent souvent tes protections '
          'ou perturbent ta vie quotidienne. Cherche une aide urgente si des '
          'saignements abondants s’accompagnent d’évanouissement, de difficulté '
          'à respirer, de douleur intense ou d’une grande faiblesse.',
      tags: ['flux', 'saignement', 'abondant', 'menstruation'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'menstruation-003',
      title: 'SPM : des symptômes réels et variables',
      shortDescription: 'Comprendre les symptômes avant les règles sans se juger',
      axis: EducationAxis.menstruationSymptoms,
      explanation:
          'Certaines personnes remarquent des symptômes physiques ou émotionnels '
          'avant les règles; d’autres non. Ils peuvent varier d’un cycle à '
          'l’autre. Des symptômes qui reviennent et affectent le quotidien '
          'méritent d’être écoutés. Un professionnel peut évaluer un syndrome '
          'prémenstruel sévère ou un trouble dysphorique prémenstruel; une '
          'application ne peut pas poser ce diagnostic.',
      observations:
          'Si cela t’aide et ne te met pas mal à l’aise, note les symptômes et '
          'les jours concernés pendant quelques cycles. Ces notes ne prouvent '
          'pas à elles seules une cause hormonale.',
      advice:
          'Le repos, une routine de sommeil et une activité adaptée peuvent '
          'aider certaines personnes. Il n’existe pas de complément ou de '
          'traitement à prendre automatiquement sur la base d’un article; '
          'demande un avis adapté avant d’en utiliser un.',
      whenToConsult:
          'Demande de l’aide si les symptômes affectent tes relations, tes '
          'études, ton travail ou ton bien-être. Si tu te sens en danger ou as '
          'des pensées de te faire du mal, contacte immédiatement une personne '
          'de confiance et un service de santé ou d’urgence local.',
      tags: ['SPM', 'prémenstruel', 'humeur', 'fatigue', 'syndrome'],
      readingTimeMinutes: 4,
    ),

    // When to seek care
    EducationArticle(
      id: 'abnormal-001',
      title: 'Saignements entre les règles : que faire ?',
      shortDescription: 'Repérer les changements et les signes qui nécessitent un avis',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'De petites pertes de sang entre les règles peuvent avoir différentes '
          'causes : contraception, variations du cycle, grossesse, infection ou '
          'autre problème de santé. Le moment ou la couleur ne permet pas de '
          'connaître la cause. Un saignement nouveau ou répété mérite attention.',
      observations:
          'Si tu le souhaites, note quand le saignement survient, sa quantité '
          'approximative et les symptômes associés. Ces détails peuvent aider '
          'un professionnel de santé.',
      advice:
          'Demande conseil si le saignement se répète, survient après un rapport '
          'sexuel ou est inhabituel pour toi. Si une grossesse est possible, '
          'envisage un test et demande un avis de santé.',
      whenToConsult:
          'Cherche une aide urgente en cas de saignement abondant, de douleur '
          'intense, d’évanouissement ou de fièvre. Si une grossesse est possible '
          'et qu’il y a douleur ou saignement, demande rapidement une aide '
          'médicale.',
      tags: ['spotting', 'saignement', 'anormal', 'entre-règles'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'abnormal-002',
      title: 'Pertes vaginales et odeur : quand demander conseil ?',
      shortDescription: 'Les pertes varient; la couleur seule ne pose pas de diagnostic',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'Les pertes vaginales et leur odeur peuvent varier au cours du cycle. '
          'Une modification nouvelle ou persistante, surtout avec démangeaisons, '
          'brûlures, douleur ou fièvre, peut nécessiter une évaluation. La '
          'couleur ou l’odeur seules ne permettent pas d’identifier une infection; '
          'différentes causes peuvent se ressembler.',
      observations:
          'Note les changements et les symptômes qui les accompagnent si tu es '
          'à l’aise. Il n’y a pas de honte à demander des soins; certaines '
          'infections nécessitent un test et un traitement adapté.',
      advice:
          'Évite de poser toi-même un diagnostic ou d’utiliser un traitement '
          'restant d’une autre maladie. Un professionnel de santé peut proposer '
          'un examen ou un test confidentiel selon les services disponibles.',
      whenToConsult:
          'Demande conseil pour des changements persistants, des démangeaisons, '
          'des brûlures ou une douleur. Cherche une aide urgente en cas de forte '
          'douleur pelvienne, de fièvre ou de malaise important.',
      tags: ['odeur', 'infection', 'vaginose', 'normal'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'abnormal-003',
      title: 'Règles manquantes : quelles étapes ?',
      shortDescription: 'Plusieurs causes sont possibles; l’application ne les diagnostique pas',
      axis: EducationAxis.normalVsAbnormal,
      explanation:
          'L’absence ou le retard des règles peut avoir plusieurs causes, dont '
          'une grossesse, une contraception hormonale, l’allaitement, des '
          'changements importants de santé ou d’activité, le stress ou d’autres '
          'conditions médicales. Seul un professionnel peut évaluer la cause '
          'dans ton contexte.',
      observations:
          'Tu peux noter la date des dernières règles et tout changement '
          'important. Ces informations ne permettent pas à l’application de '
          'confirmer une grossesse ni d’expliquer le retard.',
      advice:
          'Si une grossesse est possible, un test peut être utile; demande un '
          'avis de santé pour interpréter le résultat ou choisir la suite. Ne '
          'modifie pas seule une contraception ou un traitement.',
      whenToConsult:
          'Demande conseil si plusieurs règles manquent ou si cela t’inquiète. '
          'Cherche une aide urgente si une grossesse est possible et que tu as '
          'une douleur abdominale intense, un évanouissement ou des saignements.',
      tags: ['aménorrhée', 'pas-de-règles', 'absence', 'hormones'],
      readingTimeMinutes: 4,
    ),

    // Wellbeing
    EducationArticle(
      id: 'wellness-001',
      title: 'Crampes : des pistes de soulagement',
      shortDescription: 'Des options simples à adapter à ton confort',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Les crampes et leur intensité varient. Une source de chaleur, du '
          'repos ou des mouvements doux peuvent aider certaines personnes, '
          'mais aucun conseil général ne garantit un soulagement pour tout le '
          'monde.',
      observations:
          'Si tu le souhaites, remarque ce qui t’aide ou aggrave la douleur. '
          'Arrête une activité si tu te sens mal; une douleur persistante mérite '
          'd’être prise au sérieux.',
      advice:
          'Tu peux essayer une source de chaleur protégée ou des mouvements '
          'doux si cela te convient. Pour un médicament ou un complément, '
          'demande conseil à un pharmacien ou à un professionnel de santé et '
          'suis la notice; les contre-indications et les doses dépendent de la '
          'personne.',
      whenToConsult:
          'Demande conseil si la douleur revient, s’aggrave ou perturbe tes '
          'activités. Une douleur soudaine et intense, un évanouissement, une '
          'fièvre ou un malaise important nécessitent une aide urgente.',
      tags: ['soulagement', 'crampes', 'douleur', 'bien-être'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'wellness-002',
      title: 'Alimentation et cycle : repères sans régime imposé',
      shortDescription: 'Pas besoin d’un menu différent pour chaque phase',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Les besoins et les habitudes alimentaires varient d’une personne à '
          'l’autre. Il n’est pas nécessaire de suivre un régime spécial à '
          'chaque phase du cycle. Une alimentation variée et suffisante contribue '
          'à la santé générale, sans garantir la prévention ou le traitement '
          'des symptômes.',
      observations:
          'Tu peux remarquer si certains repas influencent ton confort, sans '
          'te restreindre ni considérer une coïncidence comme une preuve.',
      advice:
          'Choisis des aliments accessibles et variés selon tes goûts et tes '
          'besoins. En cas de règles abondantes, de fatigue ou de question sur '
          'le fer ou d’autres compléments, demande un avis professionnel avant '
          'de prendre un supplément.',
      whenToConsult:
          'Demande conseil en cas de fatigue persistante, de changement de poids '
          'important, de difficulté à manger ou de symptômes qui t’inquiètent.',
      tags: ['alimentation', 'nutrition', 'cycle', 'bien-être'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'wellness-003',
      title: 'Activité physique : écouter son corps',
      shortDescription: 'Choisir une activité selon son confort, pas le calendrier',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Il n’existe pas un programme d’exercice adapté à toutes les personnes '
          'pour chaque phase du cycle. L’énergie et le confort peuvent varier; '
          'tu n’as pas besoin d’éviter une activité uniquement parce que '
          'l’application indique une phase donnée. Des mouvements doux '
          'soulageront certaines personnes, mais pas toutes.',
      observations:
          'Remarque comment tu te sens pendant et après l’activité. La douleur, '
          'la fatigue ou le besoin de repos sont des informations utiles, pas '
          'un manque de volonté.',
      advice:
          'Choisis une activité qui te plaît et adapte l’intensité à ton état '
          'du jour. Fais une pause si tu te sens étourdie, faible ou si la '
          'douleur augmente.',
      whenToConsult:
          'Demande un avis si l’exercice provoque régulièrement douleur, '
          'étourdissements ou fatigue inhabituelle, ou si tes symptômes '
          'perturbent tes activités.',
      tags: ['exercice', 'sport', 'activité', 'cycle', 'bien-être'],
      readingTimeMinutes: 4,
    ),
    EducationArticle(
      id: 'wellness-004',
      title: 'Sommeil et cycle : des habitudes simples',
      shortDescription: 'Les changements de sommeil ne sont pas identiques pour toutes',
      axis: EducationAxis.solutionsWellbeing,
      explanation:
          'Certaines personnes remarquent des changements de sommeil autour '
          'des règles; d’autres non. Les besoins de sommeil ne se calculent pas '
          'à partir d’une phase du cycle et une application ne peut pas les '
          'déterminer.',
      observations:
          'Si le sommeil te préoccupe, note ce qui te semble utile, comme les '
          'horaires ou les réveils, sans chercher une cause unique dans le cycle.',
      advice:
          'Une routine régulière et un environnement reposant peuvent aider. '
          'Évite de commencer des compléments ou de modifier un traitement sans '
          'avis professionnel.',
      whenToConsult:
          'Demande conseil si les difficultés de sommeil persistent, affectent '
          'tes activités ou s’accompagnent d’une détresse importante.',
      tags: ['sommeil', 'repos', 'cycle', 'bien-être', 'qualité'],
      readingTimeMinutes: 3,
    ),
  ];

  /// Returns all articles for a category.
  static List<EducationArticle> getArticlesByAxis(EducationAxis axis) {
    return articles.where((article) => article.axis == axis).toList();
  }

  /// Returns an article by its stable identifier.
  static EducationArticle? getArticleById(String id) {
    for (final article in articles) {
      if (article.id == id) return article;
    }
    return null;
  }

  /// Returns articles whose tags include [tag], ignoring case.
  static List<EducationArticle> searchByTag(String tag) {
    final normalizedTag = tag.toLowerCase();
    return articles
        .where((article) => article.tags.any(
              (articleTag) => articleTag.toLowerCase() == normalizedTag,
            ))
        .toList();
  }

  /// Returns all categories in their display order.
  static List<EducationCategory> getAllCategories() {
    return EducationAxis.values
        .map(
          (axis) => EducationCategory(
            axis: axis,
            articles: getArticlesByAxis(axis),
          ),
        )
        .toList();
  }
}
