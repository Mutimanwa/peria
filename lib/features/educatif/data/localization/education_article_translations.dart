import 'package:peria_app/features/educatif/data/models/education_article.dart';

/// English editorial copy for the educational articles. French is the source
/// version in [EducationArticleDatabase]; stable IDs keep links and reading
/// progress language-independent.
class EducationArticleTranslation {
  const EducationArticleTranslation({
    required this.title,
    required this.shortDescription,
    required this.explanation,
    required this.observations,
    required this.advice,
    required this.whenToConsult,
    required this.tags,
  });

  final String title;
  final String shortDescription;
  final String explanation;
  final String observations;
  final String advice;
  final String whenToConsult;
  final List<String> tags;
}

const Map<String, EducationArticleTranslation> _englishArticles = {
  'cycle-001': EducationArticleTranslation(
    title: "Phases of the menstrual cycle",
    shortDescription: "Menstruation, the follicular phase, ovulation and the luteal phase",
    explanation:
        "A cycle begins on the first day of a period and ends the day before the next one. Cycle length varies from person to person; 28 days is an example, not a target.\n\n"
        "A cycle is often described in terms of menstruation, the follicular phase, ovulation and the luteal phase. The follicular phase also begins on the first day of a period. Ovulation timing varies and cannot be confirmed by a calendar alone. Symptoms and cycle length can change from one cycle to another.",
    observations:
        "If you wish, note the first day of your period and any symptoms that matter to you. These notes may help you notice patterns, but they cannot provide a diagnosis.",
    advice:
        "Use the app's estimates as reference points, not as confirmation of ovulation or as contraception. Choose activities based on your comfort; you do not need to follow a different routine in each phase.",
    whenToConsult:
        "Seek advice if a change persists or worries you, if bleeding is very heavy, if pain is significant, or if pregnancy is possible after a late period.",
    tags: ["cycle", "phases", "menstruation", "basics"],
  ),
  'cycle-002': EducationArticleTranslation(
    title: "Why does my cycle vary?",
    shortDescription: "Possible factors and a cautious perspective",
    explanation:
        "The timing and length of periods can vary. Age, pregnancy, breastfeeding, hormonal contraception, illness, stress, major changes in activity or weight, and other health factors may play a role. An app cannot determine the cause of a change.",
    observations:
        "You can note dates and important changes if that helps you. A coincidence in a journal does not prove that a particular factor caused the change.",
    advice:
        "Try not to blame yourself or change a treatment on your own. If a change is new, recurring or worrying, share your notes with a healthcare professional.",
    whenToConsult:
        "Seek advice about recurring changes, missed periods or symptoms that affect daily life. If pregnancy is possible, a test and a healthcare professional's advice may help.",
    tags: ["irregularity", "stress", "hormones", "cycles"],
  ),
  'cycle-003': EducationArticleTranslation(
    title: "Cycle length: when should I seek advice?",
    shortDescription: "Personal patterns, without automatic diagnosis",
    explanation:
        "Cycle length can differ from person to person and change over time. Age, contraception and general health may affect bleeding. One cycle length or one change is not enough to diagnose a problem; apps provide estimates only.",
    observations:
        "To describe your experience, note the first day of each period and any important symptoms. Compare your own cycles instead of aiming for one universal length.",
    advice:
        "If you speak with a healthcare professional, these dates may help explain what has changed. Do not start a supplement or treatment based on an app estimate.",
    whenToConsult:
        "Seek advice if changes recur, several periods are missed, or bleeding or pain worries you. Sudden severe pain, fainting or very heavy bleeding needs urgent care.",
    tags: ["duration", "short cycle", "long cycle", "normal"],
  ),
  'fertility-001': EducationArticleTranslation(
    title: "Signs of ovulation: what can you observe?",
    shortDescription: "Possible signs that cannot confirm ovulation",
    explanation:
        "Ovulation is the release of an egg. Some people notice changes in cervical mucus or brief discomfort. Basal body temperature may rise after ovulation and help identify a pattern retrospectively. Urine tests detect a hormone change, but none of these signs alone confirms ovulation or predicts its exact day for everyone.",
    observations:
        "Only observe what feels comfortable to you. You do not need to take photos or record intimate details to use the app.",
    advice:
        "Signs and calendar predictions are not a way to prevent pregnancy. If you want to conceive or choose contraception, ask for advice suited to your situation.",
    whenToConsult:
        "Speak with a healthcare professional if you have questions about ovulation, fertility or contraception, or if symptoms worry you.",
    tags: ["ovulation", "fertility", "cervical mucus", "temperature", "fertile window"],
  ),
  'fertility-002': EducationArticleTranslation(
    title: "Fertile window: what does this estimate mean?",
    shortDescription: "Why a calendar cannot predict an exact day",
    explanation:
        "Pregnancy is possible around ovulation, but its timing varies and is difficult to predict precisely from period dates alone. Sperm can remain capable of fertilization for several days, while an egg can be fertilized for only a short time. The window shown by the app is an estimate, not a measure of your actual fertility.",
    observations:
        "Past cycles cannot guarantee the timing of the next one. A prediction may be off, even if your cycles previously seemed regular.",
    advice:
        "Do not rely on the app or a calendar to prevent pregnancy. To choose contraception or get support with conception, speak with a healthcare professional or reproductive health service.",
    whenToConsult:
        "Seek advice if you want to choose a contraceptive method, think you may be pregnant, or have questions about fertility.",
    tags: ["fertility", "fertile window", "conception", "pregnancy"],
  ),
  'fertility-003': EducationArticleTranslation(
    title: "Fertility: myths worth checking",
    shortDescription: "What dates alone cannot tell you",
    explanation:
        "Myth: a 28-day cycle always means ovulation on day 14. In reality, timing varies.\n\n"
        "Myth: pregnancy cannot happen just after a period. Dates alone cannot rule out pregnancy.\n\n"
        "An orgasm or a particular sexual position is not required for pregnancy to occur. Body signs and apps can help you track a cycle, but they do not confirm ovulation or replace contraception.",
    observations:
        "Body signs vary and can have more than one explanation. Avoid concluding that you are pregnant, infertile or ovulating based on a single sign.",
    advice:
        "For information suited to your age, health and plans, speak with a healthcare professional or reproductive health service.",
    whenToConsult:
        "Seek advice if you need contraception, pregnancy is possible, or you want to discuss fertility.",
    tags: ["myths", "fertility", "conception", "education"],
  ),
  'menstruation-001': EducationArticleTranslation(
    title: "Menstrual pain: when should I seek help?",
    shortDescription: "Pain varies; you do not have to minimize it",
    explanation:
        "Cramps may occur during a period and their intensity varies. Severe or new pain, or pain that interferes with daily activities, should be taken seriously. An app cannot determine its cause.",
    observations:
        "If you wish, note when the pain occurs, how long it lasts, how it affects your activities and what seems to help. This information may be useful in a consultation.",
    advice:
        "Heat, rest or gentle movement may help some people. Medication is not suitable for everyone: ask a pharmacist or healthcare professional and follow the instructions. Do not increase a dose on your own.",
    whenToConsult:
        "Seek advice if pain recurs, gets worse or stops you from doing everyday activities. Get urgent help for sudden severe pain, fainting, fever, or pain with bleeding when pregnancy is possible.",
    tags: ["pain", "cramps", "menstruation", "dysmenorrhea"],
  ),
  'menstruation-002': EducationArticleTranslation(
    title: "Menstrual flow: when should I seek advice?",
    shortDescription: "Notice changes without measuring millilitres",
    explanation:
        "Flow, duration and color can vary. It is difficult to measure the amount at home, and period products do not all have the same capacity. Color alone cannot diagnose a problem.",
    observations:
        "You can note bleeding days, changes from your usual pattern, leaks and how it affects your activities. You do not need to count every product precisely.",
    advice:
        "Choose products that suit you and change them according to their instructions and your comfort. If you feel weak or very tired, or your flow has changed, seek health advice rather than starting iron or another supplement on your own.",
    whenToConsult:
        "Seek advice if bleeding is much heavier or lasts longer than usual, frequently soaks through products, or affects daily life. Get urgent help if heavy bleeding comes with fainting, difficulty breathing, severe pain or marked weakness.",
    tags: ["flow", "bleeding", "heavy bleeding", "menstruation"],
  ),
  'menstruation-003': EducationArticleTranslation(
    title: "PMS: real symptoms that can vary",
    shortDescription: "Understand premenstrual symptoms without judgment",
    explanation:
        "Some people notice physical or emotional symptoms before a period; others do not. Symptoms may vary from one cycle to another. Recurring symptoms that affect daily life deserve attention. A healthcare professional can assess severe premenstrual syndrome or premenstrual dysphoric disorder; an app cannot diagnose either condition.",
    observations:
        "If it helps and feels comfortable, note symptoms and the days they occur over a few cycles. These notes alone do not prove a hormonal cause.",
    advice:
        "Rest, a sleep routine and activity suited to you may help some people. No supplement or treatment should be started automatically based on an article; seek advice suited to you before using one.",
    whenToConsult:
        "Ask for help if symptoms affect your relationships, studies, work or wellbeing. If you feel unsafe or have thoughts of harming yourself, contact someone you trust and a local health or emergency service immediately.",
    tags: ["PMS", "premenstrual", "mood", "fatigue", "syndrome"],
  ),
  'abnormal-001': EducationArticleTranslation(
    title: "Bleeding between periods: what should I do?",
    shortDescription: "Notice changes and signs that need medical advice",
    explanation:
        "Light bleeding between periods can have different causes, including contraception, cycle changes, pregnancy, infection or another health issue. Timing or color cannot tell you the cause. New or recurring bleeding deserves attention.",
    observations:
        "If you wish, note when the bleeding occurs, its approximate amount and any related symptoms. These details may help a healthcare professional.",
    advice:
        "Seek advice if bleeding recurs, happens after sex or is unusual for you. If pregnancy is possible, consider a test and ask for health advice.",
    whenToConsult:
        "Get urgent help for heavy bleeding, severe pain, fainting or fever. If pregnancy is possible and you have pain or bleeding, seek medical help promptly.",
    tags: ["spotting", "bleeding", "abnormal", "between periods"],
  ),
  'abnormal-002': EducationArticleTranslation(
    title: "Vaginal discharge and odor: when should I seek advice?",
    shortDescription: "Discharge varies; color alone cannot diagnose",
    explanation:
        "Vaginal discharge and its odor can change during the cycle. A new or persistent change, especially with itching, burning, pain or fever, may need assessment. Color or odor alone cannot identify an infection; different causes can look similar.",
    observations:
        "Note changes and any symptoms that come with them if you feel comfortable. There is no shame in seeking care; some infections need testing and appropriate treatment.",
    advice:
        "Avoid diagnosing yourself or using medicine left over from another illness. A healthcare professional may offer an examination or confidential test, depending on available services.",
    whenToConsult:
        "Seek advice for persistent changes, itching, burning or pain. Get urgent help for severe pelvic pain, fever or feeling very unwell.",
    tags: ["odor", "infection", "vaginosis", "normal"],
  ),
  'abnormal-003': EducationArticleTranslation(
    title: "Missed periods: what steps can I take?",
    shortDescription: "Several causes are possible; the app cannot diagnose them",
    explanation:
        "A missed or late period can have many causes, including pregnancy, hormonal contraception, breastfeeding, major changes in health or activity, stress or other medical conditions. Only a healthcare professional can assess the cause in your situation.",
    observations:
        "You can note the date of your last period and any important changes. This information cannot let the app confirm pregnancy or explain a late period.",
    advice:
        "If pregnancy is possible, a test may help; seek health advice to understand the result or decide what to do next. Do not change contraception or treatment on your own.",
    whenToConsult:
        "Seek advice if you miss several periods or feel worried. Get urgent help if pregnancy is possible and you have severe abdominal pain, fainting or bleeding.",
    tags: ["amenorrhea", "missed periods", "absence", "hormones"],
  ),
  'wellness-001': EducationArticleTranslation(
    title: "Cramps: options that may help",
    shortDescription: "Simple options to adapt to your comfort",
    explanation:
        "Cramps and their intensity vary. Heat, rest or gentle movement may help some people, but no general suggestion can guarantee relief for everyone.",
    observations:
        "If you wish, notice what helps or worsens the pain. Stop an activity if you feel unwell; persistent pain deserves to be taken seriously.",
    advice:
        "You could try protected heat or gentle movement if it feels right for you. For medication or supplements, ask a pharmacist or healthcare professional and follow the instructions; precautions and doses depend on the person.",
    whenToConsult:
        "Seek advice if pain returns, gets worse or interferes with your activities. Sudden severe pain, fainting, fever or feeling very unwell needs urgent care.",
    tags: ["relief", "cramps", "pain", "wellbeing"],
  ),
  'wellness-002': EducationArticleTranslation(
    title: "Food and the cycle: guidance without a prescribed diet",
    shortDescription: "You do not need a different menu for every phase",
    explanation:
        "Food needs and habits vary from person to person. You do not need a special diet for each cycle phase. A varied, sufficient diet supports general health but cannot guarantee the prevention or treatment of symptoms.",
    observations:
        "You can notice whether certain meals affect your comfort without restricting yourself or treating a coincidence as proof.",
    advice:
        "Choose varied foods that are accessible and suit your preferences and needs. If you have heavy periods, fatigue or questions about iron or other supplements, seek professional advice before taking a supplement.",
    whenToConsult:
        "Seek advice for persistent fatigue, major weight changes, difficulty eating or symptoms that worry you.",
    tags: ["food", "nutrition", "cycle", "wellbeing"],
  ),
  'wellness-003': EducationArticleTranslation(
    title: "Physical activity: listen to your body",
    shortDescription: "Choose activity for comfort, not the calendar",
    explanation:
        "There is no single exercise plan that suits everyone in every cycle phase. Energy and comfort can vary; you do not need to avoid an activity just because the app shows a particular phase. Gentle movement may help some people, but not everyone.",
    observations:
        "Notice how you feel during and after activity. Pain, fatigue or needing rest are useful information, not a lack of willpower.",
    advice:
        "Choose an activity you enjoy and adjust its intensity to how you feel that day. Take a break if you feel dizzy or weak, or if pain increases.",
    whenToConsult:
        "Seek advice if exercise regularly causes pain, dizziness or unusual fatigue, or if your symptoms interfere with your activities.",
    tags: ["exercise", "sport", "activity", "cycle", "wellbeing"],
  ),
  'wellness-004': EducationArticleTranslation(
    title: "Sleep and the cycle: simple habits",
    shortDescription: "Sleep changes are not the same for everyone",
    explanation:
        "Some people notice sleep changes around their period; others do not. Sleep needs cannot be calculated from a cycle phase, and an app cannot determine them.",
    observations:
        "If sleep concerns you, note what seems useful, such as bedtimes or waking during the night, without assuming the cycle is the only cause.",
    advice:
        "A regular routine and restful environment may help. Avoid starting supplements or changing treatment without professional advice.",
    whenToConsult:
        "Seek advice if sleep difficulties persist, affect your activities or come with significant distress.",
    tags: ["sleep", "rest", "cycle", "wellbeing", "quality"],
  ),
};

extension LocalizedEducationArticle on EducationArticle {
  EducationArticle localizedFor(String languageCode) {
    if (languageCode != 'en') return this;
    final translation = _englishArticles[id];
    if (translation == null) return this;
    return copyWith(
      title: translation.title,
      shortDescription: translation.shortDescription,
      explanation: translation.explanation,
      observations: translation.observations,
      advice: translation.advice,
      whenToConsult: translation.whenToConsult,
      tags: translation.tags,
    );
  }
}
