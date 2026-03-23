# DrinkUp

Application mobile Flutter combinant découverte de cocktails et jeux à boire pour animer vos soirées.

## Fonctionnalités

### Cocktails

- Recherche et navigation dans une base de cocktails via [TheCocktailDB API](https://www.thecocktaildb.com)
- Fiche détaillée : ingrédients, instructions, type de verre
- Gestion des favoris (persistance locale)

### Jeux

4 mini-jeux à jouer entre amis :

- **"Guess My Cocktail!"** — Des ingrédients se révèlent progressivement, devinez le cocktail
- **"Guess My Demon Liquid!"** — Trouvez l'alcool caché dans un cocktail à partir de son image
- **"Is It In My Cocktail?"** — Triez les ingrédients en glisser-déposer (dedans / dehors)
- **"Is Your Memory Wasted?"** — Jeu de mémoire avec des paires de cocktails

### Authentification

- Inscription / connexion par email
- Connexion Google
- Édition du profil (pseudo, photo, mot de passe)
- Liaison / déliaison de compte Google

---

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.8 (Dart ≥ 3.10.8)
- Un émulateur Android/iOS ou un appareil physique
- Un compte [Firebase](https://console.firebase.google.com)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
- Java 17 (pour le build Android)

Vérifiez votre installation :

```bash
flutter doctor
java -version
```

---

## Installation locale

### 1. Cloner le dépôt

```bash
git clone <url-du-repo>
cd DrinkUp
```

### 2. Configurer Firebase

Les fichiers `firebase_options.dart` et `android/app/google-services.json` ne sont pas versionnés. Vous devez les générer pour votre propre projet Firebase.

**a. Créez un projet Firebase** sur [console.firebase.google.com](https://console.firebase.google.com) et activez :
- Authentication → Email/Mot de passe
- Authentication → Google

**b. Installez FlutterFire CLI et configurez le projet :**

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Sélectionnez votre projet Firebase et les plateformes Android/iOS. Cela génère automatiquement `lib/firebase_options.dart` et `android/app/google-services.json`.

**c. Ajoutez le SHA-1 de votre machine dans Firebase** (nécessaire pour Google Sign-In) :

```bash
# Récupérer le SHA-1 du keystore debug local
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey \
  -storepass android -keypass android
```

Copiez la ligne `SHA1:` et ajoutez-la dans Firebase Console → Paramètres du projet → Empreintes de certificat SHA.

### 3. Installer les dépendances

```bash
flutter pub get
```

### 4. Lancer l'application

```bash
flutter devices                  # Lister les appareils disponibles
flutter run -d <device-id>       # Lancer sur un appareil
flutter run --release            # Lancer en mode release
```

### Générer les icônes (optionnel)

```bash
dart run flutter_launcher_icons
```

---

## CI/CD — Build & Release automatique

Le projet utilise GitHub Actions pour builder et publier l'APK automatiquement à chaque tag Git.

### 1. Créer un keystore de release

```bash
keytool -genkey -v -keystore drinkup-release.keystore \
  -alias drinkup -keyalg RSA -keysize 2048 -validity 10000
```

Récupérez le SHA-1 de ce keystore :

```bash
keytool -list -v -keystore drinkup-release.keystore -alias drinkup
```

Ajoutez ce SHA-1 dans Firebase Console (même endroit que l'étape précédente). C'est indispensable pour que Google Sign-In fonctionne sur l'APK de release.

### 2. Encoder le keystore en base64

```bash
base64 -w 0 drinkup-release.keystore
```

### 3. Configurer les secrets GitHub

Dans **Settings → Secrets and variables → Actions** de votre repo, ajoutez :

| Secret | Contenu |
|--------|---------|
| `GOOGLE_SERVICES_JSON` | Contenu de `android/app/google-services.json` |
| `FIREBASE_OPTIONS_DART` | Contenu de `lib/firebase_options.dart` |
| `KEYSTORE_BASE64` | Résultat de la commande base64 ci-dessus |
| `KEYSTORE_PASSWORD` | Mot de passe choisi lors de la création du keystore |
| `KEY_ALIAS` | `drinkup` (ou l'alias choisi) |

### 4. Publier une release

Une fois les secrets configurés, créez un tag Git pour déclencher le build :

```bash
git tag v1.0.0
git push origin v1.0.0
```

Le workflow génère automatiquement 3 APKs (arm64, arm32, x86_64) et les publie dans une GitHub Release. Téléchargez l'APK **arm64** pour la majorité des téléphones Android récents.

### 5. Installer l'APK

1. Téléchargez le fichier `DrinkUp-vX.X.X-arm64.apk` depuis la page Releases
2. Sur votre Android : Paramètres → Applications → votre navigateur/fichiers → Installer des applis inconnues → Autoriser
3. Ouvrez le fichier APK et installez

---

## Stack technique

| Catégorie | Technologie |
|-----------|-------------|
| Framework | Flutter 3.41+ |
| State management | Riverpod 2 |
| Navigation | go_router |
| HTTP | Dio |
| Auth & Backend | Firebase Auth + Google Sign-In |
| Persistance locale | Shared Preferences |
| Images | cached_network_image |
| CI/CD | GitHub Actions |

## Architecture

Architecture par feature :

```text
lib/
├── core/                  # Réseau, constantes, providers globaux, widgets partagés
└── features/
    ├── auth/              # Authentification
    │   ├── domain/        # Entités, use cases, interfaces
    │   ├── data/          # Modèles, datasources, implémentations
    │   └── presentation/  # Écrans (Login, Register, EditProfile)
    └── cocktails/         # Cocktails & jeux
        ├── domain/
        ├── data/
        └── presentation/  # Écrans (Home, Jeux, Favoris, Détail)
```

## Contributeurs

- **Nathan Ferré** — [nathan.ferre@ynov.com](mailto:nathan.ferre@ynov.com)
- **Laurine Camuset** — [laurine.camuset@ynov.com](mailto:laurine.camuset@ynov.com)

## Identité visuelle

- Palette : Rose `#FF486F`, Beige `#FFEF9F`, Brun foncé `#3A0E05`
- Police : CuteDino (custom)
- Design Material 3
