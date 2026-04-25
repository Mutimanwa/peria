🚀 PERIA – PLAN D’AMÉLIORATION PRODUCTION
🎯 OBJECTIF GLOBAL

Construire une application Flutter fiable, centrée cycle menstruel + journal + éducation, avec :

architecture clean (data / domain / presentation)
logique métier déterministe
Firestore comme backend brut
cache local uniquement pour performance offline
UX lisible et non ambiguë
🧱 1. ARCHITECTURE DES DONNÉES (PROPRE & SCALABLE)
🔥 Principe
Firestore = source brute (données non calculées)
Hive = cache local uniquement
Aucun état métier persisté calculé
📦 Structure Firestore (simplifiée et correcte)
users/{uid}
  ├── profile
  ├── period_logs
  ├── symptom_logs
  ├── journal_entries
  ├── settings
❌ À SUPPRIMER
engine_state stocké
lastPeriodStart stocké manuellement
duplication de calculs
🔁 Migration
lecture Hive → Firestore au premier lancement
validation des données migrées
suppression progressive Hive après sync réussie
🧠 2. CYCLE ENGINE (ARCHITECTURE PURE FUNCTION)
🎯 Principe

Le moteur de cycle est :

stateless
pur
déterministe
🧩 CycleEngineService
class CycleEngineService {
  CycleState computeState({
    required List<PeriodLog> logs,
    required DateTime now,
    required int cycleLength,
    required int periodLength,
  });

  DateTime computeNextPeriodStart(...);
  DateTime computeOvulation(...);
  List<DateTime> computeFertileWindow(...);
  List<DateTime> computePMS(...);
}
⚠️ RÈGLES STRICTES
aucune dépendance provider/UI
aucune écriture Firestore
aucune logique cachée
📊 CycleState (résultat calculé)
class CycleState {
  final bool isInPeriod;
  final int dayOfCycle;
  final DateTime? nextPeriodStart;
  final DateTime? ovulationDate;
  final DateTime? fertileStart;
  final DateTime? fertileEnd;
  final List<DateTime> pmsDays;
}
📅 3. CALENDRIER INTELLIGENT (UX SIMPLIFIÉE)
🎯 Objectif

Lisibilité immédiate sans surcharge visuelle

🎨 Règles d’affichage

Priorité visuelle :

🔴 période (priorité max)
🟣 fertilité
🟡 SPM
🟢 symptômes (dot discret)
📝 journal (dot discret)
❌ INTERDIT
accumulation d’emojis multiples
surcharge sur une cellule
✔ APPROCHE PROPRE
1 indicateur principal
1 badge secondaire max
🧩 Data providers UI
Set<DateTime> symptomDays;
Set<DateTime> journalDays;
✍️ 4. SYMPTÔMES (MODÈLE HYBRIDE STRUCTURÉ)
📦 Modèle propre
class SymptomLog {
  final String id;
  final DateTime date;
  final List<SymptomTag> tags;
  final String freeNotes;
  final int? intensity;
  final DateTime updatedAt;
}
🧩 Tags normalisés
enum SymptomTag {
  pain,
  fatigue,
  mood,
  digestion,
  breastTenderness,
  sleep
}
✔ RÈGLES PRODUIT
freeNotes obligatoire
tags optionnels
aucune restriction utilisateur
données exploitables analytics
📓 5. JOURNAL (VERSION PRODUIT)
📦 Structure
class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final int? mood;
  final bool isLocked;
  final int cycleDay;
}
✔ AMÉLIORATIONS
accès direct depuis calendrier (📝)
affichage indicateur jour
navigation fluide calendrier → journal
⚠️ 6. GESTION D’ERREURS (ARCHITECTURE CENTRALISÉE)
❌ PROBLÈME ACTUEL

logique répétée dans UI

✔ SOLUTION PRO
class AppErrorHandler {
  static void showError(AppError error);
  static void showRetry(AppError error, VoidCallback retry);
  static void showLoading(String message);
}
UX STANDARD
succès → SnackBar court
erreur → SnackBar + retry
critique → dialog bloquant
loading → skeleton/spinner
📚 7. MODULE ÉDUCATION (DYNAMIQUE & SÉCURISÉ)
📦 Source unique

Firestore + cache Hive

📄 Structure article
class EducationArticle {
  final String id;
  final String title;
  final String category;
  final String explanation;
  final String advice;
  final String whenToConsult;
  final int difficulty;
  final int readingTimeMinutes;

  final int version;
  final bool medicallyValidated;
  final DateTime lastUpdated;
}
⚠️ RÈGLE IMPORTANTE
pas de contenu hardcodé
versioning obligatoire
validation médicale requise
🧪 8. TESTS (COUVERTURE RÉELLE)
✔ UNIT TESTS
CycleEngine (cas extrêmes)
logs désordonnés
cycles irréguliers
✔ WIDGET TESTS
calendrier icônes
journal lock/unlock
symptômes sauvegarde
✔ INTEGRATION TESTS
migration Hive → Firestore
sync offline → online
cohérence multi-mois
🔐 9. SÉCURITÉ (PRODUCTION READY)
Firestore Rules
match /users/{uid}/{documents=**} {
  allow read, write: if request.auth.uid == uid;
}
✔ AJOUTS OBLIGATOIRES
journal verrouillé (PIN/biométrie)
données jamais publiques
mode discret activé par défaut
aucune exposition cross-user
🚀 10. PRIORITÉ D’IMPLÉMENTATION
🔴 CRITIQUE
refactor Firestore structure
CycleEngine pure function
migration Hive → Firestore
🟠 HAUTE PRIORITÉ
calendrier simplifié
symptômes structurés
journal intégré calendrier
🟡 MOYENNE PRIORITÉ
error handler centralisé
module éducation dynamique
🟢 FINALISATION
tests complets
hardening sécurité
✅ DÉFINITION DE “PRODUCTION READY”
aucune logique métier dans UI
Firestore uniquement brut
moteur cycle 100% déterministe
calendrier lisible instantanément
données médicalement structurées
erreurs centralisées
offline support fiable