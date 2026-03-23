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

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10.8 (Dart ≥ 3.10.8)
- Un émulateur Android/iOS ou un appareil physique
- Un projet [Firebase](https://console.firebase.google.com) avec **Authentication** activé (email/password + Google)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli) pour la configuration Firebase

Vérifiez votre installation Flutter :

```bash
flutter doctor
```

## Installation

### 1. Cloner le dépôt

```bash
git clone <url-du-repo>
cd DrinkUp
```

### 2. Configurer Firebase

Le fichier `firebase_options.dart` n'est pas versionné. Vous devez le générer pour votre propre projet Firebase.

```bash
# Installer FlutterFire CLI (une seule fois)
dart pub global activate flutterfire_cli

# Connecter votre projet Firebase
flutterfire configure
```

Sélectionnez votre projet Firebase et les plateformes souhaitées (Android, iOS). Cela génère automatiquement `lib/firebase_options.dart`.

Dans la console Firebase, activez les méthodes de connexion suivantes :

- **Email / Mot de passe**
- **Google**

### 3. Installer les dépendances

```bash
flutter pub get
```

### 4. Lancer l'application

```bash
# Lister les appareils disponibles
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device-id>

# Lancer en mode release
flutter run --release
```

### Générer les icônes (optionnel)

```bash
dart run flutter_launcher_icons
```

## Stack technique

| Catégorie | Technologie |
| --- | --- |
| Framework | Flutter 3.10+ |
| State management | Riverpod 2 |
| Navigation | go_router |
| HTTP | Dio |
| Auth & Backend | Firebase Auth + Google Sign-In |
| Persistance locale | Shared Preferences |
| Images | cached_network_image |

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
