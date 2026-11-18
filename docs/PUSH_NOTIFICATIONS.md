# Notifications push — préparation

État : **fondations posées, aucun serveur n'envoie encore de push.**
Les rappels actuels restent locaux (`flutter_local_notifications`) et continuent
de fonctionner exactement comme avant.

## Ce qui est en place

| Élément | Fichier |
| --- | --- |
| Permission système, jeton, écoute des messages | `lib/core/services/push_notification_service.dart` |
| Validation du contenu reçu | `lib/core/services/push_payload.dart` |
| Enregistrement du téléphone | `lib/core/repositories/user_repository.dart` (`devices`) |
| Synchronisation compte / préférence / langue | `lib/core/services/push_registration_provider.dart` |
| Préférence « Notifications push » | `AppSettings.pushEnabled` (`users/{uid}/settings/app`) |
| Interrupteur dans les réglages | `lib/features/profile/presentation/screens/notification.dart` |

### Cycle de vie

1. `main()` enregistre le handler d'arrière-plan puis initialise le service,
   une seule fois, après `Firebase.initializeApp`.
2. L'utilisateur active « Notifications push » : l'application demande la
   permission système. En cas de refus, l'interrupteur reste éteint et un
   message explique où l'autoriser.
3. Si l'utilisateur est connecté et a accepté la politique de confidentialité,
   le jeton est écrit dans `users/{uid}/devices/{sha256(jeton)}` avec la
   plateforme et la langue.
4. Le jeton est rafraîchi automatiquement (`onTokenRefresh`) et réécrit au même
   emplacement, donc sans doublon.
5. À la déconnexion, l'entrée `devices` est supprimée : un push ne peut pas
   atterrir sur le compte suivant ouvert sur le même téléphone.
6. La suppression de compte efface la sous-collection `devices` avec le reste
   (`UserRepository.userDataModules`).

### Identifiant de document

`sha256(jeton)` tronqué à 32 caractères. Le jeton brut n'est jamais utilisé comme
identifiant : un identifiant de document apparaît dans les journaux et dans la
console Firebase, et un jeton FCM suffit à envoyer des notifications.

## Contrat du message

Les pushes sont **data-only** : le texte n'est pas écrit par le serveur mais par
le téléphone, dans la langue de l'utilisateur. L'écran verrouillé ne montre donc
jamais un détail de cycle — la même règle que pour les rappels locaux.

```json
{
  "kind": "period | fertileWindow | ovulation | dailyCheckIn",
  "scheduledAt": "2026-03-10T09:00:00.000Z"
}
```

- `kind` inconnu → message ignoré.
- Date absente ou illisible → heure de réception.
- Date à plus de deux jours dans le futur → ramenée à l'heure de réception.
- Un push réutilise l'`id` d'un rappel déjà planifié localement
  (`kind-AAAA-MM-JJ`) : il ne crée pas de doublon dans le fil.

Le message reçu au premier plan devient une entrée du fil (`NotificationCenter`),
affichée immédiatement, sans bannière système superflue.

## Ce qu'il reste à faire (hors de ce lot)

1. **Clé APNs** dans la console Firebase (Apple Developer → Keys) et fichier
   `Runner.entitlements` avec `aps-environment`, référencé dans le projet Xcode.
   Aucune signature ni capability n'a été modifiée ici pour ne pas casser le
   build iOS.
2. **Fonction serveur** (Cloud Function programmée) qui lit
   `users/{uid}/settings/app`, `users/{uid}/devices` et les cycles, puis envoie
   via `messaging.sendEachForMulticast`.
3. **Nettoyage des jetons invalides** : retirer de `devices` les jetons que
   Firebase renvoie en `messaging/registration-token-not-registered`.
4. **Heures calmes** et préférences par type de rappel côté serveur, en
   réutilisant les champs déjà stockés (`notifyPeriodStarting`,
   `notifyFertileWindow`, `notifyOvulationDay`, `remindLogSymptoms`).
5. **Icone Android** de notification dédiée (petite icône monochrome) si un jour
   un payload `notification` est utilisé.
